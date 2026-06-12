import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/storage/hive_service.dart';

class AuthNotifier extends Notifier<bool> {
  @override
  bool build() {
    // Initial state is loaded directly from Hive
    return HiveService.isAuthenticated;
  }

  Future<void> login() async {
    await HiveService.setAuthenticated(true);
    state = true;
  }

  Future<void> logout() async {
    await HiveService.setAuthenticated(false);
    state = false;
  }
}

final authProvider = NotifierProvider<AuthNotifier, bool>(() {
  return AuthNotifier();
});
