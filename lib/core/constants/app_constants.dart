class AppConstants {
  AppConstants._();

  static const String appName = 'NewsApp';
  static const String hiveBoxName = 'news_box';
  static const String bookmarkBoxName = 'bookmarks_box';
  static const String themePrefKey = 'is_dark_mode';

  // Used for API category param
  static const List<String> categories = [
    'Top',
    'Business',
    'Technology',
    'Sports',
    'Health',
    'Science',
    'Entertainment',
    'Politics',
    'World',
  ];

  // Used in Explore Categories grid
  static const List<Map<String, dynamic>> exploreCategories = [
    {'label': 'Business',     'icon': 0xe0af}, // Icons.trending_up
    {'label': 'Technology',   'icon': 0xe335}, // Icons.memory
    {'label': 'Sports',       'icon': 0xe5cd}, // Icons.sports_soccer
    {'label': 'Entertainment','icon': 0xe021}, // Icons.movie
    {'label': 'Science',      'icon': 0xe2ca}, // Icons.science
    {'label': 'Health',       'icon': 0xe3f3}, // Icons.favorite
    {'label': 'Politics',     'icon': 0xe80c}, // Icons.account_balance
    {'label': 'World',        'icon': 0xe894}, // Icons.public
    {'label': 'Travel',       'icon': 0xe539}, // Icons.flight
    {'label': 'Fashion',      'icon': 0xe40c}, // Icons.checkroom
  ];
}
