import '../../core/base/base_model.dart';

class ComplainModel extends BaseModel {
  ComplainModel({
    this.complain,
    this.userId,
  });
  ComplainModel._fromJson(o) {
    complain = o['complain'];
    userId = o['user_id'];
  }

  String? userId;
  String? complain;
  @override
  fromJson(json) => ComplainModel._fromJson(json);

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    if (userId != null) {
      map['user_id'] = userId;
    }
    if (complain != null) {
      map['complain'] = complain;
    }
    return map;
  }
}
