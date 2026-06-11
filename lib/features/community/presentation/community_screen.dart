import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/router/app_router.dart';
import '../../../../l10n/app_localizations.dart';
import '../../auth/providers/auth_provider.dart';
import '../../auth/presentation/auth_screen.dart';

class CommunityScreen extends ConsumerWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final loc = AppLocalizations.of(context)!;
    final user = ref.watch(authProvider);

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
          actions: [
            if (user != null)
              IconButton(
                icon: const Icon(Icons.logout_rounded),
                onPressed: () => ref.read(authProvider.notifier).logout(),
                tooltip: 'Logout',
              ),
          ],
        ),
        body: user == null
            ? const AuthScreen()
            : _CommunityFeed(),
        floatingActionButton: user != null && user.isOfficial
            ? FloatingActionButton.extended(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Create Post feature coming soon!')),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Create Official Post'),
                backgroundColor: scheme.primary,
                foregroundColor: scheme.onPrimary,
              ).animate().scale(delay: 200.ms, curve: Curves.easeOutBack)
            : null,
      ),
    );
  }
}

class _CommunityFeed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    
    // Dummy posts for read-only view
    final dummyPosts = [
      {
        'author': 'City Police Dept.',
        'designation': 'Police',
        'content': 'Traffic advisory: Main Street will be closed tomorrow from 9 AM to 2 PM due to road repairs. Please use alternate routes.',
        'time': '2 hours ago',
      },
      {
        'author': 'Dist. Legal Services',
        'designation': 'Lawyer',
        'content': 'Free legal aid camp being organized this Sunday at the community hall. All citizens are welcome to attend for consultations.',
        'time': '5 hours ago',
      },
      {
        'author': 'Local News Network',
        'designation': 'News Channel',
        'content': 'Breaking: The new central park has been officially inaugurated by the Mayor. Open to public starting today!',
        'time': '1 day ago',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: dummyPosts.length,
      itemBuilder: (context, index) {
        final post = dummyPosts[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: scheme.primaryContainer,
                      child: Icon(Icons.verified, color: scheme.primary),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post['author']!,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            '${post['designation']} • ${post['time']}',
                            style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  post['content']!,
                  style: const TextStyle(fontSize: 15, height: 1.4),
                ),
                const SizedBox(height: 16),
                const Divider(),
                // Read-only indicator for normal users
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.visibility_rounded, size: 16, color: scheme.onSurfaceVariant),
                    const SizedBox(width: 4),
                    Text(
                      'Official Notice',
                      style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ).animate().fadeIn(delay: (index * 150).ms).slideY(begin: 0.1);
      },
    );
  }
}
