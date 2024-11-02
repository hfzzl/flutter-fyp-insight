import 'package:cloud_firestore/cloud_firestore.dart';

class TherapistModel {
  final String userId;
  final String fullName;
  final String name;
  final String specialization;
  final String phoneNo;
  final String imageUrl;
  final String status;
  final String email;

  TherapistModel({
    required this.userId,
    required this.fullName,
    required this.name,
    required this.specialization,
    required this.phoneNo,
    required this.imageUrl,
    required this.status,
    required this.email,
  });

  factory TherapistModel.fromDocument(DocumentSnapshot doc) {
    return TherapistModel(
      userId: doc.id,
      fullName: doc['fullName'],
      name: doc['name'],
      specialization: doc['specialization'],
      phoneNo: doc['phoneNumber'],
      imageUrl: doc['imageUrl'],
      status: doc['status'],
      email: doc['email'],
    );
  }
}
