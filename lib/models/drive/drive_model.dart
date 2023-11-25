import '../../core/base/base_model.dart';

class DriveModel extends BaseModel {
  DriveModel({
    this.driverId,
    this.to,
    this.timeFrom,
    this.timeTo,
    this.callerId,
  });

  DriveModel._fromJson(o);

  String? driverId;
  String? to;
  String? timeFrom;
  String? timeTo;
  String? callerId;

  @override
  fromJson(json) => DriveModel._fromJson(json);
  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    if (driverId != null) map['driver_id'] = driverId;
    if (to != null) map['to'] = to;
    if (timeFrom != null) map['time_from'] = timeFrom;
    if (timeTo != null) map['time_to'] = timeTo;
    if (callerId != null) map['caller_id'] = callerId;
    return map;
  }
}
