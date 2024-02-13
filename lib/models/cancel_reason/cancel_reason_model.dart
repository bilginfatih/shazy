import '../../core/base/base_model.dart';

class CancelReasonModel extends BaseModel {
  CancelReasonModel({
    this.driverId,
    this.callerId,
    this.reason,
    this.status,
  });

  CancelReasonModel._fromJson(o);

  String? driverId;
  String? callerId;
  String? reason;
  String? status;

  @override
  fromJson(json) => CancelReasonModel._fromJson(json);
  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    if (driverId != null) map['driver_id'] = driverId;
    if (callerId != null) map['caller_id'] = callerId;
    if (reason != null) map['reason'] = reason;
    if (status != null) map['status'] = status;
    return map;
  }
}
