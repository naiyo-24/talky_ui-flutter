import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../features/article/model/article_model.dart';
import '../repository/article_repository.dart';

final relatedArticlesProvider =
    FutureProvider.autoDispose.family<List<ArticleModel>, String>((ref, query) {
  return ref.watch(articleRepositoryProvider).fetchRelated(query);
});
