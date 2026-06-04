import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_service.dart';
import '../../../features/article/model/article_model.dart';
import '../../../features/home/providers/home_provider.dart';

class CategoryRepository {
  CategoryRepository(this._api);
  final ApiService _api;

  Future<List<ArticleModel>> fetchByCategory(
      {required String category, int page = 1}) async {
    final data =
        await _api.getTopHeadlines(category: category, page: page);
    return (data['articles'] as List<dynamic>)
        .map((e) => ArticleModel.fromJson(e as Map<String, dynamic>,
            category: category))
        .where((a) => a.title != null && a.title != '[Removed]')
        .toList();
  }
}

final categoryRepositoryProvider = Provider<CategoryRepository>(
  (ref) => CategoryRepository(ref.watch(apiServiceProvider)),
);
