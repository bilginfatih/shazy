import '../../core/base/base_model.dart';

class CommentModel extends BaseModel {
  CommentModel({
    this.commentingUserId,
    this.commentorUserId,
    this.comment,
    this.point,
  });

  String? comment;
  String? commentingUserId;
  String? commentorUserId;
  String? point;

  @override
  fromJson(json) {}

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    if (commentorUserId != null) map['commentor_user_id'] = commentorUserId;
    if (comment != null) map['comment'] = comment;
    if (point != null) map['point'] = point;
    return map;
  }
}
