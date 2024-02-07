import '../../base/base_model.dart';

class Directions extends BaseModel{
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
  
  @override
  fromJson(json) {
    // TODO: implement fromJson
    throw UnimplementedError();
  }
  
  @override
  Map<String, dynamic> toJson() {
    
    /* Map<String, dynamic> map = {};
    if (name != null) map['name'] = name;
    if (surname != null) map['surname'] = surname;
    if (email != null) map['email'] = email;
    if (password != null) map['password'] = password;
    if (passwordConfirmation != null) {
      map['password_confirmation'] = passwordConfirmation;
    }
    if (identificationNumber != null) {
      map['identification_number'] = identificationNumber;
    }
    if (gender != null) map['gender'] = gender;
    if (phone != null) map['phone'] = phone;
    if (id != null) map['id'] = id;
    return map;
*/
    throw UnimplementedError();
  }
}
