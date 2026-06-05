import 'package:flutter/material.dart';
import '../../../../features/article/model/article_model.dart';

class ArticleBody extends StatelessWidget {
  const ArticleBody({super.key, required this.article});
  final ArticleModel article;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: scheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              article.category.toUpperCase(),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: scheme.primary,
                letterSpacing: 0.8,
              ),
            ),
          ),
          Text(
            article.title,
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          Text(
            article.description,
            style: textTheme.bodyLarge?.copyWith(
              color: scheme.onSurface.withValues(alpha: 0.8),
              height: 1.65,
            ),
          ),
          ...[
          const SizedBox(height: 16),
          Text(
            article.content
                .replaceAll(RegExp(r'\[\+\d+ chars\]'), '')
                .trim(),
            style: textTheme.bodyMedium?.copyWith(
              height: 1.8,
              color: scheme.onSurface.withValues(alpha: 0.75),
            ),
          ),
        ],
        ],
      ),
    );
  }
}

