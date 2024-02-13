import '../../base/base_model.dart';

class Directions extends BaseModel{

  @override
  fromJson(json) => Directions._fromJson(json);
  String? humanReadableAddress;
  String? locationName;
  String? locationId;
  double? locationLatitude;
  double? locationLongitude;
  String? currentLocationName;
  int? distance_value;
  int? duration_value;
  String? e_points;
  String? e_pointsDrive;
  String? distance_text;
  String? duration_text;
  String? end_address;
  String? start_address;
  String? totalPayment;

  Directions({
    this.humanReadableAddress,
    this.locationName,
    this.locationId,
    this.locationLatitude,
    this.locationLongitude,
    this.currentLocationName,
    this.distance_text,
    this.duration_value,
    this.e_points,
    this.e_pointsDrive,
    this.distance_value,
    this.duration_text,
    this.end_address,
    this.start_address,
    this.totalPayment,
  });

  Directions._fromJson(o) {
    humanReadableAddress = o['human_readable_address'];
    locationName = o['location_name'];
    locationId = o['location_id'];
    locationLatitude = o['location_latitude'];
    locationLongitude = o['location_longitude'];
    distance_value = o['distance_value'];
    duration_value = o['duration_value'];

    e_points = o['e_points'];
    e_pointsDrive = o['e_pointsDrive'];
    distance_text = o['distance_text'];
    duration_text = o['duration_text'];
    end_address = o['end_address'];
    start_address = o['start_address'];
    totalPayment = o['totalPayment'];
    
  }
 
  @override
  Map<String, dynamic> toJson() {
    
    Map<String, dynamic> map = {};
    if (humanReadableAddress != null) map['human_readable_address'] = humanReadableAddress;
    if (locationName != null) map['location_name'] = locationName;
    if (locationId != null) map['location_id'] = locationId;
    if (locationLatitude != null) map['location_latitude'] = locationLatitude;
    if (locationLongitude != null) {
      map['location_longitude'] = locationLongitude;
    }
    if (distance_value != null) {
      map['distance_value'] = distance_value;
    }
    if (duration_value != null) map['duration_value'] = duration_value;
    if (e_points != null) map['e_points'] = e_points;
    if (e_pointsDrive != null) map['e_points_drive'] = e_pointsDrive;
    if (distance_value != null) map['distance_value'] = distance_value;
    if (duration_text != null) map['duration_text'] = duration_text;
    if (end_address != null) map['end_address'] = end_address;
    if (duration_value != null) map['duration_value'] = duration_value;
    if (start_address != null) map['start_address'] = start_address;
    if (totalPayment != null) map['total_payment'] = totalPayment;
    return map;
   
  }
}
