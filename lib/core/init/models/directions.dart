import '../../base/base_model.dart';

class Directions extends BaseModel {
  @override
  fromJson(json) => Directions._fromJson(json);
  String? endLocationName;
  String? locationId;
  double? endLocationLatitude;
  double? endLocationLongitude;
  double? currentLocationLatitude;
  double? currentLocationLongitude;
  String? currentLocationName;
  int? distance_value;
  int? duration_value;
  String? e_points;
  //String? e_pointsDrive;
  String? distance_text;
  String? duration_text;
  String? end_address;
  String? start_address;
  String? totalPayment;
  // caller tarafı
  String? caller_status;
  String? drive_id;
  String? driver_id;

  double? driver_avarage_point;
  String? driver_name;
  String? driver_surname;
  String? driver_picture_path;
  String? five_security_code;

  Directions({
    this.endLocationName,
    this.locationId,
    this.endLocationLatitude,
    this.endLocationLongitude,
    this.currentLocationLatitude,
    this.currentLocationLongitude,
    this.currentLocationName,
    this.distance_text,
    this.duration_value,
    this.e_points,
    // this.e_pointsDrive,
    this.distance_value,
    this.duration_text,
    this.end_address,
    this.start_address,
    this.totalPayment,
    // caller tarafı
    this.caller_status,
    this.drive_id,
    this.driver_id,
    this.driver_avarage_point,
    this.driver_name,
    this.driver_surname,
    this.driver_picture_path,
    this.five_security_code,
  });

  Directions._fromJson(o) {
    endLocationName = o['end_location_name'];
    locationId = o['location_id'];
    endLocationLatitude = o['end_location_latitude'];
    endLocationLongitude = o['end_location_longitude'];
    currentLocationLatitude = o['current_location_latitude'];
    currentLocationLongitude = o['current_location_longitude'];
    distance_value = o['distance_value'];
    duration_value = o['duration_value'];

    e_points = o['e_points'];
    // e_pointsDrive = o['e_pointsDrive'];
    distance_text = o['distance_text'];
    duration_text = o['duration_text'];
    end_address = o['end_address'];
    start_address = o['start_address'];
    totalPayment = o['total_payment'];

    caller_status = o['caller_status'];
    drive_id = o['drive_id'];
    driver_id = o['driver_id'];

    driver_avarage_point = o['driver_avarage_point'];
    driver_name = o['driver_name'];
    driver_surname = o['driver_surname'];
    driver_picture_path = o['driver_picture_path'];

    five_security_code = o['five_security_code'];
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    if (endLocationName != null) map['end_location_name'] = endLocationName;
    if (locationId != null) map['location_id'] = locationId;
    if (endLocationLatitude != null) map['end_location_latitude'] = endLocationLatitude;
    if (endLocationLongitude != null) {
      map['end_location_longitude'] = endLocationLongitude;
    }
    if (currentLocationLatitude != null) map['current_location_latitude'] = currentLocationLatitude;
    if (currentLocationLongitude != null) {
      map['current_location_longitude'] = currentLocationLongitude;
    }
    if (distance_value != null) {
      map['distance_value'] = distance_value;
    }
    if (duration_value != null) map['duration_value'] = duration_value;
    if (e_points != null) map['e_points'] = e_points;
    // if (e_pointsDrive != null) map['e_points_drive'] = e_pointsDrive;
    if (distance_text != null) map['distance_text'] = distance_text;
    if (duration_text != null) map['duration_text'] = duration_text;
    if (end_address != null) map['end_address'] = end_address;
    if (duration_value != null) map['duration_value'] = duration_value;
    if (start_address != null) map['start_address'] = start_address;
    if (totalPayment != null) map['total_payment'] = totalPayment;

    if (caller_status != null) map['caller_status'] = caller_status;
    if (drive_id != null) map['drive_id'] = drive_id;
    if (driver_id != null) map['driver_id'] = driver_id;

    if (driver_avarage_point != null) map['driver_avarage_point'] = driver_avarage_point;
    if (driver_name != null) map['driver_name'] = driver_name;
    if (driver_surname != null) map['driver_surname'] = driver_surname;
    if (driver_picture_path != null) map['driver_picture_path'] = driver_picture_path;

    if (five_security_code != null) map['five_security_code'] = five_security_code;

    

    return map;
  }
}
