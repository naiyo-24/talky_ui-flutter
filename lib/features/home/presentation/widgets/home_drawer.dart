import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../l10n/app_localizations.dart';

const _kAccent = Color(0xFFE53935);

/// Premium side drawer with grouped navigation, animated tiles, and styled footer.
class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final loc = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentIndex = NavigationShellProvider.of(context).currentIndex;

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.78,
      backgroundColor: scheme.surface,
      child: Column(
        children: [
          // ── Premium Header ─────────────────────────────────────────────
          _DrawerHeader(isDark: isDark, scheme: scheme),

          // ── Main Navigation ────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),

                  // Section: Main
                  _NavTile(
                    icon: Icons.home_rounded,
                    label: loc.home,
                    isActive: currentIndex == 0,
                    delay: 0,
                    onTap: () {
                      context.pop();
                      NavigationShellProvider.of(context).goBranch(0);
                    },
                  ),
                  _NavTile(
                    icon: Icons.play_circle_fill_rounded,
                    label: 'Tbite',
                    isActive: currentIndex == 1,
                    delay: 50,
                    onTap: () {
                      context.pop();
                      NavigationShellProvider.of(context).goBranch(1);
                    },
                  ),
                  _NavTile(
                    icon: Icons.people_alt_rounded,
                    label: loc.community,
                    isActive: currentIndex == 2,
                    delay: 100,
                    onTap: () {
                      context.pop();
                      NavigationShellProvider.of(context).goBranch(2);
                    },
                  ),
                  const SizedBox(height: 4),
                  _Divider(),

                  // Section: My Content
                  _NavTile(
                    icon: Icons.notifications_rounded,
                    label: 'Notifications',
                    isActive: false,
                    delay: 200,
                    badge: 'New',
                    onTap: () {
                      context.pop();
                      context.push('/notifications');
                    },
                  ),

                  const SizedBox(height: 4),
                  _Divider(),

                  // Section: Preferences

                  _NavTile(
                    icon: Icons.language_rounded,
                    label: loc.language,
                    isActive: false,
                    delay: 350,
                    onTap: () {
                      context.pop();
                      context.push('/language');
                    },
                  ),
                  _NavTile(
                    icon: Icons.settings_rounded,
                    label: loc.settings,
                    isActive: false,
                    delay: 400,
                    onTap: () {
                      context.pop();
                      context.push('/settings');
                    },
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // ── Footer Removed ────────────────────────────────────────────
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Header with gradient background + logo + tagline
// ─────────────────────────────────────────────────────────────────────────────
class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader({required this.isDark, required this.scheme});
  final bool isDark;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 24,
        bottom: 16,
        left: 20,
        right: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            isDark
                ? 'assets/images/Logo_For_Dark_Mode.png'
                : 'assets/images/Logo_Without_BG.png',
            width: 140,
            fit: BoxFit.contain,
          )
              .animate()
              .fadeIn(duration: 400.ms)
              .slideY(begin: -0.3, end: 0),
        ],
      ),
    );
  }
}


// ─────────────────────────────────────────────────────────────────────────────
// Animated nav tile — active state gets accent left bar + tinted background
// ─────────────────────────────────────────────────────────────────────────────
class _NavTile extends StatelessWidget {
  const _NavTile({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
    this.delay = 0,
    this.badge,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final int delay;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: isActive
              ? _kAccent
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            if (isActive)
              Container(
                width: 3,
                height: 22,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            if (!isActive)
              const SizedBox(width: 15),

            // Icon
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isActive
                    ? Colors.white.withValues(alpha: 0.2)
                    : scheme.onSurface.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 18,
                color: isActive
                    ? Colors.white
                    : scheme.onSurface.withValues(alpha: 0.65),
              ),
            ),
            const SizedBox(width: 12),

            // Label
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight:
                      isActive ? FontWeight.w700 : FontWeight.w500,
                  color: isActive
                      ? Colors.white
                      : scheme.onSurface.withValues(alpha: 0.85),
                ),
              ),
            ),

            // Optional badge
            if (badge != null)
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: _kAccent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  badge!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

            // Active chevron
            if (isActive)
              Icon(Icons.chevron_right_rounded,
                  size: 18, color: _kAccent.withValues(alpha: 0.7)),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(delay: Duration(milliseconds: delay), duration: 250.ms)
        .slideX(begin: -0.15, end: 0);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Light divider between sections
// ─────────────────────────────────────────────────────────────────────────────
class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      indent: 20,
      endIndent: 20,
      thickness: 0.8,
      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08),
    );
  }
}

