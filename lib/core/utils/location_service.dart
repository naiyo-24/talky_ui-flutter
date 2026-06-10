class LocationService {
  LocationService._();

  /// Simulates automatically fetching the user's current location via GPS/API.
  /// Currently mocked to always return "West Bengal" as requested.
  static Future<String> fetchUserLocation() async {
    // In the future, this is where you would use the geolocator or location package.
    // e.g. await Geolocator.getCurrentPosition();
    // await Future.delayed(const Duration(milliseconds: 500)); // Simulate network/GPS delay if needed
    
    return 'West Bengal';
  }
}
