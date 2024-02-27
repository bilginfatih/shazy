import '../../core/base/base_model.dart';

class UserIdentityModel extends BaseModel {
  UserIdentityModel({
    this.criminalRecord,
    this.drivingLicance,
    this.notificationCode,
    this.paybackCode,
    this.id,
    this.createdAt,
    this.criminalLicanceConfirm,
    this.drivingLicanceConfirm,
    this.updatedAt,
    this.userId,
  });

  UserIdentityModel._fromJson(o) {
    createdAt = o['created_at'];
    criminalLicanceConfirm = o['criminal_licance_confirm'];
    criminalRecord = o['criminal_record'];
    drivingLicance = o['driving_licance'];
    drivingLicanceConfirm = o['driving_licance_confirm'];
    id = o['id'];
    notificationCode = o['notification_code'];
    paybackCode = o['payback_code'];
    updatedAt = o['updated_at'];
    userId = o['user_id'];
  }

  @override
  fromJson(json) => UserIdentityModel._fromJson(json);

  String? createdAt;
  int? criminalLicanceConfirm;
  String? criminalRecord;
  String? drivingLicance;
  int? drivingLicanceConfirm;
  String? id;
  String? notificationCode;
  String? paybackCode;
  String? updatedAt;
  String? userId;

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (criminalRecord != null) {
      json['criminal_record'] = criminalRecord;
    }
    if (drivingLicance != null) {
      json['driving_licance'] = criminalRecord;
    }
    if (notificationCode != null) {
      json['notification_code'] = criminalRecord;
    }
    if (notificationCode != null) {
      json['payback_code'] = paybackCode;
    }
    return json;
  }
}
