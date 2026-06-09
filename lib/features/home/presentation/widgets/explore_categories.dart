import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';

const _kAccent = Color(0xFFE53935);

/// "EXPLORE CATEGORIES" header + horizontally scrollable chip row.
class ExploreCategoriesSection extends StatelessWidget {
  const ExploreCategoriesSection({super.key, required this.onCategoryTap});
  final ValueChanged<String> onCategoryTap;

  /// Number of categories visible in the strip (rest accessible via View All).
  static const _shown = 8;

  @override
  Widget build(BuildContext context) {
    final cats = AppConstants.exploreCategories.take(_shown).toList();
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'EXPLORE CATEGORIES',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.8,
                        color: scheme.onSurface,
                      ),
                ),
                GestureDetector(
                  onTap: () => context.push('/categories'),
                  child: const Text(
                    'View All >',
                    style: TextStyle(
                      color: _kAccent,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // ── Scrollable chip list ────────────────────────────────────────
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: cats.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final cat = cats[i];
                return CategoryChip(
                  emoji: cat['emoji'] as String,
                  label: cat['label'] as String,
                  onTap: () => onCategoryTap(cat['label'] as String),
                )
                    .animate()
                    .fadeIn(
                      delay: Duration(milliseconds: 50 * i),
                      duration: 300.ms,
                    )
                    .slideX(begin: 0.2, end: 0);
              },
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

/// Pill chip showing an emoji + category label.
class CategoryChip extends StatelessWidget {
  const CategoryChip({
    super.key,
    required this.emoji,
    required this.label,
    required this.onTap,
  });

  final String emoji;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    // Title-case: "WEST BENGAL" → "West Bengal"
    final display = label
        .split(' ')
        .map((w) => w.isEmpty
            ? ''
            : '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}')
        .join(' ');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: scheme.onSurface.withValues(alpha: 0.12),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: scheme.shadow.withValues(alpha: 0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 6),
            Text(
              display,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: scheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
