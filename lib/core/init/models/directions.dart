class Directions {
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
}
