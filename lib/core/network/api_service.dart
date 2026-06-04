import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import 'dio_client.dart';

class ApiService {
  final Dio _dio = DioClient.instance;

  // Top Headlines
  Future<Map<String, dynamic>> getTopHeadlines({
    String? category,
    int page = 1,
    int pageSize = ApiConstants.pageSize,
  }) async {
    final response = await _dio.get(
      ApiConstants.topHeadlines,
      queryParameters: {
        'country': ApiConstants.country,
        if (category != null && category.toLowerCase() != 'top')
          'category': category.toLowerCase(),
        'page': page,
        'pageSize': pageSize,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  // Search Everything
  Future<Map<String, dynamic>> searchArticles({
    required String query,
    int page = 1,
    int pageSize = ApiConstants.pageSize,
    String sortBy = 'publishedAt',
  }) async {
    final response = await _dio.get(
      ApiConstants.everything,
      queryParameters: {
        'q': query,
        'sortBy': sortBy,
        'page': page,
        'pageSize': pageSize,
        'language': 'en',
      },
    );
    return response.data as Map<String, dynamic>;
  }

  // Breaking News (top 5)
  Future<Map<String, dynamic>> getBreakingNews() async {
    final response = await _dio.get(
      ApiConstants.topHeadlines,
      queryParameters: {
        'country': ApiConstants.country,
        'pageSize': 5,
      },
    );
    return response.data as Map<String, dynamic>;
  }
}
