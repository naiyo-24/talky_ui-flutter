import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pinput/pinput.dart';
import '../../../features/settings/providers/theme_provider.dart';
import '../providers/auth_provider.dart';

class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final _pinController = TextEditingController();

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(themeProvider);
    final scheme = Theme.of(context).colorScheme;
    
    // Logo Selection based on theme
    final logoPath = isDark 
        ? 'assets/images/Logo_For_Dark_Mode.png' 
        : 'assets/images/Logo_Without_BG.png';

    // Pinput Theme
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: TextStyle(
        fontSize: 22,
        color: scheme.onSurface,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border.all(color: scheme.outline.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(12),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: scheme.primary, width: 2),
      borderRadius: BorderRadius.circular(12),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: scheme.primaryContainer.withValues(alpha: 0.2),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: scheme.onSurface),
          onPressed: () => context.pop(),
        ),
      ),
      extendBodyBehindAppBar: true,
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
                ],
              ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2, end: 0, curve: Curves.easeOutCubic),
              
              const Spacer(),
              
              // --- OTP INPUT AREA ---
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Text(
                      'Verification Code',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: scheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      'Please enter the 4-digit code\nsent to your mobile number',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: scheme.onSurfaceVariant,
                        height: 1.4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // 4-Digit Pinput Field
                  Center(
                    child: Pinput(
                      length: 4,
                      controller: _pinController,
                      defaultPinTheme: defaultPinTheme,
                      focusedPinTheme: focusedPinTheme,
                      submittedPinTheme: submittedPinTheme,
                      showCursor: true,
                      onCompleted: (pin) {
                        // Optional: Auto-verify when 4 digits are entered
                      },
                    ),
                  ),
                ],
              ).animate(delay: 300.ms).fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0, curve: Curves.easeOutCubic),
              
              const SizedBox(height: 32),
              
              // Verify Button
              FilledButton(
                onPressed: () async {
                  // If OTP is entered (simulation)
                  if (_pinController.text.length == 4) {
                    await ref.read(authProvider.notifier).login();
                    if (context.mounted) {
                      context.go('/professional-prompt');
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a valid 4-digit OTP')),
                    );
                  }
                },
                style: FilledButton.styleFrom(
                  backgroundColor: scheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Verify OTP',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ).animate(delay: 600.ms).fadeIn(duration: 500.ms).scale(begin: const Offset(0.9, 0.9), curve: Curves.easeOutBack),
              
              const SizedBox(height: 24),
              
              // --- RESEND FOOTER ---
              Center(
                child: RichText(
                  text: TextSpan(
                    text: "Didn't receive the OTP? ",
                    style: TextStyle(
                      color: scheme.onSurfaceVariant,
                      fontSize: 14,
                    ),
                    children: [
                      TextSpan(
                        text: 'Resend in 30s',
                        style: TextStyle(
                          color: scheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ).animate(delay: 900.ms).fadeIn(duration: 500.ms),
              
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
