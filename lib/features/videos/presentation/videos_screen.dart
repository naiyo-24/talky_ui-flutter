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

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        NavigationShellProvider.of(context).goBranch(0);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: videosAsync.when(
          loading: () => const LoadingWidget(),
          error: (err, stack) => AppErrorWidget(message: err.toString()),
          data: (videos) {
            if (videos.isEmpty) {
              return const Center(child: Text('No videos available', style: TextStyle(color: Colors.white)));
            }
            return PageView.builder(
              scrollDirection: Axis.vertical,
              itemCount: videos.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return VideoPlayerItem(
                  video: videos[index],
                  isFocused: index == _currentIndex,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
