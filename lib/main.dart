import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/dark_theme.dart';
import 'core/storage/hive_service.dart';
import 'core/storage/shared_pref_service.dart';
import 'features/settings/providers/theme_provider.dart';
import 'features/language/providers/language_provider.dart';

// The locale is read from HiveService

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefService.init();
  await HiveService.init();
  runApp(
    const ProviderScope(
      child: NewsApp(),
    ),
  );
}

class NewsApp extends ConsumerWidget {
  const NewsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeProvider);
    final router = ref.watch(appRouterProvider);
    final localeString = ref.watch(languageProvider);

    return MaterialApp.router(
      title: 'NewsApp',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: DarkTheme.darkTheme,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      routerConfig: router,
      locale: Locale(localeString),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('bn'),
      ],
    );
  }
}
