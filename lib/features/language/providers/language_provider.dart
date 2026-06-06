import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/storage/hive_service.dart';

class LanguageNotifier extends StateNotifier<String> {
  LanguageNotifier() : super(HiveService.language.isEmpty ? 'en' : HiveService.language);

  void setLanguage(String langCode) async {
    await HiveService.setLanguage(langCode);
    state = langCode;
  }
}

final languageProvider = StateNotifierProvider<LanguageNotifier, String>((ref) {
  return LanguageNotifier();
});
