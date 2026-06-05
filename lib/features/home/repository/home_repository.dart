import '../../../core/repository/json_repository.dart';
import '../../../features/article/model/article_model.dart';

class HomeRepository {
  HomeRepository(this._jsonRepo);
  final JsonRepository _jsonRepo;

  Future<List<ArticleModel>> fetchTopHeadlines({
    String? category,
    int page = 1,
  }) async {
    final all = await _jsonRepo.fetchAllArticles();
    if (category != null && category.toLowerCase() != 'top') {
      return all.where((a) => a.category == category).toList();
    }
    return all;
  }

  Future<List<ArticleModel>> fetchBreakingNews() async {
    final all = await _jsonRepo.fetchAllArticles();
    return all.take(5).toList();
  }
}
