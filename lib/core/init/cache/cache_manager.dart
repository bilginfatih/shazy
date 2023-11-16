import 'package:hive/hive.dart';

import '../../base/base_model.dart';

class CacheManager {
  CacheManager(String boxName) {
    Hive.openBox(boxName).then((value) => _box = value);
  }

  late final Box _box;

  Future<dynamic> getAll<T extends BaseModel>({T? model}) async {
    try {
      return model?.fromJson(_box.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getData(String value) async {
    try {
      return await _box.get(value);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> putAll<T extends BaseModel>(T model) async {
    try {
      await _box.putAll(model.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> putData(String key, String value) async {
    try {
      await _box.put(key, value);
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> clearAll(String name) async {
    try {
      Hive.deleteBoxFromDisk(name);
    } catch (e) {
      rethrow;
    }
  }
}