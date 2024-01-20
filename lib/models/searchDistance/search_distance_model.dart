import '../../core/base/base_model.dart';

class SearchDistanceModel extends BaseModel {
  SearchDistanceModel({
    this.fromLat,
    this.fromLang,
    this.toLat,
    this.toLang,
  });

  SearchDistanceModel._fromJson(o);

  double? fromLat;
  double? fromLang;
  double? toLat;
  double? toLang;

  @override
  fromJson(json) => SearchDistanceModel._fromJson(json);
  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    if (fromLat != null) map['from_lat'] = fromLat.toString();
    if (fromLang != null) map['from_lang'] = fromLang.toString();
    if (fromLat != null) map['to_lat'] = fromLat.toString();
    if (fromLang != null) map['to_lang'] = fromLang.toString();
    return map;
  }
}
