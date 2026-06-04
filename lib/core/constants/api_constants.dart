class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://newsapi.org/v2';
  static const String apiKey = '5bed1117549b4e1aa2cb9ae0c856d5d6';

  // Endpoints
  static const String topHeadlines = '/top-headlines';
  static const String everything = '/everything';
  static const String sources = '/sources';

  // Params
  static const String country = 'us';
  static const int pageSize = 20;
}
