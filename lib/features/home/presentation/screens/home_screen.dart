import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/helper.dart';
import '../../../../features/article/model/article_model.dart';
import '../../../../features/home/providers/home_provider.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeNewsProvider);
    final breakingAsync = ref.watch(breakingNewsProvider);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      drawer: _buildDrawer(context, scheme),
      body: RefreshIndicator(
        onRefresh: () => ref.read(homeNewsProvider.notifier).refresh(),
        color: const Color(0xFFE53935),
        child: CustomScrollView(
          slivers: [
            // ── App Bar ──────────────────────────────────────────────────
            SliverAppBar(
              pinned: true,
              floating: true,
              snap: true,
              backgroundColor: scheme.surface,
              elevation: 0,
              surfaceTintColor: Colors.transparent,
              leading: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Builder(
                  builder: (context) {
                    return IconButton(
                      icon: Icon(Icons.menu_rounded,
                          color: scheme.onSurface, size: 26),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    );
                  }
                ),
              ),
              title: Image.asset(
                Theme.of(context).brightness == Brightness.dark
                    ? 'assets/images/Logo_For_Dark_Mode.png'
                    : 'assets/images/Logo_Without_BG.png',
                width: 140,
                fit: BoxFit.contain,
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: Icon(Icons.search_rounded, color: scheme.onSurface),
                  onPressed: () => context.push('/search'),
                ),
                IconButton(
                  icon: Icon(Icons.bookmark_border_rounded,
                      color: scheme.onSurface),
                  onPressed: () => context.go('/bookmarks'),
                ),
                const SizedBox(width: 4),
              ],
            ),

            // ── Tab Row ───────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: _TabBar(
                selectedCategory: state.category,
                onCategoryChanged: (cat) =>
                    ref.read(homeNewsProvider.notifier).changeCategory(cat),
              ),
            ),

            // ── Hero Slider ───────────────────────────────────────────────
            SliverToBoxAdapter(
              child: breakingAsync.when(
                loading: () => const SizedBox(
                  height: 230,
                  child: LoadingWidget(),
                ),
                error: (_, _) => const SizedBox.shrink(),
                data: (articles) => _HeroSlider(articles: articles),
              ),
            ),

            // ── Explore Categories ─────────────────────────────────────
            SliverToBoxAdapter(
              child: _ExploreCategoriesSection(
                onCategoryTap: (cat) => context.push('/category/$cat'),
              ),
            ),

            // ── Latest News Header ──────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'LATEST NEWS',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.6,
                          ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'View All >',
                        style: TextStyle(
                            color: Color(0xFFE53935),
                            fontWeight: FontWeight.w700,
                            fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Latest News List ────────────────────────────────────────
            if (state.isInitial && state.isLoadingMore)
              const SliverFillRemaining(child: LoadingWidget())
            else if (state.isInitial && state.error != null)
              SliverFillRemaining(
                child: AppErrorWidget(
                  message: state.error!,
                  onRetry: () =>
                      ref.read(homeNewsProvider.notifier).refresh(),
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index == state.articles.length) {
                      return state.isLoadingMore
                          ? const Padding(
                              padding: EdgeInsets.all(24),
                              child:
                                  Center(child: CircularProgressIndicator()),
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
                                      child: Text('No more articles')),
                                );
                    }
                    return _LatestNewsCard(
                        article: state.articles[index], index: index);
                  },
                  childCount: state.articles.length + 1,
                ),
              ),

            const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, ColorScheme scheme) {
    return Drawer(
      backgroundColor: scheme.surface,
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest.withValues(alpha: 0.3),
            ),
            child: Center(
              child: Image.asset(
                Theme.of(context).brightness == Brightness.dark
                    ? 'assets/images/Logo_For_Dark_Mode.png'
                    : 'assets/images/Logo_Without_BG.png',
                height: 50,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_rounded),
            title: const Text('Home', style: TextStyle(fontWeight: FontWeight.w600)),
            onTap: () {
              context.pop(); // close drawer
            },
          ),
          ListTile(
            leading: const Icon(Icons.search_rounded),
            title: const Text('Search', style: TextStyle(fontWeight: FontWeight.w600)),
            onTap: () {
              context.pop();
              context.push('/search');
            },
          ),
          ListTile(
            leading: const Icon(Icons.bookmark_rounded),
            title: const Text('Saved News', style: TextStyle(fontWeight: FontWeight.w600)),
            onTap: () {
              context.pop();
              context.go('/bookmarks');
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings_rounded),
            title: const Text('Settings', style: TextStyle(fontWeight: FontWeight.w600)),
            onTap: () {
              context.pop();
              context.go('/settings');
            },
          ),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Version 1.0.0', style: TextStyle(color: Colors.grey, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Horizontal Tab Bar (HOME / LATEST / TRENDING / VIDEO)
// ─────────────────────────────────────────────────────────────────────────────
class _TabBar extends StatelessWidget {
  const _TabBar(
      {required this.selectedCategory, required this.onCategoryChanged});
  final String selectedCategory;
  final ValueChanged<String> onCategoryChanged;

  static const _tabs = ['Top', 'Business', 'Technology', 'Sports', 'Health'];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _tabs.length,
        separatorBuilder: (_, _) => const SizedBox(width: 24),
        itemBuilder: (context, i) {
          final tab = _tabs[i];
          final selected = selectedCategory == tab;
          return GestureDetector(
            onTap: () => onCategoryChanged(tab),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  tab.toUpperCase(),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight:
                        selected ? FontWeight.w800 : FontWeight.w500,
                    color: selected
                        ? const Color(0xFFE53935)
                        : Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.5),
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 4),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  height: 2.5,
                  width: selected ? 28 : 0,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE53935),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Hero Slider with auto-scroll + pagination dots
// ─────────────────────────────────────────────────────────────────────────────
class _HeroSlider extends StatefulWidget {
  const _HeroSlider({required this.articles});
  final List<ArticleModel> articles;

  @override
  State<_HeroSlider> createState() => _HeroSliderState();
}

class _HeroSliderState extends State<_HeroSlider> {
  late final CardSwiperController _swiperController;

  @override
  void initState() {
    super.initState();
    _swiperController = CardSwiperController();
  }

  @override
  void dispose() {
    _swiperController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.articles.isEmpty) return const SizedBox.shrink();
    
    return Column(
      children: [
        SizedBox(
          height: 230,
          child: CardSwiper(
            controller: _swiperController,
            cardsCount: widget.articles.length,
            numberOfCardsDisplayed: widget.articles.length > 3 ? 3 : widget.articles.length,
            backCardOffset: const Offset(30, 0),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            isLoop: true,
            cardBuilder: (context, index, horizontalOffsetPercentage, verticalOffsetPercentage) {
              return _HeroCard(
                article: widget.articles[index],
                index: index,
                total: widget.articles.length,
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        // Helper text since dots don't make sense for Tinder-swipe
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.swipe_outlined, size: 14, color: Colors.grey.shade500),
            const SizedBox(width: 6),
            Text(
              'Swipe to explore',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    ).animate().fadeIn(duration: 400.ms);
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({
    required this.article,
    required this.index,
    required this.total,
  });
  final ArticleModel article;
  final int index;
  final int total;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(
        '/article/${Uri.encodeComponent(article.url ?? '')}',
        extra: article.toJson(),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ── Background image ──────────────────────────────
            CachedNetworkImage(
              imageUrl: article.urlToImage ?? '',
              fit: BoxFit.cover,
              placeholder: (_, _) =>
                  Container(color: Colors.grey.shade800),
              errorWidget: (_, _, _) => Container(
                color: Colors.grey.shade800,
                child: const Icon(Icons.newspaper_rounded,
                    size: 60, color: Colors.white24),
              ),
            ),
            // ── Dark gradient overlay ──────────────────────────────────
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Color(0xCC000000)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.30, 1.0],
                ),
              ),
            ),
              // ── TOP NEWS badge + counter ───────────────────────────────
              Positioned(
                top: 12,
                left: 12,
                right: 12,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE53935),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'TOP NEWS',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${index + 1}/$total',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // ── Title, time, category ──────────────────────────────────
              Positioned(
                bottom: 12,
                left: 12,
                right: 36,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.title ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          AppHelper.formatDate(article.publishedAt),
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 11),
                        ),
                        const SizedBox(width: 6),
                        const Text('|',
                            style: TextStyle(
                                color: Colors.white54, fontSize: 11)),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            article.category ?? 'General',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFFE53935),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // ── Bookmark icon ──────────────────────────────────────────
              const Positioned(
                bottom: 12,
                right: 12,
                child: Icon(Icons.bookmark_border_rounded,
                    color: Colors.white70, size: 20),
              ),
            ],
          ),
        ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Explore Categories Grid
// ─────────────────────────────────────────────────────────────────────────────
class _ExploreCategoriesSection extends StatelessWidget {
  const _ExploreCategoriesSection({required this.onCategoryTap});
  final ValueChanged<String> onCategoryTap;

  static const _categoryColors = [
    Color(0xFFE53935), // Business - red
    Color(0xFF1E88E5), // Technology - blue
    Color(0xFF43A047), // Sports - green
    Color(0xFF8E24AA), // Entertainment - purple
    Color(0xFF00ACC1), // Science - teal
    Color(0xFFE91E63), // Health - pink
    Color(0xFFFF8F00), // Politics - amber
    Color(0xFF5E35B1), // World - deep purple
    Color(0xFF00897B), // Travel - teal-green
    Color(0xFFD81B60), // Fashion - rose
  ];

  @override
  Widget build(BuildContext context) {
    final cats = AppConstants.exploreCategories;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'EXPLORE CATEGORIES',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.6,
                    ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('View All >',
                    style: TextStyle(
                        color: Color(0xFFE53935),
                        fontWeight: FontWeight.w700,
                        fontSize: 13)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              mainAxisSpacing: 14,
              crossAxisSpacing: 8,
              childAspectRatio: 0.75,
            ),
            itemCount: cats.length,
            itemBuilder: (context, i) {
              final cat = cats[i];
              final color = _categoryColors[i % _categoryColors.length];
              return GestureDetector(
                onTap: () => onCategoryTap(cat['label'] as String),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: color.withValues(alpha: 0.25), width: 1.2),
                      ),
                      child: Icon(
                        IconData(cat['icon'] as int,
                            fontFamily: 'MaterialIcons'),
                        color: color,
                        size: 26,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      (cat['label'] as String).toUpperCase(),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.75),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(
                    delay: Duration(milliseconds: 50 * i),
                    duration: 300.ms,
                  );
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Compact Latest News Card (thumbnail left, text right)
// ─────────────────────────────────────────────────────────────────────────────
class _LatestNewsCard extends StatelessWidget {
  const _LatestNewsCard({required this.article, required this.index});
  final ArticleModel article;
  final int index;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => context.push(
        '/article/${Uri.encodeComponent(article.url ?? '')}',
        extra: article.toJson(),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: scheme.shadow.withValues(alpha: 0.06),
              blurRadius: 14,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: article.urlToImage ?? '',
                width: 90,
                height: 78,
                fit: BoxFit.cover,
                placeholder: (_, _) => Container(
                    color: scheme.surfaceContainerHighest,
                    width: 90,
                    height: 78),
                errorWidget: (_, _, _) => Container(
                  color: scheme.surfaceContainerHighest,
                  width: 90,
                  height: 78,
                  child: Icon(Icons.newspaper_rounded,
                      color: scheme.onSurface.withValues(alpha: 0.3)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          height: 1.35,
                          fontSize: 13,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        AppHelper.formatDate(article.publishedAt),
                        style: TextStyle(
                          fontSize: 11,
                          color: scheme.onSurface.withValues(alpha: 0.45),
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text('|',
                          style: TextStyle(
                              color: Colors.grey, fontSize: 10)),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          article.category ?? 'General',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFFE53935),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Bookmark icon
            Icon(Icons.bookmark_border_rounded,
                size: 20, color: scheme.onSurface.withValues(alpha: 0.4)),
          ],
        ),
      ).animate().fadeIn(
            delay: Duration(milliseconds: 60 * (index % 10)),
            duration: 300.ms,
          ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Load More Trigger
// ─────────────────────────────────────────────────────────────────────────────
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
