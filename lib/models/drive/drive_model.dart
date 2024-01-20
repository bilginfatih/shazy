import '../../core/base/base_model.dart';

class DriveModel extends BaseModel {
  DriveModel({
    this.driverId,
    this.fromLat,
    this.fromLang,
    this.toLat,
    this.toLang,
    this.timeFrom,
    this.timeTo,
    this.callerId,
    this.driverLat,
    this.driverLang,
  });

  DriveModel._fromJson(o);

  String? driverId;
  double? fromLat;
  double? fromLang;
  double? toLat;
  double? toLang;
  String? timeFrom;
  String? timeTo;
  String? callerId;
  double? driverLat;
  double? driverLang;

  @override
  fromJson(json) => DriveModel._fromJson(json);
  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    if (driverId != null) map['driver_id'] = driverId;
    if (fromLat != null) map['from_lat'] = fromLat;
    if (fromLang != null) map['from_lang'] = fromLang;
    if (toLat != null) map['to_lat'] = toLat;
    if (toLang != null) map['to_lang'] = toLang;
    if (timeFrom != null) map['time_from'] = timeFrom;
    if (timeTo != null) map['time_to'] = timeTo;
    if (callerId != null) map['caller_id'] = callerId;
    if (driverLat != null) map['driver_lat'] = driverLat.toString();
    if (driverLang != null) map['driver_lang'] = driverLang.toString();
    return map;
  }
}
