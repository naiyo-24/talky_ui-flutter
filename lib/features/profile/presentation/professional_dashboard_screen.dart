import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/custom_appbar.dart';
import '../../community/providers/community_provider.dart';
import '../../../../core/storage/hive_service.dart';

class ProfessionalDashboardScreen extends ConsumerWidget {
  const ProfessionalDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final allPosts = ref.watch(communityProvider);
    
    // Filter to only show my professional posts
    final String profession = HiveService.userProfession.isNotEmpty ? HiveService.userProfession : 'Verified Profession';
    final myPosts = allPosts.where((post) => post['author'] == profession).toList();

    return Scaffold(
      appBar: const CustomAppBar(title: 'Professional Dashboard'),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/create-professional-post'),
        backgroundColor: scheme.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Create Post'),
      ),
      body: myPosts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.post_add_rounded, size: 64, color: scheme.primary.withValues(alpha: 0.3)),
                  const SizedBox(height: 16),
                  Text(
                    'No posts yet',
                    style: TextStyle(fontSize: 18, color: scheme.onSurfaceVariant, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the button below to create your first post.',
                    style: TextStyle(color: scheme.onSurfaceVariant),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: myPosts.length,
              itemBuilder: (context, index) {
                final post = myPosts[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              post['time'] ?? '',
                              style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 12),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
                              onPressed: () {
                                ref.read(communityProvider.notifier).deletePost(post['id']);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Post deleted')),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (post['headline'] != null && post['headline'].toString().isNotEmpty) ...[
                          Text(
                            post['headline'],
                            style: TextStyle(color: scheme.onSurface, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                        ],
                        Text(
                          post['content'] ?? '',
                          style: TextStyle(color: scheme.onSurface, fontSize: 14),
                        ),
                        if (post['imagePath'] != null) ...[
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              File(post['imagePath']),
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(Icons.visibility_outlined, size: 16, color: scheme.primary),
                            const SizedBox(width: 4),
                            Text(post['views'] ?? '', style: TextStyle(color: scheme.primary, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
