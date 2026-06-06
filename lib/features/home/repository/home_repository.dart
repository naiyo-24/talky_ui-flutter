import '../../../core/repository/json_repository.dart';
import '../../../core/storage/hive_service.dart';
import '../../../features/article/model/article_model.dart';

class HomeRepository {
  HomeRepository(this._jsonRepo);
  final JsonRepository _jsonRepo;

  Future<List<ArticleModel>> fetchTopHeadlines({
    String? category,
    int page = 1,
  }) async {
    final all = await _jsonRepo.fetchAllArticles();
    final district = HiveService.district;

    var filtered = all;

    if (district.isNotEmpty) {
      // If a district is saved, show articles matching that district, or articles with no district
      filtered = filtered.where((a) => a.district == district || a.district.isEmpty || a.district == 'New Delhi').toList();
    }
    
    // Fallback if the district filter is too strict and returns 0 items for prototyping
    if (filtered.isEmpty) {
      filtered = List.from(all);
    }

    if (category != null && category.toLowerCase() != 'top' && category.toLowerCase() != 'home') {
      final cat = category.toLowerCase();
      if (cat == 'latest') {
        filtered.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
      } else if (cat == 'trending') {
        // Mock trending by returning randomized articles with high importance
        final list = List<ArticleModel>.from(filtered);
        list.shuffle();
        filtered = list.take(20).toList();
      } else if (cat == 'video') {
        final videos = await _jsonRepo.fetchAllVideos();
        filtered = videos.map((v) => ArticleModel(
          id: v.youtubeUrl,
          titleBn: v.title,
          titleEn: v.title,
          contentBn: '',
          contentEn: '',
          imageUrl: v.thumbnail,
          category: 'VIDEO',
          district: '',
          publishedAt: DateTime.now(),
        )).toList();
      } else {
        var categoryFiltered = filtered.where((a) => a.category.toLowerCase() == cat).toList();
        // Fallback to global news if the local district has no news for this specific category
        if (categoryFiltered.isEmpty) {
           categoryFiltered = all.where((a) => a.category.toLowerCase() == cat).toList();
        }
        filtered = categoryFiltered;
      }
    }

    return filtered;
  }

  Future<List<ArticleModel>> fetchBreakingNews() async {
    final all = await _jsonRepo.fetchAllArticles();
    final district = HiveService.district;
    
    var filtered = all;
    if (district.isNotEmpty) {
      filtered = filtered.where((a) => a.district == district || a.district.isEmpty || a.district == 'New Delhi').toList();
    }
    
    if (filtered.isEmpty) {
      filtered = all;
    }

    return filtered.take(5).toList();
  }
}
