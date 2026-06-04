import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_service.dart';
import '../../../features/article/model/article_model.dart';
import '../../../features/home/providers/home_provider.dart';

class ArticleRepository {
  ArticleRepository(this._api);
  final ApiService _api;

  Future<List<ArticleModel>> fetchRelated(String query) async {
    final data = await _api.searchArticles(query: query, pageSize: 5);
    return (data['articles'] as List<dynamic>)
        .map((e) => ArticleModel.fromJson(e as Map<String, dynamic>))
        .where((a) => a.title != null && a.title != '[Removed]')
        .toList();
  }
}

final articleRepositoryProvider = Provider<ArticleRepository>(
  (ref) => ArticleRepository(ref.watch(apiServiceProvider)),
);
