import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../features/bookmark/providers/bookmark_provider.dart';
import '../../../../shared/widgets/custom_appbar.dart';
import '../../../../shared/widgets/news_card.dart';

class BookmarkScreen extends ConsumerWidget {
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarks = ref.watch(bookmarkProvider);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Saved',
        actions: [
          if (bookmarks.isNotEmpty)
            TextButton(
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (dialogContext) => AlertDialog(
                    title: const Text('Clear All Bookmarks?'),
                    content: const Text(
                        'This will remove all your saved articles.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(dialogContext, false),
                        child: const Text('Cancel'),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.pop(dialogContext, true),
                        child: const Text('Clear'),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  ref.read(bookmarkProvider.notifier).clearAll();
                }
              },
              child: const Text('Clear All'),
            ),
        ],
      ),
      body: bookmarks.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.bookmark_border_rounded,
                    size: 80,
                    color: scheme.onSurface.withValues(alpha: 0.2),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No saved articles yet',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: scheme.onSurface.withValues(alpha: 0.5),
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the bookmark icon on any article to save it.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: scheme.onSurface.withValues(alpha: 0.4),
                        ),
                  ),
                ],
              ).animate().fadeIn().scale(begin: const Offset(0.9, 0.9)),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: bookmarks.length,
              itemBuilder: (_, i) => Dismissible(
                key: ValueKey(bookmarks[i].url),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 24),
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: scheme.error,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.delete_rounded, color: Colors.white),
                ),
                onDismissed: (_) => ref
                    .read(bookmarkProvider.notifier)
                    .toggle(bookmarks[i]),
                child: NewsCard(article: bookmarks[i]),
              ),
            ),
    );
  }
}

