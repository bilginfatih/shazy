import 'package:easy_localization/easy_localization.dart';
import 'package:shazy/models/user/user_profile_model.dart';
import 'package:shazy/services/user/user_service.dart';

import '../../core/init/network/network_manager.dart';
import '../../models/comment/comment_model.dart';
import '../../utils/constants/app_constant.dart';

// TODO: sürücü endpointleri eklendikten sonra test edilecek.
class CommentService {
  CommentService._init();

  static CommentService instance = CommentService._init();

  Future<String?> comment(CommentModel comment, String userPath ) async {
    try {
      var response =
          await NetworkManager.instance.post('/comment/$userPath', model: comment);
      return null;
    } catch (e) {
      return 'commentError'.tr();
    }
  }

  Future<List<CommentModel>> getComment(String id) async {
    try {
      List<CommentModel> commentList = [];
      var response =
          await NetworkManager.instance.get('/comment/commentor/$id');
      return commentList;
    } catch (e) {
      return [];
    }
  }

  Future<List<CommentModel>> getAntoherUserComment(String id) async {
    try {
      List<CommentModel> commentList = [];
      var response =
          await NetworkManager.instance.get('/comment/commenting/$id');
      for (var item in response) {
        CommentModel model = CommentModel();
        model = model.fromJson(item);
        UserProfileModel? userProfile = await UserService.instance
            .getAnotherUser(model.commentingUserId.toString());
        model.name =
            '${userProfile?.userModel?.name} ${userProfile?.userModel?.surname.toString()[0]}.';
        model.imagePath = '$baseUrl/${userProfile?.profilePicturePath}';
        commentList.add(model);
      }
      return commentList;
    } catch (e) {
      return [];
    }
  }
}
