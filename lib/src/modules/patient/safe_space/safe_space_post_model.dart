import 'package:cloud_firestore/cloud_firestore.dart';

class SafeSpacePostModel{
  final String content;
  final String userId;
  final String postId;
  final Timestamp timestamp;

  SafeSpacePostModel({
    required this.content,
    required this.userId,
    required this.postId,
    required this.timestamp
  });

  factory SafeSpacePostModel.fromDocument(DocumentSnapshot doc){
    return SafeSpacePostModel(
      content: doc['content'],
      userId: doc['userId'],
      postId: doc['postId'],
      timestamp: doc['timestamp'],
    );
  }

}