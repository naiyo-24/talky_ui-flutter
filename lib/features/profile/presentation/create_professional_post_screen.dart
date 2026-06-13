import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import '../../../../shared/widgets/custom_appbar.dart';
import '../../community/providers/community_provider.dart';
import '../../../../core/storage/hive_service.dart';
import '../../../../shared/widgets/video_player_widget.dart';

class CreateProfessionalPostScreen extends ConsumerStatefulWidget {
  const CreateProfessionalPostScreen({super.key});

  @override
  ConsumerState<CreateProfessionalPostScreen> createState() => _CreateProfessionalPostScreenState();
}

class _CreateProfessionalPostScreenState extends ConsumerState<CreateProfessionalPostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _headlineController = TextEditingController();
  final _contentController = TextEditingController();
  File? _selectedMedia;
  bool _isVideo = false;

  Future<void> _pickMedia(ImageSource source, {bool isVideo = false}) async {
    final picker = ImagePicker();
    XFile? pickedFile;
    
    if (isVideo) {
      pickedFile = await picker.pickVideo(
        source: source,
        maxDuration: source == ImageSource.camera ? const Duration(seconds: 60) : null,
      );
    } else {
      pickedFile = await picker.pickImage(source: source);
    }

    if (pickedFile != null) {
      if (isVideo) {
        setState(() {
          _selectedMedia = File(pickedFile!.path);
          _isVideo = true;
        });
      } else {
        final croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedFile.path,
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Crop & Align Image',
              toolbarColor: Theme.of(context).colorScheme.primary,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false,
            ),
            IOSUiSettings(
              title: 'Crop & Align Image',
            ),
          ],
        );

        if (croppedFile != null) {
          setState(() {
            _selectedMedia = File(croppedFile.path);
            _isVideo = false;
          });
        }
      }
    }
  }

  void _showMediaSourceBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_rounded),
              title: const Text('Choose Image from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickMedia(ImageSource.gallery, isVideo: false);
              },
            ),
            ListTile(
              leading: const Icon(Icons.video_library_rounded),
              title: const Text('Choose Video from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickMedia(ImageSource.gallery, isVideo: true);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_rounded),
              title: const Text('Take a Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickMedia(ImageSource.camera, isVideo: false);
              },
            ),
            ListTile(
              leading: const Icon(Icons.videocam_rounded),
              title: const Text('Record a Video (Max 60s)'),
              onTap: () {
                Navigator.pop(context);
                _pickMedia(ImageSource.camera, isVideo: true);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _headlineController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _submitPost() {
    if (_formKey.currentState?.validate() ?? false) {
      final String profession = HiveService.userProfession.isNotEmpty ? HiveService.userProfession : 'Verified Profession';
      final newPost = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'author': profession,
        'designation': profession,
        'headline': _headlineController.text,
        'content': _contentController.text,
        'imagePath': !_isVideo ? _selectedMedia?.path : null,
        'videoPath': _isVideo ? _selectedMedia?.path : null,
        'time': 'Just now',
        'views': '0 views',
      };

      ref.read(communityProvider.notifier).addPost(newPost);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Post submitted successfully!'),
          backgroundColor: Theme.of(context).colorScheme.primary,
          behavior: SnackBarBehavior.floating,
        ),
      );

      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Create Post'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Media Upload
              GestureDetector(
                onTap: _showMediaSourceBottomSheet,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerHighest.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: scheme.outlineVariant),
                    image: _selectedMedia != null && !_isVideo
                        ? DecorationImage(
                            image: FileImage(_selectedMedia!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: _selectedMedia == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.perm_media_rounded, size: 40, color: scheme.primary),
                            const SizedBox(height: 8),
                            Text(
                              'Tap to upload Image or Video',
                              style: TextStyle(color: scheme.onSurfaceVariant, fontWeight: FontWeight.w500),
                            ),
                          ],
                        )
                      : Stack(
                          children: [
                            if (_isVideo)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: VideoPlayerWidget(videoPath: _selectedMedia!.path),
                              ),
                            Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  backgroundColor: Colors.black54,
                                  child: IconButton(
                                    icon: const Icon(Icons.close, color: Colors.white, size: 18),
                                    onPressed: () => setState(() {
                                      _selectedMedia = null;
                                      _isVideo = false;
                                    }),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 24),

              Text('Headline', style: TextStyle(fontWeight: FontWeight.w600, color: scheme.onSurface)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _headlineController,
                decoration: InputDecoration(
                  hintText: 'Enter attractive headline',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              Text('Content', style: TextStyle(fontWeight: FontWeight.w600, color: scheme.onSurface)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _contentController,
                maxLines: 6,
                decoration: InputDecoration(
                  hintText: 'Write your news content here...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 32),

              FilledButton(
                onPressed: _submitPost,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: scheme.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Post to Community', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
