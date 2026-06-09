import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/repository/json_repository.dart';
import '../../../../features/home/providers/home_provider.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart';

// ── Component imports ───────────────────────────────────────────────────────
import '../widgets/district_selector.dart';
import '../widgets/hero_slider.dart';
import '../widgets/explore_categories.dart';
import '../widgets/pill_tab_bar.dart';
import '../widgets/big_news_card.dart';
import '../widgets/compact_news_card.dart';
import '../widgets/load_more_trigger.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/home_drawer.dart';

const _kAccent = Color(0xFFE53935);

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeNewsProvider);
    final breakingAsync = ref.watch(breakingNewsProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      drawer: const HomeDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(jsonRepositoryProvider);
          ref.invalidate(breakingNewsProvider);
          await ref.read(homeNewsProvider.notifier).refresh();
        },
        color: _kAccent,
        child: CustomScrollView(
          slivers: [
            // ── App Bar ───────────────────────────────────────────────────
            const HomeAppBar(),

            // ── District Selector ─────────────────────────────────────────
            const SliverToBoxAdapter(child: DistrictSelector()),

            // ── Breaking News Hero Slider ─────────────────────────────────
            SliverToBoxAdapter(
              child: breakingAsync.when(
                loading: () =>
                    const SizedBox(height: 300, child: LoadingWidget()),
                error: (_, __) => const SizedBox.shrink(), // ignore: avoid_returning_null_for_void
                data: (articles) => HeroSlider(articles: articles),
              ),
            ),

            // ── Explore Categories ────────────────────────────────────────
            SliverToBoxAdapter(
              child: ExploreCategoriesSection(
                onCategoryTap: (cat) => context.push('/category/$cat'),
              ),
            ),

            // ── Pill Filter Tabs ──────────────────────────────────────────
            SliverToBoxAdapter(
              child: PillTabBar(
                selectedCategory: state.category,
                onCategoryChanged: (cat) =>
                    ref.read(homeNewsProvider.notifier).changeCategory(cat),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 12)),

            // ── News Feed ────────────────────────────────────────────────
            _buildNewsFeed(context, ref, state),

            const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsFeed(
      BuildContext context, WidgetRef ref, HomeNewsState state) {
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
          // End sentinel: loading indicator / load-more trigger / end label
          if (index == state.articles.length) {
            if (state.isLoadingMore) {
              return const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (state.hasMore) {
              return LoadMoreTrigger(
                onVisible: () =>
                    ref.read(homeNewsProvider.notifier).fetchPage(),
              );
            }
            return const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: Text('No more articles')),
            );
          }

          // Every 3rd article gets a big card; the rest are compact
          final article = state.articles[index];
          return index % 3 == 0
              ? BigNewsCard(article: article, index: index)
              : CompactNewsCard(article: article, index: index);
        },
        childCount: state.articles.length + 1,
      ),
    );
  }
}
