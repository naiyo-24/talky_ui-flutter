import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../l10n/app_localizations.dart';

/// Side drawer with navigation links to all main sections of the app.
class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final loc = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      backgroundColor: scheme.surface,
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest.withValues(alpha: 0.3),
            ),
            child: Center(
              child: Image.asset(
                isDark
                    ? 'assets/images/Logo_For_Dark_Mode.png'
                    : 'assets/images/Logo_Without_BG.png',
                height: 50,
              ),
            ),
          ),
          _DrawerItem(
            icon: Icons.home_rounded,
            label: loc.home,
            onTap: () {
              context.pop();
              NavigationShellProvider.of(context).goBranch(0);
            },
          ),
          _DrawerItem(
            icon: Icons.play_circle_fill_rounded,
            label: loc.reels,
            onTap: () {
              context.pop();
              NavigationShellProvider.of(context).goBranch(1);
            },
          ),
          _DrawerItem(
            icon: Icons.search_rounded,
            label: loc.search,
            onTap: () {
              context.pop();
              NavigationShellProvider.of(context).goBranch(2);
            },
          ),
          _DrawerItem(
            icon: Icons.people_alt_rounded,
            label: loc.community,
            onTap: () {
              context.pop();
              NavigationShellProvider.of(context).goBranch(3);
            },
          ),
          _DrawerItem(
            icon: Icons.bookmark_rounded,
            label: loc.savedNews,
            onTap: () {
              context.pop();
              context.push('/bookmarks');
            },
          ),
          _DrawerItem(
            icon: Icons.settings_rounded,
            label: loc.settings,
            onTap: () {
              context.pop();
              NavigationShellProvider.of(context).goBranch(4);
            },
          ),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Version 1.0.0',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label,
          style: const TextStyle(fontWeight: FontWeight.w600)),
      onTap: onTap,
    );
  }
}
