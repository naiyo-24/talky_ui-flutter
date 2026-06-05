import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/router/app_router.dart';
import '../../../../features/settings/providers/theme_provider.dart';
import '../../../../core/storage/hive_service.dart';
import '../../../../shared/widgets/custom_appbar.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeProvider);
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        NavigationShellProvider.of(context).goBranch(0);
        return false;
      },
      child: Scaffold(
      appBar: const CustomAppBar(title: 'Settings'),
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
            trailing: Text('NewsAPI.org', style: textTheme.bodyMedium?.copyWith(
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

