import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/storage/hive_service.dart';
import '../../../features/article/model/article_model.dart';

class BookmarkRepository {
  List<ArticleModel> getAllBookmarks() => HiveService.getAllBookmarks();
  bool isBookmarked(String url) => HiveService.isBookmarked(url);
  Future<void> addBookmark(ArticleModel article) =>
      HiveService.addBookmark(article);
  Future<void> removeBookmark(String url) => HiveService.removeBookmark(url);
}

final bookmarkRepositoryProvider =
    Provider<BookmarkRepository>((ref) => BookmarkRepository());
