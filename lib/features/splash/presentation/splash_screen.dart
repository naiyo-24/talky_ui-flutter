import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/storage/hive_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        if (HiveService.isFirstLaunch) {
          context.go('/language');
        } else {
          context.go('/home');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/images/Logo_Without_BG.png',
          width: 280,
        )
            .animate()
            // 1. Smooth fade in
            .fadeIn(duration: 400.ms, curve: Curves.easeOut)
            // 2. Bouncy elastic pop-in effect
            .scale(
              begin: const Offset(0.4, 0.4),
              end: const Offset(1.0, 1.0),
              curve: Curves.elasticOut,
              duration: 900.ms,
            )
            // 3. Add a nice shiny shimmer sweep across the logo
            .shimmer(
              delay: 400.ms,
              duration: 1000.ms,
              color: Colors.grey.withOpacity(0.3),
            )
            // 4. Subtle continuous float/pulse until the screen transitions
            .then(delay: 100.ms)
            .slideY(
              begin: 0,
              end: -0.02,
              duration: 800.ms,
              curve: Curves.easeInOutSine,
            )
            .animate(onPlay: (controller) => controller.repeat(reverse: true)),
      ),
    );
  }
}
