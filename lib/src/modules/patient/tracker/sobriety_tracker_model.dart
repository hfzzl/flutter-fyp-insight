import 'package:cloud_firestore/cloud_firestore.dart';

class SobrietyTrackerModel {
  final String id;
  final String startDate;
  final String startTime;
  final String sobriety;
  final String goal;
  final int streak;

  SobrietyTrackerModel(
      {required this.id,
      required this.startDate,
      required this.startTime,
      required this.sobriety,
      required this.goal,
      required this.streak});

  factory SobrietyTrackerModel.fromDocument(DocumentSnapshot doc) {
    return SobrietyTrackerModel(
      id: doc.id,
      startDate: doc['startDate'],
      startTime: doc['startTime'],
      sobriety: doc['sobriety'],
      goal: doc['goal'],
      streak: doc['streak'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'startDate': startDate,
      'startTime': startTime,
      'sobriety': sobriety,
      'goal': goal,
      'streak': streak
    };
  }
}
