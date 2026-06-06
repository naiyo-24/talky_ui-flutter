import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/video_model.dart';

final videosProvider = FutureProvider.autoDispose<List<VideoModel>>((ref) async {
  final jsonString = await rootBundle.loadString('assets/json/videos.json');
  final List<dynamic> jsonList = jsonDecode(jsonString);
  final videos = jsonList.map((e) => VideoModel.fromJson(e)).toList();
  videos.shuffle();
  return videos;
});
