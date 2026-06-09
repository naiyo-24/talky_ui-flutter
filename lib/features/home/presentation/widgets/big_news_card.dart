import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../features/article/model/article_model.dart';

const _kAccent = Color(0xFFE53935);

/// Full-image card with gradient overlay and category badge.
/// Shown every 3rd position in the news list.
class BigNewsCard extends StatelessWidget {
  const BigNewsCard({super.key, required this.article, required this.index});
  final ArticleModel article;
  final int index;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

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
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: scheme.shadow.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // Full-width image
              CachedNetworkImage(
                imageUrl: article.urlToImage,
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  height: 220,
                  color: scheme.surfaceContainerHighest,
                ),
                errorWidget: (_, __, ___) => Container(
                  height: 220,
                  color: scheme.surfaceContainerHighest,
                  child: Icon(Icons.newspaper_rounded,
                      size: 48,
                      color: scheme.onSurface.withValues(alpha: 0.3)),
                ),
              ),

              // Gradient overlay
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, Color(0xDD000000)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.4, 1.0],
                    ),
                  ),
                ),
              ),

              // Category badge — top right
              Positioned(
                top: 14,
                right: 14,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _kAccent,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    article.category.isEmpty ? 'GENERAL' : article.category,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),

              // Title + description — bottom
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      article.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ).animate().fadeIn(
            delay: Duration(milliseconds: 60 * (index % 10)),
            duration: 350.ms,
          ),
    );
  }
}
