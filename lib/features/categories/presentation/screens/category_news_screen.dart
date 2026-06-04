import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../features/categories/providers/category_provider.dart';
import '../../../../shared/widgets/custom_appbar.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../../../../shared/widgets/news_card.dart';

class CategoryNewsScreen extends ConsumerWidget {
  const CategoryNewsScreen({super.key, required this.category});
  final String category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncArticles = ref.watch(categoryNewsProvider(category));

    return Scaffold(
      appBar: CustomAppBar(title: category),
      body: asyncArticles.when(
        loading: () => const LoadingWidget(),
        error: (e, _) => AppErrorWidget(
          message: e.toString(),
          onRetry: () => ref.invalidate(categoryNewsProvider(category)),
        ),
        data: (articles) => ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: articles.length,
          itemBuilder: (_, i) => NewsCard(article: articles[i]),
        ),
      ),
    );
  }
}
