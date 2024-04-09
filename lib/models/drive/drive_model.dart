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
    this.status,
  });

  DriveModel._fromJson(o) {
    driverId = o['driver_id'];
    callerId = o['caller_id'];
    status = o['status'];
    driverLat = double.tryParse(o['driver_lat']);
    driverLang = double.tryParse(o['driver_lang']);
    fromLat = double.tryParse(o['from_lat']);
    fromLang = double.tryParse(o['from_lang']);
    toLat = double.tryParse(o['to_lat']);
    toLang = double.tryParse(o['to_lang']);
    timeFrom = o['time_from'];
    timeTo = o['time_to'];
  }

  @override
  fromJson(json) => DriveModel._fromJson(json);

  String? callerId;
  String? driverId;
  double? driverLang;
  double? driverLat;
  double? fromLang;
  double? fromLat;
  String? status;
  String? timeFrom;
  String? timeTo;
  double? toLang;
  double? toLat;

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
    if (status != null) map['status'] = status;
    return map;
  }
}
