import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../features/settings/providers/theme_provider.dart';
import '../../../../core/storage/hive_service.dart';
import '../../../../shared/widgets/custom_appbar.dart';

import '../../../../l10n/app_localizations.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeProvider);
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final loc = AppLocalizations.of(context)!;

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
      appBar: CustomAppBar(title: loc.settings),
      body: ListView(
        children: [
          _SectionHeader(title: 'Appearance'),
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text('Switch between light and dark theme'),
            secondary: Icon(
              isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
              color: scheme.primary,
            ),
            value: isDark,
            onChanged: (_) => ref.read(themeProvider.notifier).toggle(),
            activeThumbColor: scheme.primary,
          ),
          ListTile(
            leading: Icon(Icons.language_rounded, color: scheme.primary),
            title: Text(loc.language),
            subtitle: Text('Current: ${HiveService.language == 'bn' ? "বাংলা" : "English"}'),
            onTap: () {
              context.push('/language');
            },
          ),
          ListTile(
            leading: Icon(Icons.location_on_rounded, color: scheme.primary),
            title: Text(loc.district),
            subtitle: Text('Current: ${HiveService.district.isNotEmpty ? HiveService.district : "None"}'),
            onTap: () {
              // We push so they can come back to settings.
              context.push('/district');
            },
          ),
          const Divider(),
          _SectionHeader(title: 'Data & Storage'),
          ListTile(
            leading: Icon(Icons.delete_sweep_outlined, color: scheme.error),
            title: const Text('Clear Offline Cache'),
            subtitle: const Text('Removes cached news data'),
            onTap: () async {
              await HiveService.clearCache();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Cache cleared successfully'),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                );
              }
            },
          ),
          const Divider(),
          _SectionHeader(title: 'About'),
          ListTile(
            leading: Icon(Icons.info_outline_rounded, color: scheme.primary),
            title: const Text('Version'),
            trailing: Text('1.0.0', style: textTheme.bodyMedium?.copyWith(
              color: scheme.onSurface.withValues(alpha: 0.5),
            )),
          ),
          ListTile(
            leading: Icon(Icons.newspaper_rounded, color: scheme.primary),
            title: const Text('Powered by'),
            trailing: Text('Naiyo24.org', style: textTheme.bodyMedium?.copyWith(
              color: scheme.onSurface.withValues(alpha: 0.5),
            )),
          ),
        ],
      ),
    ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

