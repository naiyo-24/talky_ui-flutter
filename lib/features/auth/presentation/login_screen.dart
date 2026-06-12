import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../features/settings/providers/theme_provider.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeProvider);
    final scheme = Theme.of(context).colorScheme;
    
    // Logo Selection based on theme
    final logoPath = isDark 
        ? 'assets/images/Logo_For_Dark_Mode.png' 
        : 'assets/images/Logo_Without_BG.png';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false, // Prevents default back button if any
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              // --- LOGO AREA ---
              Column(
                children: [
                  Center(
                    child: Image.asset(
                      logoPath,
                      width: 200,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      'STAY AHEAD OF THE CURVE',
                      style: TextStyle(
                        fontSize: 12,
                        color: scheme.primary.withValues(alpha: 0.8),
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                ],
              ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2, end: 0, curve: Curves.easeOutCubic),
              
              const Spacer(),
              
              // --- INPUT AREA ---
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Text(
                      'Enter your mobile number\nto continue',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: scheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Phone Input Field
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: scheme.outline.withValues(alpha: 0.5)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        // Prefix Container
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                          child: Row(
                            children: [
                              Text(
                                '+91',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: scheme.onSurface,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(Icons.keyboard_arrow_down_rounded, size: 20, color: scheme.onSurfaceVariant),
                            ],
                          ),
                        ),
                        
                        // Vertical Divider
                        Container(
                          height: 24,
                          width: 1,
                          color: scheme.outline.withValues(alpha: 0.5),
                        ),
                        
                        // Text Field
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.phone,
                            style: TextStyle(fontSize: 16, color: scheme.onSurface),
                            decoration: InputDecoration(
                              hintText: 'Mobile number',
                              hintStyle: TextStyle(color: scheme.onSurfaceVariant.withValues(alpha: 0.5)),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ).animate(delay: 300.ms).fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0, curve: Curves.easeOutCubic),
              
              const SizedBox(height: 24),
              
              // Get OTP Button
              Consumer(
                builder: (context, ref, child) {
                  return FilledButton(
                    onPressed: () {
                      context.push('/otp');
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: scheme.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Get OTP',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  );
                }
              ).animate(delay: 600.ms).fadeIn(duration: 500.ms).scale(begin: const Offset(0.9, 0.9), curve: Curves.easeOutBack),
              
              const Spacer(),
              
              // --- FOOTER ---
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.privacy_tip_outlined, size: 16, color: scheme.onSurfaceVariant),
                  const SizedBox(width: 6),
                  Text(
                    'We respect your privacy',
                    style: TextStyle(
                      fontSize: 12,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ).animate(delay: 900.ms).fadeIn(duration: 500.ms),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
