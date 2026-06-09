import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../features/article/model/article_model.dart';
import '../../../../core/utils/helper.dart';

const _kAccent = Color(0xFFE53935);

/// Compact thumbnail-left, text-right news card.
/// Shown for all non-featured positions in the news list.
class CompactNewsCard extends StatelessWidget {
  const CompactNewsCard({
    super.key,
    required this.article,
    required this.index,
  });

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
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: scheme.shadow.withValues(alpha: 0.07),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: article.urlToImage,
                width: 88,
                height: 78,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  color: scheme.surfaceContainerHighest,
                  width: 88,
                  height: 78,
                ),
                errorWidget: (_, __, ___) => Container(
                  color: scheme.surfaceContainerHighest,
                  width: 88,
                  height: 78,
                  child: Icon(Icons.newspaper_rounded,
                      color: scheme.onSurface.withValues(alpha: 0.3)),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Content column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category tag
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: _kAccent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      article.category.isEmpty ? 'GENERAL' : article.category,
                      style: const TextStyle(
                        color: _kAccent,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),

                  // Title
                  Text(
                    article.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          height: 1.35,
                          fontSize: 13,
                        ),
                  ),
                  const SizedBox(height: 6),

                  // Published time
                  Row(
                    children: [
                      Icon(Icons.access_time_rounded,
                          size: 11,
                          color: scheme.onSurface.withValues(alpha: 0.4)),
                      const SizedBox(width: 3),
                      Text(
                        AppHelper.formatDate(article.publishedAt),
                        style: TextStyle(
                          fontSize: 11,
                          color: scheme.onSurface.withValues(alpha: 0.45),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Bookmark icon
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Icon(Icons.bookmark_border_rounded,
                  size: 20,
                  color: scheme.onSurface.withValues(alpha: 0.35)),
            ),
          ],
        ),
      ).animate().fadeIn(
            delay: Duration(milliseconds: 60 * (index % 10)),
            duration: 300.ms,
          ),
    );
  }
}
