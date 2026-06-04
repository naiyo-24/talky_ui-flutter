import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/storage/shared_pref_service.dart';

class ThemeNotifier extends StateNotifier<bool> {
  ThemeNotifier() : super(SharedPrefService.isDarkMode);

  Future<void> toggle() async {
    state = !state;
    await SharedPrefService.setDarkMode(state);
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, bool>(
  (ref) => ThemeNotifier(),
);
