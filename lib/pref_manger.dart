import 'package:hive_flutter/adapters.dart';

class PrefManager {
  void updateKeyValue(String key, dynamic value) async {
    var box = await Hive.openBox('settings');
    box.put(key, value);
  }

  Future<String?> getString(String key) async {
    var box = await Hive.openBox('settings');
    return box.get(key, defaultValue: null);
  }

  Future<int> getInt(String key) async {
    var box = await Hive.openBox('settings');
    return box.get(key, defaultValue: -1);
  }
}
