class CommunityMemberProfile {
  final String name;
  final String phoneNumber;
  final String bio;
  final String imageUrl;
  final String email;

  CommunityMemberProfile({
    required this.name,
    required this.phoneNumber,
    required this.bio,
    required this.imageUrl,
    required this.email,
  });

  static Future<CommunityMemberProfile> fromMap(Object object) {
    final Map<String, dynamic> map = object as Map<String, dynamic>;
    return Future.value(CommunityMemberProfile(
      name: map['name'],
      phoneNumber: map['phoneNumber'],
      bio: map['bio'],
      imageUrl: map['imageUrl'],
      email: map['email'],
    ));
  }
}
