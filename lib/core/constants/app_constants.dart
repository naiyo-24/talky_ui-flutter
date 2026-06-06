class AppConstants {
  AppConstants._();

  static const String appName = 'NewsApp';
  static const String hiveBoxName = 'news_box';
  static const String bookmarkBoxName = 'bookmarks_box';
  static const String settingsBoxName = 'settings_box';
  static const String themePrefKey = 'is_dark_mode';

  static const List<String> categories = [
    'West Bengal Politics',
    'West Bengal Development',
    'India Politics',
    'Government Schemes',
    'BJP Updates',
  ];

  static const List<String> districts = [
    'Kolkata',
    'Howrah',
    'Hooghly',
    'Darjeeling',
    'Malda',
    'Nadia',
    'Bankura',
    'Purulia',
    'Birbhum',
    'Murshidabad',
  ];

  static const List<Map<String, dynamic>> exploreCategories = [
    {'label': 'INDIA', 'emoji': '🇮🇳'},
    {'label': 'WEST BENGAL', 'emoji': '🌉'},
    {'label': 'POLITICS', 'emoji': '🎙️'},
    {'label': 'BUSINESS', 'emoji': '📈'},
    {'label': 'SPORTS', 'emoji': '⚽'},
    {'label': 'TECHNOLOGY', 'emoji': '💻'},
    {'label': 'STARTUPS', 'emoji': '🚀'},
    {'label': 'ENTERTAINMENT', 'emoji': '🎬'},
    {'label': 'INTERNATIONAL', 'emoji': '🌍'},
    {'label': 'ASTRO', 'emoji': '🔮'},
    {'label': 'SCIENCE', 'emoji': '🔬'},
    {'label': 'TRAVEL', 'emoji': '✈️'},
    {'label': 'MISCELLANEOUS', 'emoji': '🧩'},
    {'label': 'FASHION', 'emoji': '👗'},
    {'label': 'EDUCATION', 'emoji': '🎓'},
    {'label': 'HEALTH & FITNESS', 'emoji': '❤️'},
    {'label': 'WEATHER', 'emoji': '⛅'},
    {'label': 'SHARE MARKET', 'emoji': '📊'},
    {'label': 'PODCAST', 'emoji': '🎤'},
    {'label': 'VIDEO', 'emoji': '▶️'},
  ];
}
