import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommunityNotifier extends Notifier<List<Map<String, dynamic>>> {
  @override
  List<Map<String, dynamic>> build() {
    return [];
  }

  void addPost(Map<String, dynamic> post) {
    state = [post, ...state];
  }

  void deletePost(String id) {
    state = state.where((post) => post['id'] != id).toList();
  }
}

final communityProvider = NotifierProvider<CommunityNotifier, List<Map<String, dynamic>>>(() {
  return CommunityNotifier();
});
