import 'package:cloud_firestore/cloud_firestore.dart';

class JourneyModel {
  final String journeyPostId;
  final String userId;
  final String content;
  final Timestamp timestamp;

  JourneyModel({
    required this.journeyPostId,
    required this.userId,
    required this.content,
    required this.timestamp,
  });

  factory JourneyModel.fromDocument(DocumentSnapshot doc) {
    return JourneyModel(
      journeyPostId: doc['journeyPostId'],
      userId: doc['userId'],
      content: doc['content'],
      timestamp: doc['timestamp'],
    );
  }
}
