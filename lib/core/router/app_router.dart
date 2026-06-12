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
import '../../features/language/presentation/language_screen.dart';
import '../../features/district/presentation/district_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/otp_screen.dart';
import '../../features/auth/presentation/professional_prompt_screen.dart';
import '../../features/auth/presentation/professional_verification_screen.dart';
import '../../features/auth/providers/auth_provider.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isAuthenticated = ref.read(authProvider);
      final isSplash = state.uri.path == '/splash';
      final isLogin = state.uri.path == '/login';
      final isOtp = state.uri.path == '/otp';
      final isProfessionalPrompt = state.uri.path == '/professional-prompt';
      
      // If the user is unauthenticated, they can only be on splash, login, or otp.
      if (!isAuthenticated && !isSplash && !isLogin && !isOtp) {
        return '/login';
      }

      // If the user is authenticated and trying to access the login page, redirect them to home.
      // Notice we do NOT redirect if they are on /otp or /professional-prompt because
      // the OtpScreen needs to manually push to /professional-prompt after verification.
      if (isAuthenticated && isLogin) {
        return '/home';
      }

      return null;
    },
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
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/otp',
        name: 'otp',
        builder: (context, state) => const OtpScreen(),
      ),
      GoRoute(
        path: '/professional-prompt',
        name: 'professional_prompt',
        builder: (context, state) => const ProfessionalPromptScreen(),
      ),
      GoRoute(
        path: '/professional-verification',
        name: 'professional_verification',
        builder: (context, state) => const ProfessionalVerificationScreen(),
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
                path: '/community',
                name: 'community',
                builder: (context, state) => const CommunityScreen(),
                // Sub-routes (polls, feedback, etc.) were removed as per user request
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                name: 'profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
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
      (icon: Icons.play_circle_fill_rounded, label: 'Tbite'),
      (icon: Icons.people_alt_rounded, label: loc.community),
      (icon: Icons.person_outline_rounded, label: 'Profile'),
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
          bottomNavigationBar: Container(
            color: scheme.surface,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom + 8,
              top: 8,
              left: 16,
              right: 16,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: tabs.asMap().entries.map((entry) {
                final i = entry.key;
                final t = entry.value;
                final isActive = i == navigationShell.currentIndex;
                return GestureDetector(
                  onTap: () => _onTap(context, i),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOutCubic,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isActive ? scheme.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
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
                            t.icon,
                            size: 18,
                            color: isActive
                                ? Colors.white
                                : scheme.onSurface.withValues(alpha: 0.65),
                          ),
                        ),
                        if (isActive) ...[
                          const SizedBox(width: 8),
                          Text(
                            t.label,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
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
