import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/article/model/article_model.dart';
import '../../features/videos/model/video_model.dart';

class JsonRepository {
  List<ArticleModel>? _cachedArticles;
  List<VideoModel>? _cachedVideos;

  Future<List<ArticleModel>> fetchAllArticles() async {
    if (_cachedArticles == null) {
      final String response = await rootBundle.loadString('assets/json/news.json');
      final List<dynamic> data = json.decode(response);
      _cachedArticles = data.map((json) => ArticleModel.fromJson(json)).toList();
    }
    final list = List<ArticleModel>.from(_cachedArticles!);
    list.shuffle();
    return list;
  }

  Future<List<VideoModel>> fetchAllVideos() async {
    if (_cachedVideos == null) {
      final String response = await rootBundle.loadString('assets/json/videos.json');
      final List<dynamic> data = json.decode(response);
      _cachedVideos = data.map((json) => VideoModel.fromJson(json)).toList();
    }
    final list = List<VideoModel>.from(_cachedVideos!);
    list.shuffle();
    return list;
  }

  Future<List<ArticleModel>> fetchArticlesByCategory(String category) async {
    final articles = await fetchAllArticles();
    return articles.where((a) => a.category == category).toList();
  }

  Future<List<ArticleModel>> fetchArticlesByDistrict(String district) async {
    final articles = await fetchAllArticles();
    return articles.where((a) => a.district == district).toList();
  }
}

final jsonRepositoryProvider = Provider<JsonRepository>((ref) {
  return JsonRepository();
});
