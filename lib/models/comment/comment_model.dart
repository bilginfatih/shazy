import '../../core/base/base_model.dart';

class CommentModel extends BaseModel {
  CommentModel({
    this.commentingUserId,
    this.commentorUserId,
    this.comment,
    this.point,
    this.id,
    this.name,
    this.imagePath,
  });

  CommentModel._fromJson(o) {
    comment = o['comment'];
    commentingUserId = o['commenting_user_id'];
    commentorUserId = o['commentor_user_id'];
    id = o['id'];
    point = double.tryParse(o['point']);
  }

  @override
  fromJson(json) => CommentModel._fromJson(json);

  String? comment;
  String? commentingUserId;
  String? commentorUserId;
  String? id;
  String? imagePath;
  String? name;
  double? point;

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    if (commentorUserId != null) map['commentor_user_id'] = commentorUserId;
    if (comment != null) map['comment'] = comment;
    if (point != null) map['point'] = point;
    if (id != null) map['id'] = id;
    return map;
  }
}
