import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:mobx/mobx.dart';
import 'package:shazy/core/init/cache/cache_manager.dart';
import 'package:shazy/core/init/network/network_manager.dart';
import 'package:shazy/models/user/user_profile_model.dart';
import 'package:shazy/services/comment/comment_service.dart';
import 'package:shazy/services/user/user_service.dart';
import 'package:shazy/utils/constants/app_constant.dart';
import 'package:shazy/utils/constants/navigation_constant.dart';
import 'package:shazy/utils/helper/helper_functions.dart';

import '../../../core/init/navigation/navigation_manager.dart';
import '../../../models/comment/comment_model.dart';
import '../../../models/user/user_model.dart';

part 'profile_controller.g.dart';

class ProfileController = _ProfileControllerBase with _$ProfileController;

abstract class _ProfileControllerBase with Store {
  @observable
  List<CommentModel> commentList = [];

  @observable
  String description = '';

  @observable
  String email = '';

  @observable
  String imagePath = '';

  @observable
  bool isAnotherProfile = true;

  @observable
  bool lisanceVertification = false;

  @observable
  String name = '';

  @observable
  String reviews = '0';

  @observable
  String star = '0.0';

  UserProfileModel? userProfile;

  @action
  Future<void> init(BuildContext context, {String? id}) async {
    try {
      id ??= await SessionManager().get('id') as String;
      if (id != '') {
        await _getUserProfileModel(id);
        commentList = await CommentService.instance.getAntoherUserComment(id);
      } else {
        throw Exception();
      }
    } catch (e) {
      if (context.mounted) {
        HelperFunctions.instance.showErrorDialog(
            context, 'profilePageError'.tr(), 'backHome'.tr(), () {
          NavigationManager.instance
              .navigationToPageClear(NavigationConstant.homePage);
        });
      }
    }
  }

  Future<void> updateUserProfile(
      BuildContext context, UserProfileModel model) async {
    try {
      String? email = await CacheManager.instance.getData('user', 'email');
      var id = await SessionManager().get('id');
      String? responseRegiserControl;
      if (email != model.userModel?.email) {
        responseRegiserControl = await UserService.instance
            .registerControl(UserModel(email: model.userModel?.email));
        if (responseRegiserControl != null &&
            responseRegiserControl != '200' &&
            context.mounted) {
          HelperFunctions.instance.showErrorDialog(
              context, responseRegiserControl, 'backHome'.tr(), () {
            NavigationManager.instance
                .navigationToPageClear(NavigationConstant.homePage);
          });
        }
      }
      var responseUpdateUser = await NetworkManager.instance
          .put('/user/$id', model: model.userModel);

      CacheManager.instance
          .putData('user', 'email', model.userModel!.email.toString());
      CacheManager.instance.putData('user', 'name',
          '${model.userModel?.name} ${model.userModel?.surname.toString()[0]}.');
      var responseUpdateUserProfile = await NetworkManager.instance.put(
          '/user-profile/$id',
          model: UserProfileModel(description: model.description ?? ''));
      if (context.mounted) {
        await init(context);
      }
      NavigationManager.instance.navigationToPop();
    } catch (e) {
      print(e);
      if (context.mounted) {
        HelperFunctions.instance.showErrorDialog(
            context, 'updateProfileError'.tr(), 'backHome'.tr(), () {
          NavigationManager.instance
              .navigationToPageClear(NavigationConstant.homePage);
        });
      }
    }
  }

  void goToEditPage() {
    NavigationManager.instance
        .navigationToPage(NavigationConstant.profileEdit, args: userProfile);
  }

  void goToBackPage() {
    NavigationManager.instance.navigationToPop();
  }

  /*Future<String> _getUserModel() async {
    isAnotherProfile = false;
    UserModel? user = await UserService.instance.getUser();
    if (user != null) {
      name = '${user.name} ${user.surname.toString()[0]}.';
      return user.id ?? '';
    } else {
      throw Exception();
    }
  }*/

  Future<void> _getUserProfileModel(String id) async {
    userProfile = await UserService.instance.getAnotherUser(id.toString());
    if (userProfile == null) {
      throw Exception();
    }
    if (name == '') {
      name =
          '${userProfile?.userModel?.name} ${userProfile?.userModel?.surname.toString()[0]}.';
    }
    description = userProfile!.description.toString();
    if (description != '') {
      description = description.substring(0, description.length - 1);
    }
    star = userProfile!.averagePoint.toString();
    email = await CacheManager.instance.getData('user', 'email');
    userProfile!.userModel?.email = email;
    imagePath = '$baseUrl/${userProfile!.profilePicturePath}';
    lisanceVertification = userProfile!.lisanceVerification ?? false;
    if (description == 'null') {
      description = '';
    }
  }
}
