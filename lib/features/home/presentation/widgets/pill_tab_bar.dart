import 'package:flutter/material.dart';

const _kAccent = Color(0xFFE53935);

/// Horizontally scrollable pill-shaped filter tabs (Home / Trending / Latest …).
class PillTabBar extends StatelessWidget {
  const PillTabBar({
    super.key,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  final String selectedCategory;
  final ValueChanged<String> onCategoryChanged;

  static const _tabs = [
    ('Home', Icons.person_rounded),
    ('Trending', Icons.trending_up_rounded),
    ('Latest', Icons.schedule_rounded),
    ('Video', Icons.play_circle_rounded),
    ('Podcast', Icons.mic_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _tabs.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final (label, icon) = _tabs[i];
          final selected = selectedCategory == label;

          return GestureDetector(
            onTap: () {
              if (label == 'Podcast') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Podcasts coming soon!')),
                );
                return;
              }
              onCategoryChanged(label);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: selected ? _kAccent : Colors.transparent,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: selected
                      ? _kAccent
                      : Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.15),
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: 15,
                    color: selected
                        ? Colors.white
                        : Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.6),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: selected
                          ? Colors.white
                          : Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.65),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
