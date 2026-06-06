import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../model/video_model.dart';

class VideoPlayerItem extends StatefulWidget {
  final VideoModel video;
  final bool isFocused;
  
  const VideoPlayerItem({
    super.key, 
    required this.video,
    required this.isFocused,
  });

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  YoutubePlayerController? _controller;
  String _videoId = '';

  @override
  void initState() {
    super.initState();
    _extractVideoId();
    if (widget.isFocused) {
      _initPlayer();
    }
  }

  void _extractVideoId() {
    final uri = Uri.tryParse(widget.video.youtubeUrl);
    if (uri != null) {
      if (uri.host.contains('youtu.be')) {
        _videoId = uri.pathSegments.isNotEmpty ? uri.pathSegments.first : '';
      } else if (uri.host.contains('youtube.com')) {
        if (uri.pathSegments.contains('shorts') || uri.pathSegments.contains('live') || uri.pathSegments.contains('embed')) {
          final index = uri.pathSegments.indexWhere((s) => s == 'shorts' || s == 'live' || s == 'embed');
          if (index != -1 && index + 1 < uri.pathSegments.length) {
            _videoId = uri.pathSegments[index + 1];
          }
        } else {
          _videoId = uri.queryParameters['v'] ?? '';
        }
      }
    }
  }

  void _initPlayer() {
    if (_videoId.isEmpty) return;
    _controller = YoutubePlayerController.fromVideoId(
      videoId: _videoId,
      autoPlay: true,
      params: const YoutubePlayerParams(
        showControls: false,
        showFullscreenButton: false,
        loop: true,
        mute: false,
        pointerEvents: PointerEvents.none,
      ),
    );
  }

  @override
  void didUpdateWidget(covariant VideoPlayerItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFocused && !oldWidget.isFocused) {
      if (_controller == null) {
        _initPlayer();
      } else {
        _controller!.playVideo();
      }
    } else if (!widget.isFocused && oldWidget.isFocused) {
      _controller?.pauseVideo();
    }
  }

  @override
  void dispose() {
    _controller?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Show thumbnail when not focused or loading
        if (!widget.isFocused || _controller == null)
          CachedNetworkImage(
            imageUrl: widget.video.thumbnail,
            fit: BoxFit.cover,
            errorWidget: (context, url, error) => const Center(
              child: Icon(Icons.error, color: Colors.white),
            ),
          )
        else
          Center(
            child: YoutubePlayer(
              controller: _controller!,
              aspectRatio: 16 / 9,
              enableFullScreenOnVerticalDrag: false,
              gestureRecognizers: const {},
            ),
          ),
          
        // Invisible shield to ensure the platform view (WebView) doesn't swallow swipe gestures
        Positioned.fill(
          child: Container(
            color: Colors.transparent,
          ),
        ),
          
        // Gradient overlay for text readability
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withValues(alpha: 0.8),
                  Colors.transparent,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
        ),
        // Video Details
        Positioned(
          bottom: 40,
          left: 16,
          right: 60,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.video.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
