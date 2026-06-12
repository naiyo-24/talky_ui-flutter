import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommunityNotifier extends Notifier<List<Map<String, dynamic>>> {
  @override
  List<Map<String, dynamic>> build() {
    return [
      {
        'id': '1',
        'author': 'City Police Dept.',
        'designation': 'Police',
        'content': 'Traffic advisory: Main Street will be closed tomorrow from 9 AM to 2 PM due to road repairs. Please use alternate routes to avoid congestion.',
        'time': '2 hours ago',
        'views': '3.4k views',
        'attachmentType': 'map',
        'attachmentName': 'Route Diversion Map',
      },
      {
        'id': '2',
        'author': 'Local News Network',
        'designation': 'News Channel',
        'content': 'Breaking: The new central park has been officially inaugurated by the Mayor today. Open to the public starting immediately! Enjoy the green spaces.',
        'time': '5 hours ago',
        'views': '8.1k views',
      },
      {
        'id': '3',
        'author': 'City Municipal Corp.',
        'designation': 'Government Employee',
        'content': 'Water supply will be affected in the northern district this weekend due to major pipeline maintenance. We request citizens to store adequate water.',
        'time': '1 day ago',
        'views': '12.5k views',
        'attachmentType': 'pdf',
        'attachmentName': 'Official Notice Circular.pdf',
      },
      {
        'id': '4',
        'author': 'Dist. Legal Services',
        'designation': 'Lawyer',
        'content': 'Free legal aid camp being organized this Sunday at the community hall. All citizens are welcome to attend for free consultations regarding property and civil rights.',
        'time': '1 day ago',
        'views': '2.1k views',
      },
      {
        'id': '5',
        'author': 'State Health Board',
        'designation': 'Government Employee',
        'content': 'Upcoming vaccination drive for children under 5 will commence next week at all district hospitals. Please bring valid Aadhaar cards for registration.',
        'time': '2 days ago',
        'views': '5.6k views',
        'attachmentType': 'pdf',
        'attachmentName': 'Vaccine Schedule.pdf',
      },
      {
        'id': '6',
        'author': 'Cyber Crime Unit',
        'designation': 'Police',
        'content': 'Alert: Beware of a new phishing scam asking for OTPs under the guise of electricity bill payments. Do NOT share your OTPs with anyone. We have registered 50+ complaints this week.',
        'time': '3 days ago',
        'views': '15.2k views',
      },
    ];
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
