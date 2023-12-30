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
    this.id,
  });

  UserModel._fromJson(o) {
    name = o['name'] ?? o['userName'];
    surname = o['surname'] ?? o['userSurname'];
    email = o['email'];
    password = o['password'];
    passwordConfirmation = o['password_confirmation'];
    identificationNumber = o['identification_number'];
    gender = o['gender'] ?? o['userGender'];
    phone = o['phone'];
    id = o['id'];
  }

  @override
  fromJson(json) => UserModel._fromJson(json);

  String? email;
  String? gender;
  String? id;
  String? identificationNumber;
  String? name;
  String? password;
  String? passwordConfirmation;
  String? phone;
  String? surname;

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
    if (id != null) map['id'] = id;
    return map;
  }
}
