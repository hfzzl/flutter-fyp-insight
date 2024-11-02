import 'package:cloud_firestore/cloud_firestore.dart';

class SafeSpaceModel {
  final String creatorId;
  final String safeSpaceId;
  final String safeSpaceName;
  final String description;
  final String createdTime;
  final String safeSpaceImage;

  SafeSpaceModel(
      {required this.creatorId,
      required this.safeSpaceId,
      required this.safeSpaceName,
      required this.description,
      required this.createdTime,
      required this.safeSpaceImage});

  factory SafeSpaceModel.fromDocument(DocumentSnapshot doc) {
    return SafeSpaceModel(
      creatorId: doc['creatorId'],
      safeSpaceId: doc['safeSpaceId'],
      safeSpaceName: doc['spaceName'],
      description: doc['description'],
      createdTime: doc['timestamp'],
      safeSpaceImage: doc['safeSpaceImage'],
    );
  }
}
