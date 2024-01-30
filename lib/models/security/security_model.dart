import '../../core/base/base_model.dart';

class SecurityModel extends BaseModel {
  SecurityModel({
    this.driverId,
    this.securityCode,
  });

  SecurityModel._fromJson(o);

  String? driverId;
  String? securityCode;
  

  @override
  fromJson(json) => SecurityModel._fromJson(json);
  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    if (driverId != null) map['driver_id'] = driverId;
    if (securityCode != null) map['security_code'] = securityCode;
    return map;
  }
}