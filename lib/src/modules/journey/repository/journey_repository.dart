import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/journey_entry.dart';

class JourneyRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addEntry(JourneyEntry entry) {
    return _firestore.collection('journey_entries').add(entry.toMap());
  }

  Future<void> updateEntry(JourneyEntry entry) {
    return _firestore
        .collection('journey_entries')
        .doc(entry.id)
        .update(entry.toMap());
  }

  Future<void> deleteEntry(String id) {
    return _firestore.collection('journey_entries').doc(id).delete();
  }

  Stream<List<JourneyEntry>> getEntries() {
    return _firestore
        .collection('journey_entries')
        .orderBy('createdAt')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => JourneyEntry.fromFirestore(doc))
          .toList();
    });
  }
}
