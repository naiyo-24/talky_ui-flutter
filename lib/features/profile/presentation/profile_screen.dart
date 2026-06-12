import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../features/settings/providers/theme_provider.dart';
import '../../../../core/storage/hive_service.dart';
import '../../../../shared/widgets/custom_appbar.dart';
import '../../../../l10n/app_localizations.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

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
        // Assuming Profile is on a different branch or we want to go home
        // Typically branch 0 is Home
        NavigationShellProvider.of(context).goBranch(0);
      },
      child: Scaffold(
        appBar: const CustomAppBar(title: 'Profile'),
        body: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            // 1. Authentication / Login Placeholder
            _buildLoginPlaceholder(context),
            
            const SizedBox(height: 8),

            // 2. Appearance Section
            const _SectionHeader(title: 'Appearance'),
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
            
            // 3. Preferences Section
            const _SectionHeader(title: 'Preferences'),
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
              title: const Text('Location'),
              subtitle: Text('Current: ${HiveService.district.isNotEmpty ? HiveService.district : "West Bengal"}'),
              onTap: () {
                context.push('/district');
              },
            ),
            
            const SizedBox(height: 8),
            // 4. Data & Storage
            const _SectionHeader(title: 'Data & Storage'),
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
            
            const SizedBox(height: 8),
            // 5. About Section
            const _SectionHeader(title: 'About'),
            ListTile(
              leading: Icon(Icons.newspaper_rounded, color: scheme.primary),
              title: const Text('Powered by'),
              trailing: Text('Naiyo24 Pvt. Ltd', style: textTheme.bodyMedium?.copyWith(
                color: scheme.onSurface.withValues(alpha: 0.5),
              )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginPlaceholder(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        decoration: BoxDecoration(
          color: scheme.primaryContainer.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: scheme.primary.withValues(alpha: 0.3),
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: scheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.login_rounded, size: 24, color: scheme.primary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Login Architecture',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: scheme.primary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Placeholder for auth code',
                    style: TextStyle(
                      fontSize: 13,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, size: 16, color: scheme.primary.withValues(alpha: 0.5)),
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
      padding: const EdgeInsets.fromLTRB(56, 16, 16, 4), // Align with ListTile text (16 + 40 icon width)
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
