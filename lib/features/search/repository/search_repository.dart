import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/repository/json_repository.dart';
import '../../../features/article/model/article_model.dart';

class SearchRepository {
  SearchRepository(this._jsonRepo);
  final JsonRepository _jsonRepo;

  Future<List<ArticleModel>> searchArticles(String query) async {
    final all = await _jsonRepo.fetchAllArticles();
    final lowerQuery = query.toLowerCase();
    return all.where((a) {
      final titleBnMatch = a.titleBn.toLowerCase().contains(lowerQuery);
      final titleEnMatch = a.titleEn.toLowerCase().contains(lowerQuery);
      final distMatch = a.district.toLowerCase().contains(lowerQuery);
      final catMatch = a.category.toLowerCase().contains(lowerQuery);
      return titleBnMatch || titleEnMatch || distMatch || catMatch;
    }).toList();
  }
}

final searchRepositoryProvider = Provider<SearchRepository>(
  (ref) => SearchRepository(ref.watch(jsonRepositoryProvider)),
);
