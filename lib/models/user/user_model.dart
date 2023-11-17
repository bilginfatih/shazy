import '../../core/base/base_model.dart';

class UserModel extends BaseModel {
  UserModel({
    this.name,
    this.surname,
    this.email,
    this.password,
    this.passwordConfirmation,
    this.identificationNumber,
    this.gender,
    this.phone,
  });

  UserModel._fromJson(o) {
    name = o['name'];
    surname = o['surname'];
    email = o['email'];
    password = o['password'];
    passwordConfirmation = o['password_confirmation'];
    identificationNumber = o['identification_number'];
    gender = o['gender'];
    phone = o['phone'];
  }

  String? name;
  String? surname;
  String? email;
  String? password;
  String? passwordConfirmation;
  String? identificationNumber;
  String? gender;
  String? phone;

  @override
  fromJson(json) => UserModel._fromJson(json);

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
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
    return map;
  }
}
