import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/home_provider.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../../../../shared/widgets/news_card.dart';

class CategoryScreen extends ConsumerWidget {
  const CategoryScreen({super.key, required this.category});

  final String category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the new paginated provider
    final state = ref.watch(paginatedCategoryNewsProvider(category));
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        title: Text(
          category.toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18, letterSpacing: 0.5),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
        backgroundColor: scheme.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(paginatedCategoryNewsProvider(category).notifier).refresh(),
        color: const Color(0xFFE53935),
        child: _buildBody(state, ref),
      ),
    );
  }

  Widget _buildBody(HomeNewsState state, WidgetRef ref) {
    if (state.isInitial && state.isLoadingMore) {
      return const LoadingWidget();
    }
    if (state.isInitial && state.error != null) {
      return AppErrorWidget(
        message: state.error!,
        onRetry: () => ref.read(paginatedCategoryNewsProvider(category).notifier).refresh(),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: state.articles.length + 1,
      itemBuilder: (context, index) {
        if (index == state.articles.length) {
          if (state.isLoadingMore) {
            return const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator()),
            );
          } else if (state.hasMore) {
            return _LoadMoreTrigger(
              onVisible: () => ref.read(paginatedCategoryNewsProvider(category).notifier).fetchPage(),
            );
          } else {
            return const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: Text('No more articles')),
            );
          }
        }
        return NewsCard(article: state.articles[index], compact: false);
      },
    );
  }
}

class _LoadMoreTrigger extends StatefulWidget {
  const _LoadMoreTrigger({required this.onVisible});
  final VoidCallback onVisible;

  @override
  State<_LoadMoreTrigger> createState() => _LoadMoreTriggerState();
}

class _LoadMoreTriggerState extends State<_LoadMoreTrigger> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => widget.onVisible());
  }

  @override
  Widget build(BuildContext context) => const SizedBox(height: 60);
}
