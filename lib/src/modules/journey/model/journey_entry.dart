import 'package:cloud_firestore/cloud_firestore.dart';

class JourneyEntry {
  late final String id;
  final String title;
  final String content;
  final DateTime createdAt;

  JourneyEntry({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  factory JourneyEntry.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return JourneyEntry(
      id: doc.id,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'createdAt': createdAt,
    };
  }
}
