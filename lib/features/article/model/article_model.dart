import 'package:hive/hive.dart';
import '../../../core/storage/hive_service.dart';
part 'article_model.g.dart';

@HiveType(typeId: 0)
class ArticleModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String titleBn;

  @HiveField(2)
  final String titleEn;

  @HiveField(3)
  final String contentBn;

  @HiveField(4)
  final String contentEn;

  @HiveField(5)
  final String imageUrl;

  @HiveField(6)
  final String category;

  @HiveField(7)
  final String district;

  @HiveField(8)
  final DateTime publishedAt;

  ArticleModel({
    required this.id,
    required this.titleBn,
    required this.titleEn,
    required this.contentBn,
    required this.contentEn,
    required this.imageUrl,
    required this.category,
    required this.district,
    required this.publishedAt,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      id: json['id'] as String? ?? '',
      titleBn: json['titleBn'] as String? ?? '',
      titleEn: json['titleEn'] as String? ?? '',
      contentBn: json['contentBn'] as String? ?? '',
      contentEn: json['contentEn'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      category: json['category'] as String? ?? '',
      district: json['district'] as String? ?? '',
      publishedAt: json['publishedAt'] != null 
          ? DateTime.parse(json['publishedAt'] as String) 
          : DateTime.now(),
    );
  }

  // Getters for legacy compatibility and localization
  String get title {
    return HiveService.language == 'en' ? titleEn : titleBn;
  }
  
  String get content {
    return HiveService.language == 'en' ? contentEn : contentBn;
  }

  String get description {
    return HiveService.language == 'en' ? contentEn : contentBn;
  }

  String get urlToImage => imageUrl;
  String get url => id;
  String get author => 'News Source';
  String get source => 'Local News';

  Map<String, dynamic> toJson() => {
        'id': id,
        'titleBn': titleBn,
        'titleEn': titleEn,
        'contentBn': contentBn,
        'contentEn': contentEn,
        'imageUrl': imageUrl,
        'category': category,
        'district': district,
        'publishedAt': publishedAt.toIso8601String(),
      };
}
