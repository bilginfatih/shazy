import 'package:shazy/models/drive/drive_model.dart';
import 'package:shazy/models/user/user_profile_model.dart';

import '../../core/base/base_model.dart';

class HistoryModel extends BaseModel {
  HistoryModel({
    this.id,
    this.driverId,
    this.callerId,
    this.commentId,
    this.createdAt,
    this.updatedAt,
    this.userProfile,
    this.driveRequestId,
    this.driveModel,
    this.price,
  });

  HistoryModel._fromJson(o) {
    id = o['id'];
    driverId = o['driver_id'];
    callerId = o['caller_id'];
    commentId = o['comment_id'];
    createdAt = o['created_at'];
    updatedAt = o['updated_at'];
    driveRequestId = o['drive_request_id'];
    price = double.tryParse(o['price']);
  }

  @override
  fromJson(json) => HistoryModel._fromJson(json);

  String? callerId;
  String? commentId;
  String? createdAt;
  DriveModel? driveModel;
  String? driveRequestId;
  String? driverId;
  String? id;
  double? price;
  String? updatedAt;
  UserProfileModel? userProfile;

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    return map;
  }
}
