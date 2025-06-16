import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  static const String _countKey = 'count';

  static Future<void> saveCount(int count) async {
    final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();
    await asyncPrefs.setInt(_countKey, count);
  }

  static Future<int> getCount() async {
    final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();

    return await asyncPrefs.getInt(_countKey) ?? 0;
  }
}
