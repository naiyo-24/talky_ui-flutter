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
            // Professional Section (Dynamic)
            _buildProfessionalSection(context, scheme),
            
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

  Widget _buildProfessionalSection(BuildContext context, ColorScheme scheme) {
    final status = HiveService.verificationStatus;
    
    // Normal User - skip rendering
    if (status == 'none') {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (status == 'pending') ...[
          // Pending Approval Banner
          Container(
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.orange.withValues(alpha: 0.3), width: 1.5),
            ),
            child: Row(
              children: [
                const Icon(Icons.pending_actions_rounded, color: Colors.orange, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Verification Pending',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Your professional verification request is currently under review.',
                        style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],

        // Professional Dashboard Card (Shown for both pending and approved)
        Container(
          margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [scheme.primary, scheme.primary.withValues(alpha: 0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: scheme.primary.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.dashboard_customize_rounded, color: Colors.white, size: 24),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Professional',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 10),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Professional Dashboard',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                'Upload news, manage posts, and view analytics',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12),
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: () {
                  if (status == 'pending') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Dashboard will be unlocked after approval.'),
                        backgroundColor: Colors.orange,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  } else {
                    // Navigate to dashboard
                    // context.push('/professional-dashboard');
                  }
                },
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: scheme.primary,
                  minimumSize: const Size(double.infinity, 40),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                label: const Text('Access Dashboard', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              ),
            ],
          ),
        ),
      ],
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
