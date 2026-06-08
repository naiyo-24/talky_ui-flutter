import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/router/app_router.dart';
import '../../../../l10n/app_localizations.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final loc = AppLocalizations.of(context)!;
    
    final items = [
      {'title': loc.polls, 'icon': Icons.poll_rounded, 'color': Colors.blue, 'route': '/community/polls'},
      {'title': loc.feedback, 'icon': Icons.rate_review_rounded, 'color': Colors.orange, 'route': '/community/feedback'},
      {'title': loc.localIssues, 'icon': Icons.report_problem_rounded, 'color': Colors.red, 'route': '/community/issues'},
      {'title': loc.events, 'icon': Icons.event_rounded, 'color': Colors.green, 'route': '/community/events'},
    ];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (context.canPop()) {
          context.pop();
          return;
        }
        NavigationShellProvider.of(context).goBranch(0);
      },
      child: Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            NavigationShellProvider.of(context).goBranch(0);
          },
        ),
        title: Text(loc.community),
        centerTitle: true,
        backgroundColor: scheme.surface,
        elevation: 0,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.1,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return GestureDetector(
            onTap: () => context.go(item['route'] as String),
            child: Container(
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: scheme.outlineVariant),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: (item['color'] as Color).withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      item['icon'] as IconData,
                      size: 40,
                      color: item['color'] as Color,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    item['title'] as String,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(delay: (index * 100).ms).scale(begin: const Offset(0.9, 0.9));
        },
      ),
    ),
    );
  }
}
