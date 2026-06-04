import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_service.dart';
import '../../../features/article/model/article_model.dart';
import '../repository/home_repository.dart';

// --- Providers ---

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

final homeRepositoryProvider = Provider<HomeRepository>(
  (ref) => HomeRepository(ref.watch(apiServiceProvider)),
);

// Breaking news
final breakingNewsProvider =
    FutureProvider.autoDispose<List<ArticleModel>>((ref) {
  return ref.watch(homeRepositoryProvider).fetchBreakingNews();
});

// Paginated home news state
class HomeNewsNotifier extends StateNotifier<HomeNewsState> {
  HomeNewsNotifier(this._repo, {String category = 'Top'})
      : super(HomeNewsState.initial(category)) {
    fetchPage();
  }

  final HomeRepository _repo;

  Future<void> fetchPage({String? category}) async {
    if (state.isLoadingMore || !state.hasMore) return;
    state = state.copyWith(
      isLoadingMore: true,
      category: category ?? state.category,
      clearError: true,
    );
    try {
      final newArticles = await _repo.fetchTopHeadlines(
        category: category ?? state.category,
        page: state.page + 1,
      );
      if (!mounted) return;

      final existingIds = state.articles.map((a) => a.url ?? a.title ?? '').toSet();
      final uniqueNewArticles = <ArticleModel>[];
      for (final a in newArticles) {
        final id = a.url ?? a.title ?? '';
        if (id.isNotEmpty && !existingIds.contains(id)) {
          existingIds.add(id);
          uniqueNewArticles.add(a);
        }
      }

      state = state.copyWith(
        articles: [...state.articles, ...uniqueNewArticles],
        page: state.page + 1,
        isLoadingMore: false,
        hasMore: newArticles.isNotEmpty,
        isInitial: false,
      );
    } catch (e) {
      if (!mounted) return;
      state = state.copyWith(
        isLoadingMore: false,
        error: e.toString(),
        isInitial: false,
      );
    }
  }

  Future<void> changeCategory(String category) async {
    state = HomeNewsState.initial(category);
    await fetchPage(category: category);
  }

  Future<void> refresh() async {
    state = HomeNewsState.initial(state.category);
    await fetchPage(category: state.category);
  }
}

class HomeNewsState {
  final List<ArticleModel> articles;
  final int page;
  final bool isLoadingMore;
  final bool hasMore;
  final bool isInitial;
  final String? error;
  final String category;

  const HomeNewsState({
    required this.articles,
    required this.page,
    required this.isLoadingMore,
    required this.hasMore,
    required this.isInitial,
    this.error,
    required this.category,
  });

  factory HomeNewsState.initial(String category) => HomeNewsState(
        articles: const [],
        page: 0,
        isLoadingMore: false,
        hasMore: true,
        isInitial: true,
        category: category,
      );

  HomeNewsState copyWith({
    List<ArticleModel>? articles,
    int? page,
    bool? isLoadingMore,
    bool? hasMore,
    bool? isInitial,
    String? error,
    bool clearError = false,
    String? category,
  }) {
    return HomeNewsState(
      articles: articles ?? this.articles,
      page: page ?? this.page,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      isInitial: isInitial ?? this.isInitial,
      error: clearError ? null : (error ?? this.error),
      category: category ?? this.category,
    );
  }
}

final homeNewsProvider =
    StateNotifierProvider.autoDispose<HomeNewsNotifier, HomeNewsState>(
  (ref) => HomeNewsNotifier(ref.watch(homeRepositoryProvider)),
);

final paginatedCategoryNewsProvider = StateNotifierProvider.family
    .autoDispose<HomeNewsNotifier, HomeNewsState, String>(
  (ref, category) => HomeNewsNotifier(
    ref.watch(homeRepositoryProvider),
    category: category,
  ),
);
