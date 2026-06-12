import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../shared/widgets/custom_appbar.dart';

class ProfessionalVerificationScreen extends ConsumerStatefulWidget {
  const ProfessionalVerificationScreen({super.key});

  @override
  ConsumerState<ProfessionalVerificationScreen> createState() => _ProfessionalVerificationScreenState();
}

class _ProfessionalVerificationScreenState extends ConsumerState<ProfessionalVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  
  String _selectedProfession = 'Police';
  final List<String> _professions = [
    'Police',
    'Lawyer',
    'Government Employee',
    'News Channel',
  ];

  // Controllers
  final _enrollmentController = TextEditingController();
  final _newsNameController = TextEditingController();
  final _cinController = TextEditingController();
  final _websiteController = TextEditingController();

  @override
  void dispose() {
    _enrollmentController.dispose();
    _newsNameController.dispose();
    _cinController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  void _verify() {
    if (_formKey.currentState?.validate() ?? false) {
      // Mock validation successful
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Verification Request Submitted!'),
          backgroundColor: Theme.of(context).colorScheme.primary,
          behavior: SnackBarBehavior.floating,
        ),
      );
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Professional Verification'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Text(
                  'Verify Your Identity',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: scheme.onSurface,
                  ),
                ).animate().fadeIn().slideY(begin: 0.2, end: 0),
                const SizedBox(height: 8),
                Text(
                  'Please select your profession and provide the required details to unlock the professional dashboard.',
                  style: TextStyle(
                    fontSize: 16,
                    color: scheme.onSurfaceVariant,
                  ),
                ).animate(delay: 100.ms).fadeIn().slideY(begin: 0.2, end: 0),
                const SizedBox(height: 32),

                // Profession Dropdown
                RichText(
                  text: TextSpan(
                    text: 'Profession',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: scheme.onSurface,
                      fontFamily: 'Inter',
                      fontSize: 14,
                    ),
                    children: [
                      TextSpan(text: ' *', style: TextStyle(color: scheme.error)),
                    ],
                  ),
                ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.2, end: 0),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: scheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: DropdownButtonFormField<String>(
                    value: _selectedProfession,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.work_outline_rounded, color: scheme.primary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: scheme.surface,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                    icon: Icon(Icons.keyboard_arrow_down_rounded, color: scheme.primary),
                    dropdownColor: scheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    items: _professions.map((prof) {
                      return DropdownMenuItem(
                        value: prof,
                        child: Text(prof, style: TextStyle(fontWeight: FontWeight.w500)),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _selectedProfession = val;
                        });
                      }
                    },
                  ),
                ).animate(delay: 250.ms).fadeIn().slideY(begin: 0.2, end: 0),
                const SizedBox(height: 24),

                // Dynamic Fields
                if (_selectedProfession == 'News Channel') ...[
                  // News Channel Fields
                  _buildTextField(
                    label: 'News Channel Name',
                    controller: _newsNameController,
                    icon: Icons.tv_rounded,
                    delay: 300,
                    isRequired: true,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    label: 'Company CIN Number',
                    controller: _cinController,
                    icon: Icons.numbers_rounded,
                    delay: 350,
                    isRequired: true,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    label: 'Company Website',
                    controller: _websiteController,
                    icon: Icons.language_rounded,
                    delay: 400,
                    isRequired: true,
                  ),
                ] else ...[
                  // Standard Field
                  _buildTextField(
                    label: 'Enrollment Number',
                    controller: _enrollmentController,
                    icon: Icons.badge_rounded,
                    delay: 300,
                    isRequired: true,
                  ),
                  const SizedBox(height: 16),
                  // Image Upload Field
                  _buildImageUploadField(
                    label: 'ID card provided by the government',
                    delay: 350,
                    isRequired: true,
                  ),
                ],

                const SizedBox(height: 48),

                // Verify Button
                FilledButton(
                  onPressed: _verify,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: scheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Verify',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ).animate(delay: 500.ms).fadeIn().slideY(begin: 0.2, end: 0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required int delay,
    bool isRequired = false,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: scheme.onSurface,
              fontFamily: 'Inter',
              fontSize: 14,
            ),
            children: [
              if (isRequired) TextSpan(text: ' *', style: TextStyle(color: scheme.error)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Enter $label',
            prefixIcon: Icon(icon, color: scheme.primary),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: scheme.outlineVariant),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: scheme.outlineVariant),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: scheme.primary, width: 2),
            ),
            filled: true,
            fillColor: scheme.surface,
          ),
          validator: (val) {
            if (isRequired && (val == null || val.trim().isEmpty)) {
              return 'This field is required';
            }
            return null;
          },
        ),
      ],
    ).animate(delay: delay.ms).fadeIn().slideY(begin: 0.2, end: 0);
  }

  Widget _buildImageUploadField({
    required String label,
    required int delay,
    bool isRequired = false,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: scheme.onSurface,
              fontFamily: 'Inter',
              fontSize: 14,
            ),
            children: [
              if (isRequired) TextSpan(text: ' *', style: TextStyle(color: scheme.error)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () {
            // TODO: Implement image picker
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Image Picker will be implemented here'),
                behavior: SnackBarBehavior.floating,
                backgroundColor: scheme.primary,
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 32),
            decoration: BoxDecoration(
              color: scheme.primaryContainer.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: scheme.primary.withValues(alpha: 0.3),
                width: 2,
                style: BorderStyle.solid,
              ),
            ),
            child: Column(
              children: [
                Icon(Icons.cloud_upload_rounded, size: 48, color: scheme.primary),
                const SizedBox(height: 12),
                Text(
                  'Tap to upload ID Card image',
                  style: TextStyle(
                    color: scheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ).animate(delay: delay.ms).fadeIn().slideY(begin: 0.2, end: 0);
  }
}
