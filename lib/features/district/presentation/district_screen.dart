import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/storage/hive_service.dart';
import '../../../core/constants/app_constants.dart';

class DistrictScreen extends StatefulWidget {
  const DistrictScreen({super.key});

  @override
  State<DistrictScreen> createState() => _DistrictScreenState();
}

class _DistrictScreenState extends State<DistrictScreen> {
  @override
  void initState() {
    super.initState();
    _autoFetchLocation();
  }

  Future<void> _autoFetchLocation() async {
    // Simulate a brief delay to show the fetching animation
    await Future.delayed(const Duration(seconds: 2));
    
    final wasFirstLaunch = HiveService.isFirstLaunch;
    
    // Auto-set to West Bengal as requested
    await HiveService.setDistrict("West Bengal");
    await HiveService.setFirstLaunch(false);
    
    if (mounted) {
      if (wasFirstLaunch) {
        context.go('/home');
      } else if (context.canPop()) {
        context.pop();
      } else {
        context.go('/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_on_rounded, size: 60, color: scheme.primary)
                .animate(onPlay: (controller) => controller.repeat(reverse: true))
                .scale(begin: const Offset(0.9, 0.9), end: const Offset(1.1, 1.1), duration: 800.ms),
            const SizedBox(height: 24),
            Text(
              'Fetching Location...',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ).animate().fadeIn(delay: 200.ms),
          ],
        ),
      ),
    );
  }
}

/* 
// FUTURE CONCEPT: Manual district selection
class OldDistrictScreen extends StatelessWidget {
  const OldDistrictScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        title: const Text('Select District'),
        centerTitle: true,
        backgroundColor: scheme.surface,
        elevation: 0,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Icon(Icons.location_on_rounded, size: 60, color: scheme.primary)
                      .animate().scale(delay: 200.ms, duration: 400.ms, curve: Curves.easeOutBack),
                  const SizedBox(height: 20),
                  Text(
                    'Where are you located?',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),
                  const SizedBox(height: 8),
                  Text(
                    'Get local news tailored to your district.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: scheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ).animate().fadeIn(delay: 500.ms),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2.5,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final district = AppConstants.districts[index];
                  return GestureDetector(
                    onTap: () async {
                      final wasFirstLaunch = HiveService.isFirstLaunch;
                      await HiveService.setDistrict(district);
                      await HiveService.setFirstLaunch(false);
                      if (context.mounted) {
                        if (wasFirstLaunch) {
                          context.go('/home');
                        } else if (context.canPop()) {
                          context.pop();
                        } else {
                          context.go('/home');
                        }
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: scheme.surfaceContainerHighest.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.5)),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        district,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                      ),
                    ),
                  ).animate().fadeIn(delay: (600 + ((index % 10) * 50)).ms).slideY(begin: 0.1);
                },
                childCount: AppConstants.districts.length,
              ),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 40)),
        ],
      ),
    );
  }
}
*/
