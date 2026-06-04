import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../features/article/model/article_model.dart';
import '../repository/category_repository.dart';

final categoryNewsProvider = FutureProvider.autoDispose
    .family<List<ArticleModel>, String>((ref, category) {
  return ref.watch(categoryRepositoryProvider).fetchByCategory(
        category: category,
      );
});
