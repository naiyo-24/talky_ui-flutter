import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/repository/json_repository.dart';
import '../../../features/article/model/article_model.dart';

class CategoryRepository {
  CategoryRepository(this._jsonRepo);
  final JsonRepository _jsonRepo;

  Future<List<ArticleModel>> fetchArticlesByCategory(String category) async {
    return await _jsonRepo.fetchArticlesByCategory(category);
  }
}

final categoryRepositoryProvider = Provider<CategoryRepository>(
  (ref) => CategoryRepository(ref.watch(jsonRepositoryProvider)),
);
