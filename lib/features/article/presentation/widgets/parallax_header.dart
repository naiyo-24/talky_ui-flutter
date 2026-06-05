import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../features/article/model/article_model.dart';

class ParallaxHeader extends StatelessWidget {
  const ParallaxHeader({
    super.key,
    required this.article,
    required this.scrollController,
  });

  final ArticleModel article;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 320,
      pinned: true,
      backgroundColor: Colors.black,
      flexibleSpace: FlexibleSpaceBar(
        background: AnimatedBuilder(
          animation: scrollController,
          builder: (context, child) {
            double offset = 0;
            if (scrollController.hasClients) {
              offset = scrollController.offset.clamp(0, 200).toDouble();
            }
            return Transform.translate(
              offset: Offset(0, offset * 0.4),
              child: child,
            );
          },
          child: Hero(
            tag: article.url,
            child: CachedNetworkImage(
              imageUrl: article.urlToImage,
              fit: BoxFit.cover,
              placeholder: (_, _) => Container(color: Colors.grey.shade900),
              errorWidget: (_, _, _) => Container(
                color: Colors.grey.shade900,
                child: const Icon(Icons.broken_image_outlined,
                    size: 60, color: Colors.white30),
              ),
            ),
          ),
        ),
        collapseMode: CollapseMode.pin,
      ),
    );
  }
}
