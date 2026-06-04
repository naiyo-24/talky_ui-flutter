import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../core/network/api_service.dart';
import '../../../core/storage/hive_service.dart';
import '../../../features/article/model/article_model.dart';
import '../../../core/constants/dummy_data.dart';

class HomeRepository {
  HomeRepository(this._apiService);
  final ApiService _apiService;

  Future<List<ArticleModel>> fetchTopHeadlines({
    String? category,
    int page = 1,
  }) async {
    try {
      final data = await _apiService.getTopHeadlines(
        category: category,
        page: page,
      );
      final articles = (data['articles'] as List<dynamic>)
          .map((e) => ArticleModel.fromJson(e as Map<String, dynamic>,
              category: category ?? 'Top'))
          .where((a) => a.title != null && a.title != '[Removed]')
          .toList();

      // Cache the first page
      if (page == 1) {
        final key = 'home_${category ?? 'top'}';
        HiveService.cacheData(key, jsonEncode(data['articles']));
      }
      return articles;
    } on DioException {
      // Try cache
      final key = 'home_${category ?? 'top'}';
      final cached = HiveService.getCachedData(key);
      if (cached != null) {
        final list = jsonDecode(cached) as List<dynamic>;
        return list
            .map((e) => ArticleModel.fromJson(e as Map<String, dynamic>,
                category: category ?? 'Top'))
            .toList();
      }
      return DummyData.dummyArticles; // Prototype fallback
    }
  }

  Future<List<ArticleModel>> fetchBreakingNews() async {
    try {
      final data = await _apiService.getBreakingNews();
      return (data['articles'] as List<dynamic>)
          .map((e) => ArticleModel.fromJson(e as Map<String, dynamic>,
              category: 'Breaking'))
          .where((a) => a.title != null && a.title != '[Removed]')
          .toList();
    } on DioException {
      return DummyData.dummyArticles.take(3).toList(); // Prototype fallback
    }
  }
}
