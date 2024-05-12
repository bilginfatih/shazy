import '../../base/base_model.dart';

class CallerHomeDirections extends BaseModel {
  @override
  fromJson(json) => CallerHomeDirections._fromJson(json);
  // caller tarafı
  String? caller_status;
  String? drive_id;
  String? driver_id;

  double? driver_avarage_point;
  String? driver_name;
  String? driver_surname;
  String? driver_picture_path;
  String? five_security_code;

  bool? isAccept;

  String? meeting_time;

  CallerHomeDirections({
    // caller tarafı
    this.caller_status,
    this.drive_id,
    this.driver_id,
    this.driver_avarage_point,
    this.driver_name,
    this.driver_surname,
    this.driver_picture_path,
    this.five_security_code,
    this.isAccept,
    this.meeting_time,
  });

  CallerHomeDirections._fromJson(o) {
    caller_status = o['caller_status'];
    drive_id = o['drive_id'];
    driver_id = o['driver_id'];

    driver_avarage_point = o['driver_avarage_point'];
    driver_name = o['driver_name'];
    driver_surname = o['driver_surname'];
    driver_picture_path = o['driver_picture_path'];

    five_security_code = o['five_security_code'];

    isAccept = o['is_accept'];
    meeting_time = o['meeting_time'];
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    if (caller_status != null) map['caller_status'] = caller_status;
    if (drive_id != null) map['drive_id'] = drive_id;
    if (driver_id != null) map['driver_id'] = driver_id;

    if (driver_avarage_point != null) map['driver_avarage_point'] = driver_avarage_point;
    if (driver_name != null) map['driver_name'] = driver_name;
    if (driver_surname != null) map['driver_surname'] = driver_surname;
    if (driver_picture_path != null) map['driver_picture_path'] = driver_picture_path;

    if (five_security_code != null) map['five_security_code'] = five_security_code;

    if (isAccept != null) map['is_accept'] = isAccept;
    if (meeting_time != null) map['meeting_time'] = meeting_time;
    return map;
  }
}
