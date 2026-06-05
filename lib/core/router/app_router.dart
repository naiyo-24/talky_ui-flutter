import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/home/presentation/screens/category_screen.dart';
import '../../features/article/presentation/screens/article_detail_screen.dart';
import '../../features/videos/presentation/videos_screen.dart';
import '../../features/search/presentation/search_screen.dart';
import '../../features/bookmark/presentation/bookmark_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/language/presentation/language_screen.dart';
import '../../features/district/presentation/district_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/language',
        name: 'language',
        builder: (context, state) => const LanguageScreen(),
      ),
      GoRoute(
        path: '/district',
        name: 'district',
        builder: (context, state) => const DistrictScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithBottomNav(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                name: 'home',
                builder: (context, state) => const HomeScreen(),
              ),
              GoRoute(
                path: '/category/:id',
                name: 'category',
                builder: (context, state) {
                  final category = state.pathParameters['id'] ?? 'Top';
                  return CategoryScreen(category: category);
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/videos',
                name: 'videos',
                builder: (context, state) => const VideosScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/search',
                name: 'search',
                builder: (context, state) => const SearchScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/bookmarks',
                name: 'bookmarks',
                builder: (context, state) => const BookmarkScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                name: 'settings',
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/article/:id',
        name: 'article',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return ArticleDetailScreen(articleData: extra);
        },
      ),
    ],
  );
});

class ScaffoldWithBottomNav extends StatelessWidget {
  const ScaffoldWithBottomNav({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  static const _tabs = [
    (icon: Icons.home_rounded, label: 'Home'),
    (icon: Icons.play_circle_fill_rounded, label: 'Reels'),
    (icon: Icons.search_rounded, label: 'Search'),
    (icon: Icons.bookmark_rounded, label: 'Saved'),
    (icon: Icons.settings_rounded, label: 'Settings'),
  ];

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return NavigationShellProvider(
      shell: navigationShell,
      child: Scaffold(
        body: navigationShell,
        bottomNavigationBar: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: (i) => _onTap(context, i),
          backgroundColor: scheme.surface,
          elevation: 0,
          indicatorColor: scheme.primary.withValues(alpha: 0.15),
          destinations: _tabs
              .map(
                (t) => NavigationDestination(
                  icon: Icon(t.icon),
                  label: t.label,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class NavigationShellProvider extends InheritedWidget {
  final StatefulNavigationShell shell;
  const NavigationShellProvider({
    super.key,
    required this.shell,
    required super.child,
  });

  static StatefulNavigationShell of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<NavigationShellProvider>()!
        .shell;
  }

  @override
  bool updateShouldNotify(covariant NavigationShellProvider oldWidget) {
    return shell != oldWidget.shell;
  }
}
