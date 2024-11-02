import 'package:cloud_firestore/cloud_firestore.dart';

class JournalModel {
  final String id;
  final String title;
  final String content;
  final String mood;
  final String date;
  final String time;

  JournalModel(
      {required this.id,
      required this.title,
      required this.content,
      required this.mood,
      required this.date,
      required this.time});

  factory JournalModel.fromDocument(DocumentSnapshot doc) {
    return JournalModel(
        id: doc.id,
        title: doc['title'],
        content: doc['content'],
        mood: doc['mood'],
        date: doc['date'],
        time: doc['time']);
  }
}
