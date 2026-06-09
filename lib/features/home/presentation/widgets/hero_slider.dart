import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../features/article/model/article_model.dart';
import '../../../../core/utils/helper.dart';

const _kAccent = Color(0xFFE53935);

/// Auto-paging PageView that cycles through breaking news articles.
class HeroSlider extends StatefulWidget {
  const HeroSlider({super.key, required this.articles});
  final List<ArticleModel> articles;

  @override
  State<HeroSlider> createState() => _HeroSliderState();
}

class _HeroSliderState extends State<HeroSlider> {
  late final PageController _ctrl;
  int _current = 0;

  @override
  void initState() {
    super.initState();
    _ctrl = PageController();
    Future.delayed(const Duration(seconds: 4), _autoScroll);
  }

  void _autoScroll() {
    if (!mounted) return;
    final next = (_current + 1) % widget.articles.length;
    _ctrl.animateToPage(
      next,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
    Future.delayed(const Duration(seconds: 4), _autoScroll);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.articles.isEmpty) return const SizedBox.shrink();

    final dotCount = widget.articles.length > 5 ? 5 : widget.articles.length;

    return Column(
      children: [
        SizedBox(
          height: 300,
          child: PageView.builder(
            controller: _ctrl,
            itemCount: widget.articles.length,
            onPageChanged: (i) => setState(() => _current = i),
            itemBuilder: (_, i) => HeroCard(article: widget.articles[i]),
          ),
        ),
        const SizedBox(height: 10),
        // Animated dot indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.arrow_back_ios_rounded,
                size: 10, color: Colors.grey.shade400),
            const SizedBox(width: 4),
            ...List.generate(
              dotCount,
              (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: _current == i ? 20 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: _current == i ? _kAccent : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.arrow_forward_ios_rounded,
                size: 10, color: Colors.grey.shade400),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '← Swipe to explore →',
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade500,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ).animate().fadeIn(duration: 400.ms);
  }
}

/// Single full-bleed card used inside [HeroSlider].
class HeroCard extends StatelessWidget {
  const HeroCard({super.key, required this.article});
  final ArticleModel article;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final urlStr = article.url.toLowerCase();
        if (urlStr.contains('youtube.com') || urlStr.contains('youtu.be')) {
          final uri = Uri.tryParse(article.url);
          if (uri != null) {
            try {
              await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
            } catch (_) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            }
            return;
          }
        }
        if (!context.mounted) return;
        context.push(
          '/article/${Uri.encodeComponent(article.url)}',
          extra: article.toJson(),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background image
              CachedNetworkImage(
                imageUrl: article.urlToImage,
                fit: BoxFit.cover,
                placeholder: (_, __) =>
                    Container(color: Colors.grey.shade800),
                errorWidget: (_, __, ___) => Container(
                  color: Colors.grey.shade800,
                  child: const Icon(Icons.newspaper_rounded,
                      size: 60, color: Colors.white24),
                ),
              ),

              // Layered gradient
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0x55000000),
                      Colors.transparent,
                      Color(0xCC000000),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.0, 0.35, 1.0],
                  ),
                ),
              ),

              // Category pill — top-right
              Positioned(
                top: 14,
                right: 14,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    article.category.isEmpty ? 'General' : article.category,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              ),

              // Bottom content
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Breaking News badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: _kAccent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.bolt_rounded,
                              color: Colors.white, size: 13),
                          SizedBox(width: 4),
                          Text(
                            'BREAKING NEWS',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Title
                    Text(
                      article.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        height: 1.35,
                        shadows: [
                          Shadow(color: Colors.black45, blurRadius: 4),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Time row
                    Row(
                      children: [
                        const Icon(Icons.access_time_rounded,
                            size: 12, color: Colors.white70),
                        const SizedBox(width: 4),
                        Text(
                          AppHelper.formatDate(article.publishedAt),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
