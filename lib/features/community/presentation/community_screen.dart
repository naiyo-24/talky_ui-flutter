import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/router/app_router.dart';
import '../../../../l10n/app_localizations.dart';
import 'community_post_detail_screen.dart';

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

  final List<Map<String, dynamic>> _dummyPosts = [
    {
      'author': 'City Police Dept.',
      'designation': 'Police',
      'content': 'Traffic advisory: Main Street will be closed tomorrow from 9 AM to 2 PM due to road repairs. Please use alternate routes to avoid congestion.',
      'time': '2 hours ago',
      'views': '3.4k views',
      'attachmentType': 'map',
      'attachmentName': 'Route Diversion Map',
    },
    {
      'author': 'Local News Network',
      'designation': 'News Channel',
      'content': 'Breaking: The new central park has been officially inaugurated by the Mayor today. Open to the public starting immediately! Enjoy the green spaces.',
      'time': '5 hours ago',
      'views': '8.1k views',
    },
    {
      'author': 'City Municipal Corp.',
      'designation': 'Government Employee',
      'content': 'Water supply will be affected in the northern district this weekend due to major pipeline maintenance. We request citizens to store adequate water.',
      'time': '1 day ago',
      'views': '12.5k views',
      'attachmentType': 'pdf',
      'attachmentName': 'Official Notice Circular.pdf',
    },
    {
      'author': 'Dist. Legal Services',
      'designation': 'Lawyer',
      'content': 'Free legal aid camp being organized this Sunday at the community hall. All citizens are welcome to attend for free consultations regarding property and civil rights.',
      'time': '1 day ago',
      'views': '2.1k views',
    },
    {
      'author': 'State Health Board',
      'designation': 'Government Employee',
      'content': 'Upcoming vaccination drive for children under 5 will commence next week at all district hospitals. Please bring valid Aadhaar cards for registration.',
      'time': '2 days ago',
      'views': '5.6k views',
      'attachmentType': 'pdf',
      'attachmentName': 'Vaccine Schedule.pdf',
    },
    {
      'author': 'Cyber Crime Unit',
      'designation': 'Police',
      'content': 'Alert: Beware of a new phishing scam asking for OTPs under the guise of electricity bill payments. Do NOT share your OTPs with anyone. We have registered 50+ complaints this week.',
      'time': '3 days ago',
      'views': '15.2k views',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final loc = AppLocalizations.of(context)!;

    final filteredPosts = _selectedFilter == 'All'
        ? _dummyPosts
        : _dummyPosts.where((p) => p['designation'] == _selectedFilter).toList();

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
              Text(
                post['content']!,
                style: const TextStyle(fontSize: 15, height: 1.5),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              
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
