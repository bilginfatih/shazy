import 'package:hive/hive.dart';

class CacheManager {
  CacheManager._init();

  static CacheManager instance = CacheManager._init();

  Future<dynamic> getData(String boxName, String value) async {
    try {
      var box = await Hive.openBox(boxName);
      return await box.get(value);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> putData(String boxName, String key, String value) async {
    try {
      var box = await Hive.openBox(boxName);
      await box.put(key, value);
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
