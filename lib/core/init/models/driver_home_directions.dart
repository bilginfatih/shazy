import '../../base/base_model.dart';

class DriverHomeDirections extends BaseModel {
  @override
  fromJson(json) => DriverHomeDirections._fromJson(json);
  // driver tarafı
  String? driver_status;
  String? drive_id;
  String? caller_id;
  String? driver_id;

  double? caller_avarage_point;
  String? caller_name;
  String? caller_surname;
  String? caller_picture_path;

  String? api_request_url;

  double? driver_latitude;
  double? driver_longitude;
  double? from_latitude;
  double? from_longitude;
  double? to_latitude;
  double? to_longitude;

  String? distance_text_driver_caller;
  String? duration_text_driver_caller;
  String? end_address_caller_location;
  String? start_address_driver_location;

  String? e_points_driver;
  String? e_points;

  String? distanceKmCallerToDestination;
  String? durationTimeCallerToDestination;
  //String? startAddressCallerToDestination;
  String? endAddressCallerToDestination;
  int? distanceKmCallertoDestinationValue;
  int? totalPayment;

  DriverHomeDirections({
    // caller tarafı
    this.driver_status,
    this.drive_id,
    this.caller_id,
    this.caller_avarage_point,
    this.caller_name,
    this.caller_surname,
    this.caller_picture_path,
    this.api_request_url,
    this.driver_latitude,
    this.driver_longitude,
    this.from_latitude,
    this.from_longitude,
    this.to_latitude,
    this.to_longitude,
    this.distance_text_driver_caller,
    this.duration_text_driver_caller,
    this.end_address_caller_location,
    this.start_address_driver_location,
    this.e_points_driver,
    this.e_points,
    this.distanceKmCallerToDestination,
    this.durationTimeCallerToDestination,
    this.endAddressCallerToDestination,
    this.distanceKmCallertoDestinationValue,
    this.totalPayment,
    this.driver_id,
  });

  DriverHomeDirections._fromJson(o) {
    driver_status = o['driver_status'];
    drive_id = o['drive_id'];
    caller_id = o['caller_id'];
    driver_id = o['driver_id'];

    caller_avarage_point = o['caller_avarage_point'];
    caller_name = o['caller_name'];
    caller_surname = o['caller_surname'];
    caller_picture_path = o['caller_picture_path'];

    api_request_url = o['api_request_url'];

    from_latitude = o['from_latitude'];
    from_longitude = o['from_longitude'];
    to_latitude = o['to_latitude'];
    to_longitude = o['to_longitude'];

    distance_text_driver_caller = o['distance_text_driver_caller'];
    duration_text_driver_caller = o['duration_text_driver_caller'];
    end_address_caller_location = o['end_address_caller_location'];
    start_address_driver_location = o['start_address_driver_location'];

    e_points_driver = o['e_points_driver'];
    e_points = o['e_points'];

    distanceKmCallerToDestination = o['distance_km_caller_to_destination'];
    durationTimeCallerToDestination = o['duration_time_caller_to_destination'];
    endAddressCallerToDestination = o['end_address_caller_to_destination'];
    distanceKmCallertoDestinationValue = o['distance_km_caller_to_destination_value'];
    totalPayment = o['total_payment'];
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    if (driver_status != null) map['driver_status'] = driver_status;
    if (drive_id != null) map['drive_id'] = drive_id;
    if (caller_id != null) map['caller_id'] = caller_id;

    if (caller_avarage_point != null) map['caller_avarage_point'] = caller_avarage_point;
    if (caller_name != null) map['caller_name'] = caller_name;
    if (caller_surname != null) map['caller_surname'] = caller_surname;
    if (caller_picture_path != null) map['caller_picture_path'] = caller_picture_path;

    if (api_request_url != null) map['api_request_url'] = api_request_url;

    if (from_latitude != null) map['from_latitude'] = from_latitude;
    if (from_longitude != null) map['from_longitude'] = from_longitude;
    if (to_latitude != null) map['to_latitude'] = to_latitude;
    if (to_longitude != null) map['to_longitude'] = to_longitude;

    if (distance_text_driver_caller != null) map['distance_text_driver_caller'] = distance_text_driver_caller;
    if (duration_text_driver_caller != null) map['duration_text_driver_caller'] = duration_text_driver_caller;
    if (end_address_caller_location != null) map['end_address_caller_location'] = end_address_caller_location;
    if (start_address_driver_location != null) map['start_address_driver_location'] = start_address_driver_location;

    if (e_points_driver != null) map['e_points_driver'] = e_points_driver;
    if (e_points != null) map['e_points'] = e_points;

    if (distanceKmCallerToDestination != null) map['distance_km_caller_to_destination'] = distanceKmCallerToDestination;
    if (durationTimeCallerToDestination != null) map['duration_time_caller_to_destination'] = durationTimeCallerToDestination;
    if (endAddressCallerToDestination != null) map['end_address_caller_to_destination'] = endAddressCallerToDestination;
    if (distanceKmCallertoDestinationValue != null) map['distance_km_caller_to_destination_value'] = distanceKmCallertoDestinationValue;
    if (totalPayment != null) map['total_payment'] = totalPayment;
    if (driver_id != null) map['driver_id'] = driver_id;

    return map;
  }
}
