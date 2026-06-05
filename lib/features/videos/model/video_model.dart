class VideoModel {
  final String title;
  final String thumbnail;
  final String youtubeUrl;

  VideoModel({
    required this.title,
    required this.thumbnail,
    required this.youtubeUrl,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      title: json['title'] as String? ?? '',
      thumbnail: json['thumbnail'] as String? ?? '',
      youtubeUrl: json['youtubeUrl'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'thumbnail': thumbnail,
        'youtubeUrl': youtubeUrl,
      };
}
