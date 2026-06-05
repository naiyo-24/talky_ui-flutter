import 'package:hive_flutter/hive_flutter.dart';
import '../constants/app_constants.dart';
import '../../features/article/model/article_model.dart';

class HiveService {
  HiveService._();

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ArticleModelAdapter());
    await Hive.openBox<ArticleModel>(AppConstants.bookmarkBoxName);
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

  // Bookmarks
  static Box<ArticleModel> get bookmarkBox =>
      Hive.box<ArticleModel>(AppConstants.bookmarkBoxName);

  static List<ArticleModel> getAllBookmarks() => bookmarkBox.values.toList();

  static bool isBookmarked(String id) => bookmarkBox.containsKey(id);

  static Future<void> addBookmark(ArticleModel article) async {
    await bookmarkBox.put(article.id, article);
  }

  static Future<void> removeBookmark(String id) async {
    await bookmarkBox.delete(id);
  }

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
