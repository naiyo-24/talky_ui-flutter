enum UserRole { normal, official }

class UserModel {
  final String id;
  final String name;
  final UserRole role;
  
  // Official-specific fields
  final String? designation; // e.g., Police, Lawyer, News Channel
  final String? identityNumber; // Enrollment Number or CIN

  const UserModel({
    required this.id,
    required this.name,
    required this.role,
    this.designation,
    this.identityNumber,
  });

  bool get isOfficial => role == UserRole.official;
}
