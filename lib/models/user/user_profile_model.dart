import '../../core/base/base_model.dart';

class UserProfileModel extends BaseModel {
  UserProfileModel({
    this.avaragePoint,
    this.description,
    this.id,
    this.lisanceVerification,
    this.profilePicturePath,
    this.profileVerification,
    this.userId,
  });

  UserProfileModel._fromJson(o) {
    avaragePoint = double.tryParse(o['avarage_point']);
    description = o['description'];
    id = o['id'];
    lisanceVerification =
        o['lisance_verification'] == 1 && o['lisance_verification'] != 'null';
    profilePicturePath = o['profile_picture_path'];
    profileVerification =
        o['profile_verification'] == 1 && o['profile_verification'] != 'null';
    userId = o['user_id'];
  }

  @override
  fromJson(json) => UserProfileModel._fromJson(json);

  double? avaragePoint;
  String? description;
  String? id;
  bool? lisanceVerification;
  String? profilePicturePath;
  bool? profileVerification;
  String? userId;

  @override
  Map<String, dynamic> toJson() {
    return {};
  }
}
