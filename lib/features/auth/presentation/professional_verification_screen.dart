import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../shared/widgets/custom_appbar.dart';
import '../../../../core/storage/hive_service.dart';

class ProfessionalVerificationScreen extends ConsumerStatefulWidget {
  const ProfessionalVerificationScreen({super.key});

  @override
  ConsumerState<ProfessionalVerificationScreen> createState() => _ProfessionalVerificationScreenState();
}

class _ProfessionalVerificationScreenState extends ConsumerState<ProfessionalVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  
  File? _idImage;
  final ImagePicker _picker = ImagePicker();
  
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
      if (_selectedProfession != 'News Channel' && _idImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Please upload your ID Card image'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }
      
      // Save pending verification status
      HiveService.setVerificationStatus('pending');
      HiveService.setUserProfession(_selectedProfession!);

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

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        final scheme = Theme.of(context).colorScheme;
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library_rounded, color: scheme.primary),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt_rounded, color: scheme.primary),
                title: const Text('Take a Photo'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80, // Compress to save size
      );
      
      if (pickedFile != null) {
        final file = File(pickedFile.path);
        int sizeInBytes = file.lengthSync();
        double sizeInKb = sizeInBytes / 1024;
        
        if (sizeInKb > 100) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Image size exceeds 100 KB. Please select a smaller image.'),
                backgroundColor: Theme.of(context).colorScheme.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        } else {
          setState(() {
            _idImage = file;
          });
        }
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
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
          onTap: () => _showImageSourceActionSheet(context),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: _idImage != null ? 8 : 32, horizontal: 8),
            decoration: BoxDecoration(
              color: scheme.primaryContainer.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _idImage != null ? scheme.primary : scheme.primary.withValues(alpha: 0.3),
                width: 2,
                style: BorderStyle.solid,
              ),
            ),
            child: _idImage != null 
                ? Stack(
                    alignment: Alignment.topRight,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          _idImage!,
                          width: double.infinity,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.edit_rounded, color: Colors.white, size: 20),
                          onPressed: () => _showImageSourceActionSheet(context),
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.all(8),
                        ),
                      ),
                    ],
                  )
                : Column(
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
                      const SizedBox(height: 8),
                      Text(
                        'Max size: 100 KB\\nSupported formats: JPG, PNG, JPEG',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: scheme.onSurfaceVariant.withValues(alpha: 0.7),
                          fontSize: 12,
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
