import 'dart:convert';

import 'package:shazy/models/user/user_model.dart';

import '../../core/base/base_model.dart';

class UserProfileModel extends BaseModel {
  UserProfileModel({
    this.averagePoint,
    this.description,
    this.id,
    this.lisanceVerification,
    this.profilePicturePath,
    this.profileVerification,
    this.userId,
    this.userModel,
  });

  UserProfileModel._fromJson(o) {
    userModel = UserModel();
    userModel = userModel!.fromJson(o);
    var userProfile = o['user-profile'][0];
    averagePoint = double.tryParse(userProfile['avarage_point']);
    description = userProfile['description'] ?? '';
    id = userProfile['id'];
    lisanceVerification = userProfile['lisance_verification'] == 1 &&
        userProfile['lisance_verification'] != 'null';
    profilePicturePath = userProfile['profile_picture'];
    profileVerification = userProfile['profile_verification'] == 1 &&
        userProfile['profile_verification'] != 'null';
    userId = userProfile['user_id'];
  }

  @override
  fromJson(json) => UserProfileModel._fromJson(json);

  double? averagePoint;
  String? description;
  String? id;
  bool? lisanceVerification;
  String? profilePicturePath;
  bool? profileVerification;
  String? userId;
  UserModel? userModel;

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    if (description != null) {
      map['description'] = description;
    }
    if (profilePicturePath != null) {
      map['profile_picture'] = base64.normalize(profilePicturePath!);
    }
    if (userModel != null) {
      map['user'] = userModel!.toJson();
    }
    return map;
  }
}
