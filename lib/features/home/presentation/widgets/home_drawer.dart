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
                  _SectionLabel('MAIN'),
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
                    label: loc.reels,
                    isActive: currentIndex == 1,
                    delay: 50,
                    onTap: () {
                      context.pop();
                      NavigationShellProvider.of(context).goBranch(1);
                    },
                  ),
                  _NavTile(
                    icon: Icons.search_rounded,
                    label: loc.search,
                    isActive: currentIndex == 2,
                    delay: 100,
                    onTap: () {
                      context.pop();
                      NavigationShellProvider.of(context).goBranch(2);
                    },
                  ),
                  _NavTile(
                    icon: Icons.people_alt_rounded,
                    label: loc.community,
                    isActive: currentIndex == 3,
                    delay: 150,
                    onTap: () {
                      context.pop();
                      NavigationShellProvider.of(context).goBranch(3);
                    },
                  ),

                  const SizedBox(height: 4),
                  _Divider(),

                  // Section: My Content
                  _SectionLabel('MY CONTENT'),
                  _NavTile(
                    icon: Icons.bookmark_rounded,
                    label: loc.savedNews,
                    isActive: false,
                    delay: 200,
                    badge: '3',
                    onTap: () {
                      context.pop();
                      context.push('/bookmarks');
                    },
                  ),
                  _NavTile(
                    icon: Icons.explore_rounded,
                    label: loc.exploreCategories,
                    isActive: false,
                    delay: 250,
                    onTap: () {
                      context.pop();
                      context.push('/categories');
                    },
                  ),

                  const SizedBox(height: 4),
                  _Divider(),

                  // Section: Preferences
                  _SectionLabel('PREFERENCES'),
                  _NavTile(
                    icon: Icons.location_on_rounded,
                    label: loc.district,
                    isActive: false,
                    delay: 300,
                    onTap: () {
                      context.pop();
                      context.push('/district');
                    },
                  ),
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
                    isActive: currentIndex == 4,
                    delay: 400,
                    onTap: () {
                      context.pop();
                      NavigationShellProvider.of(context).goBranch(4);
                    },
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // ── Footer ────────────────────────────────────────────────────
          _DrawerFooter(scheme: scheme),
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
        bottom: 28,
        left: 20,
        right: 20,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFB71C1C), Color(0xFFE53935), Color(0xFFEF5350)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo on white pill
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Image.asset(
              'assets/images/Logo_Without_BG.png',
              height: 32,
              fit: BoxFit.contain,
            ),
          )
              .animate()
              .fadeIn(duration: 400.ms)
              .slideY(begin: -0.3, end: 0),
          const SizedBox(height: 16),

          // Tagline
          Text(
            'Your trusted\nnews companion',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              height: 1.4,
              letterSpacing: 0.2,
            ),
          ).animate().fadeIn(delay: 150.ms, duration: 350.ms),
          const SizedBox(height: 8),

          // News stats pill
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.bolt_rounded,
                    color: Colors.white, size: 13),
                SizedBox(width: 4),
                Text(
                  'LIVE · Bengali & English',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 250.ms, duration: 300.ms),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Section label
// ─────────────────────────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
          color: Theme.of(context)
              .colorScheme
              .onSurface
              .withValues(alpha: 0.4),
        ),
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
              ? _kAccent.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Active bar indicator
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 3,
              height: 22,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: isActive ? _kAccent : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Icon with tinted background when active
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isActive
                    ? _kAccent.withValues(alpha: 0.15)
                    : scheme.onSurface.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 18,
                color: isActive
                    ? _kAccent
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
                      ? _kAccent
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

// ─────────────────────────────────────────────────────────────────────────────
// Footer — social icons + version
// ─────────────────────────────────────────────────────────────────────────────
class _DrawerFooter extends StatelessWidget {
  const _DrawerFooter({required this.scheme});
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.of(context).padding.bottom + 16,
      ),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: scheme.onSurface.withValues(alpha: 0.08),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Social row
          Row(
            children: [
              _SocialButton(
                icon: Icons.facebook_rounded,
                onTap: () {},
              ),
              const SizedBox(width: 8),
              _SocialButton(
                icon: Icons.telegram,
                onTap: () {},
              ),
              const SizedBox(width: 8),
              _SocialButton(
                icon: Icons.ondemand_video_rounded,
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Version + name
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'TALKY News',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: scheme.onSurface.withValues(alpha: 0.5),
                  letterSpacing: 0.4,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: scheme.onSurface.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'v1.0.0',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: scheme.onSurface.withValues(alpha: 0.45),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: scheme.onSurface.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          size: 18,
          color: scheme.onSurface.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}
