import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/language_provider.dart';

class LanguageScreen extends ConsumerWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        backgroundColor: scheme.surface,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 1),
              Icon(Icons.language_rounded, size: 80, color: scheme.primary)
                  .animate().scale(delay: 200.ms, duration: 400.ms, curve: Curves.easeOutBack),
              const SizedBox(height: 32),
              Text(
                'Choose Your Language\nভাষা নির্বাচন করুন',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  height: 1.3,
                ),
              ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),
              const SizedBox(height: 12),
              Text(
                'You can always change this later in settings.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: scheme.onSurface.withValues(alpha: 0.6),
                ),
              ).animate().fadeIn(delay: 500.ms),
              const Spacer(flex: 1),
              _LanguageCard(
                title: 'English',
                subtitle: 'Select English',
                icon: '🇺🇸',
                delay: 600,
                onTap: () {
                  ref.read(languageProvider.notifier).setLanguage('en');
                  if (context.mounted) {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.push('/district');
                    }
                  }
                },
              ),
              const SizedBox(height: 16),
              _LanguageCard(
                title: 'বাংলা',
                subtitle: 'Bengali নির্বাচন করুন',
                icon: '🇮🇳',
                delay: 700,
                onTap: () {
                  ref.read(languageProvider.notifier).setLanguage('bn');
                  if (context.mounted) {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.push('/district');
                    }
                  }
                },
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String icon;
  final int delay;
  final VoidCallback onTap;

  const _LanguageCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.delay,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.5)),
        ),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 32)),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 14, color: scheme.onSurface.withValues(alpha: 0.6)),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, size: 18, color: scheme.primary),
          ],
        ),
      ),
    ).animate().fadeIn(delay: delay.ms).slideX(begin: 0.1);
  }
}
