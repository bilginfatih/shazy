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
    this.fromAddress,
    this.toAddress,
    this.fromShortAddress,
    this.toShortAddress,
    this.date,
    this.hour,
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
    DateTime dateTimeCratedAt = DateTime.parse(o['created_at']);
    DateTime dateTimeUpdatedAt = DateTime.parse(o['updated_at']);
    date =
        '${dateTimeCratedAt.day < 10 ? '0${dateTimeCratedAt.day}' : dateTimeCratedAt.day}.${dateTimeCratedAt.month < 10 ? '0${dateTimeCratedAt.month}' : dateTimeCratedAt.month}.${dateTimeCratedAt.year}';
    hour =
        '${_formatTwoDigits(dateTimeCratedAt.hour)}:${_formatTwoDigits(dateTimeCratedAt.minute)} - ${_formatTwoDigits(dateTimeUpdatedAt.hour)}:${_formatTwoDigits(dateTimeUpdatedAt.minute)}';
  }

  @override
  fromJson(json) => DriveModel._fromJson(json);

  String? callerId;
  String? date;
  String? driverId;
  double? driverLang;
  double? driverLat;
  String? fromAddress;
  double? fromLang;
  double? fromLat;
  String? fromShortAddress;
  String? hour;
  String? status;
  String? timeFrom;
  String? timeTo;
  String? toAddress;
  double? toLang;
  double? toLat;
  String? toShortAddress;

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

  String _formatTwoDigits(int n) => n.toString().padLeft(2, '0');
}
