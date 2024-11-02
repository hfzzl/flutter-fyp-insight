import 'package:cloud_firestore/cloud_firestore.dart';

class EmergencyContactModel {
  final String id;
  final String name;
  final String phoneNumber;
  final String relationship;

  EmergencyContactModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.relationship,
  });

  factory EmergencyContactModel.fromMap(Map<String, dynamic> map) {
    return EmergencyContactModel(
      id: map['id'],
      name: map['name'],
      phoneNumber: map['phoneNumber'],
      relationship: map['relationship'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'relationship': relationship,
    };
  }

  factory EmergencyContactModel.fromDocument(DocumentSnapshot doc) {
    return EmergencyContactModel(
      id: doc.id,
      name: doc['name'],
      phoneNumber: doc['phoneNumber'],
      relationship: doc['relationship'],
    );
  }
}
