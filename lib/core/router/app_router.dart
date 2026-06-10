import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/home/presentation/screens/category_screen.dart';
import '../../features/home/presentation/screens/all_categories_screen.dart';
import '../../features/article/presentation/screens/article_detail_screen.dart';
import '../../features/videos/presentation/videos_screen.dart';
import '../../features/search/presentation/search_screen.dart';
import '../../features/notifications/presentation/notifications_screen.dart';
import '../../features/community/presentation/community_screen.dart';
import '../../features/community/presentation/polls_screen.dart';
import '../../features/community/presentation/feedback_screen.dart';
import '../../features/community/presentation/local_issues_screen.dart';
import '../../features/community/presentation/events_screen.dart';
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
        path: '/notifications',
        name: 'notifications',
        builder: (context, state) => const NotificationsScreen(),
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
                path: '/categories',
                name: 'categories',
                builder: (context, state) => const AllCategoriesScreen(),
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
          /* StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/community',
                name: 'community',
                builder: (context, state) => const CommunityScreen(),
                routes: [
                  GoRoute(
                    path: 'polls',
                    name: 'polls',
                    builder: (context, state) => const PollsScreen(),
                  ),
                  GoRoute(
                    path: 'feedback',
                    name: 'feedback',
                    builder: (context, state) => const FeedbackScreen(),
                  ),
                  GoRoute(
                    path: 'issues',
                    name: 'issues',
                    builder: (context, state) => const LocalIssuesScreen(),
                  ),
                  GoRoute(
                    path: 'events',
                    name: 'events',
                    builder: (context, state) => const EventsScreen(),
                  ),
                ],
              ),
            ],
          ), */
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

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final loc = AppLocalizations.of(context)!;

    final tabs = [
      (icon: Icons.home_rounded, label: loc.home),
      (icon: Icons.play_circle_fill_rounded, label: 'Live'),
      (icon: Icons.search_rounded, label: loc.search),
      // (icon: Icons.people_alt_rounded, label: loc.community),
      (icon: Icons.settings_rounded, label: loc.settings),
    ];

    return NavigationShellProvider(
      shell: navigationShell,
      child: PopScope(
        // Always intercept the back gesture — we handle all cases manually.
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;

          // ── Priority 1: Pop within the current branch's navigator stack
          //    (e.g. Category → AllCategories → Home, or Article → back).
          final branchNavigator = navigationShell
              .shellRouteContext.navigatorKey.currentState;
          if (branchNavigator != null && branchNavigator.canPop()) {
            branchNavigator.pop();
            return;
          }

          // ── Priority 2: Not on Home tab → navigate to Home tab root.
          //    This covers: Videos, Search, Community, Settings → Home.
          if (navigationShell.currentIndex != 0) {
            navigationShell.goBranch(0, initialLocation: true);
            return;
          }

          // ── Priority 3: Already on Home tab root → confirm exit.
          final shouldExit = await showDialog<bool>(
            context: context,
            barrierDismissible: true,
            builder: (ctx) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text(
                'Exit App?',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              content: const Text(
                'Are you sure you want to close the app?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: const Text('Stay'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(true),
                  child: const Text(
                    'Exit',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          );

          if (shouldExit == true) {
            // Cleanly removes this Activity from the Android back stack
            // without killing the process — respects launchMode="singleTop".
            SystemNavigator.pop();
          }
        },
        child: Scaffold(
          body: navigationShell,
          bottomNavigationBar: NavigationBar(
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: (i) => _onTap(context, i),
            backgroundColor: scheme.surface,
            elevation: 0,
            indicatorColor: scheme.primary.withValues(alpha: 0.15),
            destinations: tabs
                .map(
                  (t) => NavigationDestination(
                    icon: Icon(t.icon),
                    label: t.label,
                  ),
                )
                .toList(),
          ),
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
    return shell.currentIndex != oldWidget.shell.currentIndex;
  }
}
