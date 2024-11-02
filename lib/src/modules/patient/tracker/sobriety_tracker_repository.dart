import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import 'sobriety_tracker_model.dart';

class SobrietyTrackerRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // final CollectionReference _collectionReference =
  //     FirebaseFirestore.instance.collection('users');

  Future<void> addSobrietyTracker(SobrietyTrackerModel sobrietyTracker) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception("User is not logged in");
      }
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('sobriety-tracker')
          .doc(sobrietyTracker.sobriety)
          .set({
        'startDate': sobrietyTracker.startDate,
        'startTime': sobrietyTracker.startTime,
        'sobriety': sobrietyTracker.sobriety,
        'goal': sobrietyTracker.goal,
        'streak': sobrietyTracker.streak,
      });
    } catch (e) {
      print(e);
    }
  }

  Stream<List<SobrietyTrackerModel>> getSobrietyTrackers() {
    User? user = _auth.currentUser;
    if (user == null) {
      throw Exception("User is not logged in");
    }
    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('sobriety-tracker')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => SobrietyTrackerModel.fromDocument(doc))
          .toList();
    });
  }

  Future<void> updateStreak() async {
    User? user = _auth.currentUser;
    if (user == null) {
      throw Exception("User is not logged in");
    }

    // Get all documents in the sobriety-tracker collection
    var collection = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('sobriety-tracker');
    var snapshot = await collection.get();

    // Get today's date
    var today = DateTime.now();

    // Iterate over each document and update the streak field
    for (var doc in snapshot.docs) {
      // Get the date from the document
      var docDateStr = doc.data()['startDate'];

      if (docDateStr != null) {
        // Parse the date string to a DateTime object
        var docDate = DateFormat('MMM dd, yyyy').parse(docDateStr);

        // Calculate the difference in days
        var difference = today.difference(docDate).inDays;

        // Update the streak field with the difference
        await collection.doc(doc.id).update({
          'streak': difference,
        });
      }
    }
  }

  Future<void> updateSobrietyTracker(
      SobrietyTrackerModel sobrietyTracker) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception("User is not logged in");
      }
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('sobriety-tracker')
          .doc(sobrietyTracker.sobriety)
          .set({
        'startDate': sobrietyTracker.startDate,
        'startTime': sobrietyTracker.startTime,
        'sobriety': sobrietyTracker.sobriety,
        'goal': sobrietyTracker.goal,
        'streak': sobrietyTracker.streak,
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteSobrietyTracker(
      SobrietyTrackerModel sobrietyTracker) async {
    User? user = _auth.currentUser;
    if (user == null) {
      throw Exception("User is not logged in");
    }
    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('sobriety-tracker')
        .doc(sobrietyTracker.id)
        .delete();
  }
}
