import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/router/app_router.dart';
import '../providers/videos_provider.dart';
import 'widgets/video_player_item.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart';

class VideosScreen extends ConsumerStatefulWidget {
  const VideosScreen({super.key});

  @override
  ConsumerState<VideosScreen> createState() => _VideosScreenState();
}

class _VideosScreenState extends ConsumerState<VideosScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final videosAsync = ref.watch(videosProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        NavigationShellProvider.of(context).goBranch(0);
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            videosAsync.when(
              loading: () => const LoadingWidget(),
              error: (err, stack) => AppErrorWidget(message: err.toString()),
              data: (videos) {
                if (videos.isEmpty) {
                  return const Center(child: Text('No videos available', style: TextStyle(color: Colors.white)));
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(videosProvider);
                  },
                  child: PageView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: videos.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      final isTabActive = NavigationShellProvider.of(context).currentIndex == 1;
                      
                      return VideoPlayerItem(
                        video: videos[index],
                        isFocused: isTabActive && index == _currentIndex,
                      );
                    },
                  ),
                );
              },
            ),
            Positioned(
              top: 8,
              left: 8,
              child: SafeArea(
                child: Container(
                  margin: const EdgeInsets.all(8.0),
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 28),
                    onPressed: () {
                      NavigationShellProvider.of(context).goBranch(0);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
