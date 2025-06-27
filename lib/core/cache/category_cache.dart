import 'package:shared_preferences/shared_preferences.dart';

class CategoryCache {
  static const _key = 'categories';
  static const _timestampKey = 'categories_timestamp';
  static const int ttlSeconds = 3600; // 1 hour TTL

  static Future<void> saveCategories(List<String> categories) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, categories);
    await prefs.setInt(_timestampKey, DateTime.now().millisecondsSinceEpoch);
  }

  static Future<List<String>> loadCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getInt(_timestampKey);
    if (timestamp != null) {
      final now = DateTime.now().millisecondsSinceEpoch;
      if ((now - timestamp) > ttlSeconds * 1000) {
        // Cache expired
        await clearCategories();
        return [];
      }
    }
    return prefs.getStringList(_key) ?? [];
  }

  static Future<void> clearCategories() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
    await prefs.remove(_timestampKey);
  }
}
