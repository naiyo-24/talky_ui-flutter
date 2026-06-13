import 'package:flutter/material.dart';

class VideoPlayerWidget extends StatelessWidget {
  final String videoPath;

  const VideoPlayerWidget({super.key, required this.videoPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Text(
          'Video feature temporarily disabled',
          style: TextStyle(color: Colors.white54),
        ),
      ),
    );
  }
}
