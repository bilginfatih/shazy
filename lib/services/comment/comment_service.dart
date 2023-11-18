import 'package:easy_localization/easy_localization.dart';

import '../../core/init/network/network_manager.dart';
import '../../models/comment/comment_model.dart';
// TODO: sürücü endpointleri eklendikten sonra test edilecek.
class CommentService {
  CommentService._init();

  static CommentService instance = CommentService._init();

  Future<String?> comment(CommentModel comment) async {
    try {
      var response =
          await NetworkManager.instance.post('/comment', model: comment);
      return null;
    } catch (e) {
      return 'commentError'.tr();
    }
  }

  Future<List<CommentModel>> getComment(String id) async {
    try {
      List<CommentModel> commentList = [];
      var response = await NetworkManager.instance.get('/comment/commentor/$id');
      return commentList;
    } catch (e) {
      return [];
    }
  }

  Future<List<CommentModel>> getAntoherUserComment() async {
    try {
      List<CommentModel> commentList = [];
      var response = await NetworkManager.instance.get('/comment/commenting');
      return commentList;
    } catch (e) {
      return [];
    }
  }
}
