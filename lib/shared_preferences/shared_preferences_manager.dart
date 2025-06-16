import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  static const String _countKey = 'count';

  static Future<SharedPreferences> get _preferences =>
      SharedPreferences.getInstance();

  static Future<void> saveCount(int count) async {
    final prefs = await _preferences;
    await prefs.setInt(_countKey, count);
  }

  static Future<int> getCount() async {
    final prefs = await _preferences;
    return prefs.getInt(_countKey) ?? 0;
  }
}
