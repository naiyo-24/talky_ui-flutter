import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../features/article/model/article_model.dart';
import '../../core/utils/helper.dart';

class NewsCard extends StatelessWidget {
  const NewsCard({
    super.key,
    required this.article,
    this.compact = false,
  });

  final ArticleModel article;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => context.push(
        '/article/${Uri.encodeComponent(article.url ?? '')}',
        extra: article.toJson(),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: scheme.shadow.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!compact) _buildImage(context),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (article.category != null)
                      _buildCategoryChip(context, scheme),
                    const SizedBox(height: 8),
                    Text(
                      article.title ?? 'No Title',
                      maxLines: compact ? 2 : 3,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        height: 1.4,
                      ),
                    ),
                    if (!compact) ...[
                      const SizedBox(height: 6),
                      Text(
                        article.description ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodySmall?.copyWith(
                          color: scheme.onSurface.withValues(alpha: 0.55),
                          height: 1.5,
                        ),
                      ),
                    ],
                    const SizedBox(height: 10),
                    _buildMeta(context, scheme),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 350.ms).slideY(begin: 0.1, duration: 350.ms);
  }

  Widget _buildImage(BuildContext context) {
    return Hero(
      tag: article.url ?? article.title ?? '',
      child: CachedNetworkImage(
        imageUrl: article.urlToImage ?? '',
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
        placeholder: (_, _) => Container(
          height: 200,
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: const Center(
            child: Icon(Icons.image_outlined, size: 48),
          ),
        ),
        errorWidget: (_, _, _) => Container(
          height: 200,
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: const Center(
            child: Icon(Icons.broken_image_outlined, size: 48),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(BuildContext context, ColorScheme scheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: scheme.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        article.category?.toUpperCase() ?? '',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: scheme.primary,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildMeta(BuildContext context, ColorScheme scheme) {
    return Row(
      children: [
        Icon(Icons.source_outlined,
            size: 14, color: scheme.onSurface.withValues(alpha: 0.4)),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            article.source ?? 'Unknown Source',
            style: TextStyle(
              fontSize: 12,
              color: scheme.onSurface.withValues(alpha: 0.5),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          AppHelper.formatDate(article.publishedAt),
          style: TextStyle(
            fontSize: 11,
            color: scheme.onSurface.withValues(alpha: 0.4),
          ),
        ),
      ],
    );
  }
}

