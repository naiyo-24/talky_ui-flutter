import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/models/user_model.dart';

class AuthNotifier extends StateNotifier<UserModel?> {
  AuthNotifier() : super(null); // null means not logged in

  void loginAsNormal(String name) {
    state = UserModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      role: UserRole.normal,
    );
  }

  void loginAsOfficial({
    required String name,
    required String designation,
    required String identityNumber,
  }) {
    state = UserModel(
      id: 'official_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      role: UserRole.official,
      designation: designation,
      identityNumber: identityNumber,
    );
  }

  void logout() {
    state = null;
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, UserModel?>((ref) {
  return AuthNotifier();
});
