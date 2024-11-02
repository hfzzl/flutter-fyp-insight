class TherapistProfile {
  final String fullName;
  final String name;
  final String phoneNumber;
  final String bio;
  final String imageUrl;
  final String specialization;
  final String status;
  final String email;

  TherapistProfile({
    required this.fullName,
    required this.name,
    required this.phoneNumber,
    required this.bio,
    required this.imageUrl,
    required this.specialization,
    required this.status,
    required this.email,
  });

  static Future<TherapistProfile> fromMap(Object object) {
    final Map<String, dynamic> map = object as Map<String, dynamic>;
    return Future.value(TherapistProfile(
      fullName: map['fullName'],
      name: map['name'],
      phoneNumber: map['phoneNumber'],
      bio: map['bio'],
      imageUrl: map['imageUrl'],
      specialization: map['specialization'],
      status: map['status'],
      email: map['email'],
    ));
  }
}
