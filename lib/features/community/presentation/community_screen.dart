import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/router/app_router.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/router/app_router.dart';
import 'community_post_detail_screen.dart';
import '../providers/community_provider.dart';
import '../../../../shared/widgets/video_player_widget.dart';

// The exact red color from your drawer to maintain the red/white theme
const _kAppRed = Color(0xFFE53935);

class CommunityScreen extends ConsumerWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (context.canPop()) {
          context.pop();
          return;
        }
        NavigationShellProvider.of(context).goBranch(0);
      },
      child: const Scaffold(
        body: _CommunityFeed(),
      ),
    );
  }
}

class _CommunityFeed extends ConsumerStatefulWidget {
  const _CommunityFeed();

  @override
  ConsumerState<_CommunityFeed> createState() => _CommunityFeedState();
}

class _CommunityFeedState extends ConsumerState<_CommunityFeed> {
  String _selectedFilter = 'All';

  final List<String> _filters = [
    'All',
    'Police',
    'Lawyer',
    'News Channel',
    'Government Employee'
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final loc = AppLocalizations.of(context)!;
    
    final posts = ref.watch(communityProvider);

    final filteredPosts = _selectedFilter == 'All'
        ? posts
        : posts.where((p) => p['designation'] == _selectedFilter).toList();

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () {
              NavigationShellProvider.of(context).goBranch(0);
            },
          ),
          title: Text(
            loc.community,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          floating: true,
          pinned: true,
          backgroundColor: scheme.surface,
          surfaceTintColor: scheme.surfaceTint,
          elevation: 2,
          shadowColor: scheme.shadow.withValues(alpha: 0.2),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Container(
              height: 60,
              alignment: Alignment.centerLeft,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: _filters.length,
                itemBuilder: (context, index) {
                  final filter = _filters[index];
                  final isSelected = filter == _selectedFilter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: FilterChip(
                      label: Text(filter),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedFilter = filter;
                        });
                      },
                      // Force the red color theme for chips
                      selectedColor: _kAppRed.withValues(alpha: 0.15),
                      checkmarkColor: _kAppRed,
                      labelStyle: TextStyle(
                        color: isSelected ? _kAppRed : scheme.onSurface,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected ? _kAppRed : scheme.outlineVariant,
                        ),
                      ),
                    ),
                  ).animate().fadeIn(delay: (index * 50).ms).scale();
                },
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: filteredPosts.isEmpty
              ? SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Text(
                        'No official notices found.',
                        style: TextStyle(color: scheme.onSurfaceVariant),
                      ),
                    ),
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final post = filteredPosts[index];
                      return _OfficialPostCard(post: post)
                          .animate()
                          .fadeIn(delay: (index * 100).ms)
                          .slideY(begin: 0.1);
                    },
                    childCount: filteredPosts.length,
                  ),
                ),
        ),
      ],
    );
  }
}

class _OfficialPostCard extends StatelessWidget {
  final Map<String, dynamic> post;

  const _OfficialPostCard({required this.post});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shadowColor: scheme.shadow.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      clipBehavior: Clip.antiAlias, // Important for InkWell ripple
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CommunityPostDetailScreen(post: post),
            ),
          );
        },
        splashColor: _kAppRed.withValues(alpha: 0.1),
        highlightColor: _kAppRed.withValues(alpha: 0.05),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _kAppRed.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.account_balance_rounded, color: _kAppRed),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                post['author']!,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.verified, size: 18, color: _kAppRed),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${post['designation']} • ${post['time']}',
                          style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 16),
              if (post['headline'] != null && post['headline'].toString().isNotEmpty) ...[
                Text(
                  post['headline'],
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
              ],
              Text(
                post['content']!,
                style: const TextStyle(fontSize: 15, height: 1.5),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
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
              if (post['videoPath'] != null) ...[
                const SizedBox(height: 12),
                VideoPlayerWidget(videoPath: post['videoPath']),
              ],
              
              // Simulate Attachment preview if it has one
              if (post['attachmentType'] != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerHighest.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: scheme.outlineVariant),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        post['attachmentType'] == 'pdf' ? Icons.picture_as_pdf_rounded : Icons.map_rounded,
                        size: 18,
                        color: _kAppRed,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          post['attachmentName']!,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.visibility_rounded, size: 16, color: scheme.onSurfaceVariant),
                      const SizedBox(width: 6),
                      Text(
                        post['views'] ?? '1.2k views',
                        style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 13),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.verified_user_rounded, size: 16, color: Colors.green),
                      const SizedBox(width: 6),
                      Text(
                        'Verified Notice',
                        style: TextStyle(
                          color: scheme.onSurfaceVariant, 
                          fontSize: 12, 
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
