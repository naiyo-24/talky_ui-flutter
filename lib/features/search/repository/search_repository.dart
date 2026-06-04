import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_service.dart';
import '../../../features/article/model/article_model.dart';
import '../../../features/home/providers/home_provider.dart';

class SearchRepository {
  SearchRepository(this._api);
  final ApiService _api;

  Future<List<ArticleModel>> search(String query, {int page = 1}) async {
    final data = await _api.searchArticles(query: query, page: page);
    return (data['articles'] as List<dynamic>)
        .map((e) => ArticleModel.fromJson(e as Map<String, dynamic>))
        .where((a) => a.title != null && a.title != '[Removed]')
        .toList();
  }
}

final searchRepositoryProvider = Provider<SearchRepository>(
  (ref) => SearchRepository(ref.watch(apiServiceProvider)),
);
