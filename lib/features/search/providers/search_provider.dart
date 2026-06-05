import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../features/article/model/article_model.dart';
import '../repository/search_repository.dart';

class SearchState {
  final List<ArticleModel> results;
  final bool isLoading;
  final String? error;
  final String query;

  const SearchState({
    this.results = const [],
    this.isLoading = false,
    this.error,
    this.query = '',
  });

  SearchState copyWith({
    List<ArticleModel>? results,
    bool? isLoading,
    String? error,
    String? query,
  }) =>
      SearchState(
        results: results ?? this.results,
        isLoading: isLoading ?? this.isLoading,
        error: error,
        query: query ?? this.query,
      );
}

class SearchNotifier extends StateNotifier<SearchState> {
  SearchNotifier(this._repo) : super(const SearchState());
  final SearchRepository _repo;

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      state = const SearchState();
      return;
    }
    state = state.copyWith(isLoading: true, query: query, results: []);
    try {
      final results = await _repo.searchArticles(query);
      
      final seen = <String>{};
      final uniqueResults = <ArticleModel>[];
      for (final a in results) {
        if (a.id.isNotEmpty && !seen.contains(a.id)) {
          seen.add(a.id);
          uniqueResults.add(a);
        }
      }

      state = state.copyWith(results: uniqueResults, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void clear() => state = const SearchState();
}

final searchProvider =
    StateNotifierProvider.autoDispose<SearchNotifier, SearchState>(
  (ref) => SearchNotifier(ref.watch(searchRepositoryProvider)),
);
