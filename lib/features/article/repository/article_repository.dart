import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/repository/json_repository.dart';
import '../../../features/article/model/article_model.dart';

class ArticleRepository {
  ArticleRepository(this._jsonRepo);
  final JsonRepository _jsonRepo;

  Future<List<ArticleModel>> fetchRelated(String query) async {
    // Just fetch some random ones for prototype
    final all = await _jsonRepo.fetchAllArticles();
    return all.take(5).toList();
  }
}

final articleRepositoryProvider = Provider<ArticleRepository>(
  (ref) => ArticleRepository(ref.watch(jsonRepositoryProvider)),
);
