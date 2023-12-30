import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:mobx/mobx.dart';
import 'package:shazy/models/user/user_profile_model.dart';
import 'package:shazy/services/comment/comment_service.dart';
import 'package:shazy/services/user/user_service.dart';
import 'package:shazy/utils/constants/app_constant.dart';

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

  @action
  Future<void> init({String? id}) async {
    try {
      id ??= await _getUserModel();
      if (id != '') {
        await _getUserProfileModel(id);
        commentList = await CommentService.instance.getAntoherUserComment(id);
      } else {
        throw Exception();
      }
    } catch (e) {
      print(e);
      // TODO: error page
    }
  }

  Future<String> _getUserModel() async {
    isAnotherProfile = false;
    UserModel? user = await UserService.instance.getUser();
    if (user != null) {
      name = '${user.name} ${user.surname.toString()[0]}.';
      return user.id ?? '';
    } else {
      throw Exception();
    }
  }

  Future<void> _getUserProfileModel(String id) async {
    UserProfileModel? userProfile =
        await UserService.instance.getAnotherUser(id.toString());
    if (userProfile == null) {
      throw Exception();
    }
    if (name == '') {
      name =
          '${userProfile.userModel?.name} ${userProfile.userModel?.surname.toString()[0]}.';
    }
    description = userProfile.description.toString();
    description = description.substring(0, description.length - 1);
    star = userProfile.avaragePoint.toString();
    imagePath = '$baseUrl/${userProfile.profilePicturePath}';
    lisanceVertification = userProfile.lisanceVerification ?? false;
    if (description == 'null') {
      description = '';
    }
  }
}
