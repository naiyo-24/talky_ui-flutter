import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../features/article/model/article_model.dart';
import '../repository/bookmark_repository.dart';

class BookmarkNotifier extends StateNotifier<List<ArticleModel>> {
  BookmarkNotifier(this._repo) : super([]) {
    _load();
  }
  final BookmarkRepository _repo;

  void _load() => state = _repo.getAllBookmarks();

  bool isBookmarked(String url) => _repo.isBookmarked(url);

  Future<void> toggle(ArticleModel article) async {
    if (_repo.isBookmarked(article.url)) {
      await _repo.removeBookmark(article.url);
    } else {
      await _repo.addBookmark(article);
    }
    _load();
  }

  Future<void> clearAll() async {
    await _repo.clearAllBookmarks();
    _load();
  }
}

final bookmarkProvider =
    StateNotifierProvider<BookmarkNotifier, List<ArticleModel>>(
  (ref) => BookmarkNotifier(ref.watch(bookmarkRepositoryProvider)),
);
