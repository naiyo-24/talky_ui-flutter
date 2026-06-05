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
    Future.delayed(const Duration(milliseconds: 3000), () {
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
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset('assets/images/Splash.png', fit: BoxFit.cover)
              .animate()
              .fadeIn(duration: 800.ms)
              .scale(
                begin: const Offset(1.05, 1.05),
                end: const Offset(1.0, 1.0),
                duration: 3.seconds,
                curve: Curves.easeOut,
              ),

          // Logo at the top
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child:
                    Image.asset(
                          'assets/images/Logo_For_Dark_Mode.png',
                          width: 220,
                        )
                        .animate()
                        .fadeIn(delay: 400.ms, duration: 800.ms)
                        .slideY(
                          begin: -0.2,
                          end: 0,
                          duration: 800.ms,
                          curve: Curves.easeOutBack,
                        ),
              ),
            ),
          ),

          // Taglines at the bottom
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 50.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                          'বিশ্বস্ত খবর',
                          style: TextStyle(
                            color: Color(0xFFFF6D00),
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            height: 1.1,
                          ),
                        )
                        .animate()
                        .fadeIn(delay: 600.ms, duration: 600.ms)
                        .slideY(begin: 0.1, end: 0, curve: Curves.easeOut),
                    const Text(
                          'জনসংযোগ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            height: 1.1,
                          ),
                        )
                        .animate()
                        .fadeIn(delay: 800.ms, duration: 600.ms)
                        .slideY(begin: 0.1, end: 0, curve: Curves.easeOut),
                    const Text(
                          'সরাসরি মতামত',
                          style: TextStyle(
                            color: Color(0xFFFF6D00),
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            height: 1.1,
                          ),
                        )
                        .animate()
                        .fadeIn(delay: 1000.ms, duration: 600.ms)
                        .slideY(begin: 0.1, end: 0, curve: Curves.easeOut),
                    const SizedBox(height: 20),
                    const Text(
                      'আপনার এলাকা, আপনার খবর, আপনার সাথে',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                    ).animate().fadeIn(delay: 1300.ms, duration: 600.ms),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
