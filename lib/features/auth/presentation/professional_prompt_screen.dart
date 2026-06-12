import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../features/settings/providers/theme_provider.dart';

class ProfessionalPromptScreen extends ConsumerWidget {
  const ProfessionalPromptScreen({super.key});

  void _showEligibilityDialog(BuildContext context, ColorScheme scheme) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'Eligibility Criteria',
            style: TextStyle(color: scheme.onSurface, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'The Professional Dashboard is strictly for the following sectors:',
                style: TextStyle(color: scheme.onSurfaceVariant),
              ),
              const SizedBox(height: 16),
              _buildEligibilityItem(Icons.local_police_rounded, 'Police', scheme),
              const SizedBox(height: 8),
              _buildEligibilityItem(Icons.gavel_rounded, 'Lawyer', scheme),
              const SizedBox(height: 8),
              _buildEligibilityItem(Icons.tv_rounded, 'News Channel', scheme),
              const SizedBox(height: 8),
              _buildEligibilityItem(Icons.account_balance_rounded, 'Government Employee', scheme),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                context.go('/home'); // Go to home instead of just closing dialog
              },
              child: Text('Back to Home', style: TextStyle(color: scheme.onSurfaceVariant)),
            ),
            FilledButton(
              onPressed: () {
                context.pop(); // Close dialog
                context.push('/professional-verification'); // Go to verification
              },
              style: FilledButton.styleFrom(
                backgroundColor: scheme.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Proceed', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEligibilityItem(IconData icon, String label, ColorScheme scheme) {
    return Row(
      children: [
        Icon(icon, size: 20, color: scheme.primary),
        const SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(color: scheme.onSurface, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String subtitle, ColorScheme scheme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: scheme.primaryContainer.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: scheme.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: scheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Badge Icon
              Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: scheme.primaryContainer.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.verified_rounded,
                    size: 64,
                    color: scheme.primary,
                  ),
                ),
              ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack),

              const SizedBox(height: 32),

              // Title
              Center(
                child: Text(
                  'Are you a Professional?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: scheme.onSurface,
                  ),
                ),
              ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.2, end: 0),

              const SizedBox(height: 12),

              // Subtitle
              Center(
                child: Text(
                  'Apply for the Professional Dashboard to unlock advanced features.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ).animate(delay: 300.ms).fadeIn().slideY(begin: 0.2, end: 0),

              const SizedBox(height: 40),

              // Features Checklist
              Expanded(
                child: ListView(
                  children: [
                    _buildFeatureItem(
                      Icons.post_add_rounded,
                      'Create Community Posts',
                      'Create posts which will show in the community section',
                      scheme,
                    ),
                    _buildFeatureItem(
                      Icons.dashboard_customize_rounded,
                      'Professional Dashboard',
                      'Manage your posts and analytics',
                      scheme,
                    ),
                    _buildFeatureItem(
                      Icons.verified_user_rounded,
                      'Verification Badge',
                      'Get a verified badge on your profile',
                      scheme,
                    ),
                    _buildFeatureItem(
                      Icons.support_agent_rounded,
                      'Priority Support',
                      'Get priority review & support',
                      scheme,
                    ),
                  ],
                ),
              ).animate(delay: 500.ms).fadeIn().slideY(begin: 0.2, end: 0),

              const SizedBox(height: 16),

              // Buttons
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FilledButton(
                    onPressed: () => _showEligibilityDialog(context, scheme),
                    style: FilledButton.styleFrom(
                      backgroundColor: scheme.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Apply',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      context.go('/home');
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ).animate(delay: 800.ms).fadeIn().slideY(begin: 0.2, end: 0),
            ],
          ),
        ),
      ),
    );
  }
}
