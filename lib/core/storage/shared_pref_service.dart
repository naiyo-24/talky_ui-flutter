import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

class SharedPrefService {
  SharedPrefService._();

  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static SharedPreferences get prefs {
    if (_prefs == null) throw Exception('SharedPrefService not initialized');
    return _prefs!;
  }

  static bool get isDarkMode => prefs.getBool(AppConstants.themePrefKey) ?? false;

  static Future<void> setDarkMode(bool value) async {
    await prefs.setBool(AppConstants.themePrefKey, value);
  }
}
