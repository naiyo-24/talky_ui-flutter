import '../../../features/article/model/article_model.dart';

class DummyData {
  static List<ArticleModel> get dummyArticles => [
        ArticleModel(
          source: 'TechCrunch',
          author: 'Jane Doe',
          title: 'Flutter 4.0 Released with Incredible Performance Boosts',
          description:
              'The new Flutter update brings unparalleled performance to both mobile and web platforms.',
          url: 'https://flutter.dev',
          urlToImage:
              'https://images.unsplash.com/photo-1617042375876-a13e36732a30?q=80&w=1000&auto=format&fit=crop',
          publishedAt:
              DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
          content:
              'Flutter 4.0 has been officially released today, marking a massive milestone...',
          category: 'technology',
        ),
        ArticleModel(
          source: 'The Verge',
          author: 'John Smith',
          title: 'SpaceX Successfully Launches New Super Heavy Rocket',
          description:
              'The latest test flight of the Starship system achieved orbit and safely returned.',
          url: 'https://spacex.com',
          urlToImage:
              'https://images.unsplash.com/photo-1517976487492-5750f3195933?q=80&w=1000&auto=format&fit=crop',
          publishedAt:
              DateTime.now().subtract(const Duration(hours: 5)).toIso8601String(),
          content:
              'In a stunning display of engineering prowess, SpaceX has completed its most ambitious test flight yet...',
          category: 'science',
        ),
        ArticleModel(
          source: 'Wired',
          author: 'Alice Johnson',
          title: 'AI Models are Getting Smaller and Smarter',
          description:
              'Researchers have found a way to compress large language models without losing capabilities.',
          url: 'https://wired.com',
          urlToImage:
              'https://images.unsplash.com/photo-1620712943543-bcc4688e7485?q=80&w=1000&auto=format&fit=crop',
          publishedAt:
              DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
          content:
              'Artificial intelligence is moving from massive data centers to local devices thanks to new compression techniques...',
          category: 'technology',
        ),
        ArticleModel(
          source: 'Bloomberg',
          author: 'Michael Brown',
          title: 'Global Markets Rally as Tech Stocks Surge',
          description:
              'Major indices hit record highs today, driven by strong earnings from tech giants.',
          url: 'https://bloomberg.com',
          urlToImage:
              'https://images.unsplash.com/photo-1611974789855-9c2a0a7236a3?q=80&w=1000&auto=format&fit=crop',
          publishedAt:
              DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
          content:
              'Investors are bullish on the technology sector after a wave of positive earnings reports...',
          category: 'business',
        ),
        ArticleModel(
          source: 'ESPN',
          author: 'Sarah Davis',
          title: 'Underdog Team Wins Championship in Stunning Upset',
          description:
              'In a match for the ages, the lowest-seeded team took home the trophy.',
          url: 'https://espn.com',
          urlToImage:
              'https://images.unsplash.com/photo-1541534741688-6078c6bfb5c5?q=80&w=1000&auto=format&fit=crop',
          publishedAt:
              DateTime.now().subtract(const Duration(hours: 12)).toIso8601String(),
          content:
              'Nobody expected them to make it past the first round, but they defied all odds...',
          category: 'sports',
        ),
      ];
}
