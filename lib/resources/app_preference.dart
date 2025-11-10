// import '../models/model_daily_reminder.dart';
// import '../models/model_intro.dart';
// import '../models/model_user.dart';

import 'package:shared_preferences/shared_preferences.dart';

class AppPreference {
  static const String isFirstTime = 'isFirstTime';
  static const String appLanguage = 'appLanguage';
  static const String defaultLanguage = 'en'; // Default language code

  static late SharedPreferences preferences;

  static Future<void> init() async {
    preferences = await SharedPreferences.getInstance();
  }

  static String? readString(String key) {
    return preferences.getString(key);
  }

  static Future<bool> writeString(String key, String value) async {
    return preferences.setString(key, value);
  }

  static bool readBool(String key) {
    return preferences.getBool(key) ?? false;
  }

  static Future<bool> writeBool(String key, bool value) async {
    return preferences.setBool(key, value);
  }

  static int readInt(String key) {
    return preferences.getInt(key) ?? 0;
  }

  static Future<bool> writeInt(String key, int value) async {
    return preferences.setInt(key, value);
  }

  static String getLanguage() {
    return readString(appLanguage) ?? defaultLanguage;
  }

  static Future<bool> setLanguage(String languageCode) async {
    return writeString(appLanguage, languageCode);
  }

  static bool isFirstTimeUser() {
    return readBool(isFirstTime);
  }

  static Future<bool> setFirstTimeUser(bool value) async {
    return writeBool(isFirstTime, value);
  }
}
