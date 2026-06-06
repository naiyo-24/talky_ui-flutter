import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../features/article/model/article_model.dart';
import '../../../../features/article/presentation/widgets/parallax_header.dart';
import '../../../../features/article/presentation/widgets/article_body.dart';
import '../../../../features/article/presentation/widgets/author_info.dart';
import '../../../../features/bookmark/providers/bookmark_provider.dart';
import '../../../../shared/widgets/news_card.dart';
import '../../../../features/article/providers/article_provider.dart';

class ArticleDetailScreen extends ConsumerStatefulWidget {
  const ArticleDetailScreen({super.key, this.articleData});
  final Map<String, dynamic>? articleData;

  @override
  ConsumerState<ArticleDetailScreen> createState() =>
      _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends ConsumerState<ArticleDetailScreen> {
  final _scrollController = ScrollController();
  late final ArticleModel _article;

  @override
  void initState() {
    super.initState();
    _article = ArticleModel.fromJson(widget.articleData ?? {});
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isBookmarked = ref.read(bookmarkProvider.notifier)
        .isBookmarked(_article.url);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          ParallaxHeader(
            article: _article,
            scrollController: _scrollController,
          ),
          SliverToBoxAdapter(child: AuthorInfo(article: _article)),
          SliverToBoxAdapter(child: ArticleBody(article: _article)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: FilledButton.icon(
                onPressed: () => _launchUrl(_article.url),
                icon: const Icon(Icons.open_in_browser_rounded),
                label: const Text('Read Full Article'),
                style: FilledButton.styleFrom(
                  backgroundColor: scheme.primary,
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ),
          // Related articles
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Text(
                'Related News',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ),
          ),
          _RelatedArticles(
            query: _article.title.split(' ').take(3).join(' '),
            currentArticleUrl: _article.url,
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(bookmarkProvider.notifier).toggle(_article);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(isBookmarked
                  ? 'Removed from bookmarks'
                  : 'Added to bookmarks'),
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          );
        },
        backgroundColor: scheme.primary,
        child: Icon(
          isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
          color: Colors.white,
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null) {
      try {
        await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
      } catch (e) {
        // Fallback to external browser if inAppBrowserView fails
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
  }
}

class _RelatedArticles extends ConsumerWidget {
  const _RelatedArticles({required this.query, required this.currentArticleUrl});
  final String query;
  final String currentArticleUrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncArticles = ref.watch(relatedArticlesProvider(query));
    return asyncArticles.when(
      loading: () => const SliverToBoxAdapter(
        child: SizedBox.shrink(),
      ),
      error: (_, _) => const SliverToBoxAdapter(child: SizedBox.shrink()),
      data: (articles) {
        final seen = <String>{currentArticleUrl};
        final uniqueArticles = <ArticleModel>[];
        for (final a in articles) {
          final id = a.url;
          if (id.isNotEmpty && !seen.contains(id)) {
            seen.add(id);
            uniqueArticles.add(a);
          }
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, i) => NewsCard(article: uniqueArticles[i], compact: false),
            childCount: uniqueArticles.length,
          ),
        );
      },
    );
  }
}
