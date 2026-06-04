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
  }

  // Bookmarks
  static Box<ArticleModel> get bookmarkBox =>
      Hive.box<ArticleModel>(AppConstants.bookmarkBoxName);

  static List<ArticleModel> getAllBookmarks() => bookmarkBox.values.toList();

  static bool isBookmarked(String url) => bookmarkBox.containsKey(url);

  static Future<void> addBookmark(ArticleModel article) async {
    await bookmarkBox.put(article.url ?? article.title, article);
  }

  static Future<void> removeBookmark(String url) async {
    await bookmarkBox.delete(url);
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
