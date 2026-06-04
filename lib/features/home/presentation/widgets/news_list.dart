import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../features/home/providers/home_provider.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../../../../shared/widgets/news_card.dart';

class NewsList extends ConsumerWidget {
  const NewsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeNewsProvider);

    if (state.isInitial && state.isLoadingMore) {
      return const SliverFillRemaining(child: LoadingWidget());
    }

    if (state.isInitial && state.error != null) {
      return SliverFillRemaining(
        child: AppErrorWidget(
          message: state.error!,
          onRetry: () => ref.read(homeNewsProvider.notifier).refresh(),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index == state.articles.length) {
            return state.isLoadingMore
                ? const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : state.hasMore
                    ? _LoadMoreTrigger(
                        onVisible: () => ref
                            .read(homeNewsProvider.notifier)
                            .fetchPage(),
                      )
                    : const Padding(
                        padding: EdgeInsets.all(24),
                        child: Center(
                          child: Text('No more articles'),
                        ),
                      );
          }
          return NewsCard(article: state.articles[index]);
        },
        childCount: state.articles.length + 1,
      ),
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
