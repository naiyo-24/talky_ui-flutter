import 'package:hive_flutter/hive_flutter.dart';
import '../constants/app_constants.dart';
import '../../features/article/model/article_model.dart';

class HiveService {
  HiveService._();

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ArticleModelAdapter());
    await Hive.openBox<String>(AppConstants.hiveBoxName);
    await Hive.openBox<dynamic>(AppConstants.settingsBoxName);
  }

  // Settings
  static Box<dynamic> get settingsBox => Hive.box<dynamic>(AppConstants.settingsBoxName);

  static String get language => settingsBox.get('language', defaultValue: 'bn') as String;
  static Future<void> setLanguage(String value) => settingsBox.put('language', value);

  static String get district => settingsBox.get('district', defaultValue: '') as String;
  static Future<void> setDistrict(String value) => settingsBox.put('district', value);

  static bool get isFirstLaunch => settingsBox.get('firstLaunch', defaultValue: true) as bool;
  static Future<void> setFirstLaunch(bool value) => settingsBox.put('firstLaunch', value);

  static bool get isAuthenticated => settingsBox.get('isAuthenticated', defaultValue: false) as bool;
  static Future<void> setAuthenticated(bool value) => settingsBox.put('isAuthenticated', value);

  // Offline Cache
  static Box<String> get cacheBox => Hive.box<String>(AppConstants.hiveBoxName);

  static Future<void> cacheData(String key, String json) async {
    await cacheBox.put(key, json);
  }

  static String? getCachedData(String key) => cacheBox.get(key);

  static Future<void> clearCache() async {
    await cacheBox.clear();
  }
}
