import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../features/settings/providers/theme_provider.dart';
import '../../../../core/storage/hive_service.dart';
import '../../../../shared/widgets/custom_appbar.dart';
import '../../../../l10n/app_localizations.dart';
import '../../auth/providers/auth_provider.dart';

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


            // 2. Appearance Section
            const _SectionHeader(title: 'Appearance'),
            SwitchListTile(
              title: const Text('Dark Mode'),
              subtitle: const Text('Switch between light and dark theme'),
              secondary: _ProfileIcon(
                icon: isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
              ),
              value: isDark,
              onChanged: (_) => ref.read(themeProvider.notifier).toggle(),
              activeThumbColor: scheme.primary,
            ),
            
            // 3. Preferences Section
            const _SectionHeader(title: 'Preferences'),
            ListTile(
              leading: const _ProfileIcon(icon: Icons.language_rounded),
              title: Text(loc.language),
              subtitle: Text('Current: ${HiveService.language == 'bn' ? "বাংলা" : "English"}'),
              onTap: () {
                context.push('/language');
              },
            ),
            ListTile(
              leading: const _ProfileIcon(icon: Icons.location_on_rounded),
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
              leading: const _ProfileIcon(icon: Icons.delete_sweep_outlined, isError: false, isSolid: true),
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
            
            // Logout Button
            ListTile(
              leading: const _ProfileIcon(icon: Icons.logout_rounded, isSolid: true),
              title: Text('Logout', style: TextStyle(color: scheme.primary, fontWeight: FontWeight.w600)),
              onTap: () async {
                await ref.read(authProvider.notifier).logout();
                if (context.mounted) {
                  context.go('/login');
                }
              },
            ),
            
            const SizedBox(height: 8),
            // 5. About Section
            const _SectionHeader(title: 'About'),
            ListTile(
              leading: const _ProfileIcon(icon: Icons.newspaper_rounded),
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

class _ProfileIcon extends StatelessWidget {
  const _ProfileIcon({required this.icon, this.isError = false, this.isSolid = false});
  final IconData icon;
  final bool isError;
  final bool isSolid;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    
    if (isSolid) {
      return Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isError ? scheme.error : scheme.primary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 18, color: Colors.white),
      );
    }

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: isError 
            ? scheme.error.withValues(alpha: 0.1) 
            : scheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        icon, 
        size: 18, 
        color: isError 
            ? scheme.error 
            : scheme.primary,
      ),
    );
  }
}
