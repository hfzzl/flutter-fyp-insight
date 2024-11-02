import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'journal_model.dart';

class JournalRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addJournal(JournalModel journal) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception("User is not logged in");
      }
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('journal')
          .doc('${journal.date} ${journal.time}')
          .set({
        'title': journal.title,
        'content': journal.content,
        'mood': journal.mood,
        'date': journal.date,
        'time': journal.time,
      });
    } catch (e) {
      // print(e);
    }
  }

  Stream<List<JournalModel>> getJournals() {
    User? user = _auth.currentUser;
    if (user == null) {
      throw Exception("User is not logged in");
    }
    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('journal')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => JournalModel.fromDocument(doc))
          .toList();
    });
  }

  Future<void> updateJournal(JournalModel journal) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception("User is not logged in");
      }
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('journal')
          .doc(journal.id)
          .set({
        'title': journal.title,
        'content': journal.content,
        'mood': journal.mood,
        'date': journal.date,
        'time': journal.time,
      });
    } catch (e) {
      // print(e);
    }
  }

  Future<void> deleteJournal(JournalModel journal) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception("User is not logged in");
      }
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('journal')
          .doc(journal.id)
          .delete();
    } catch (e) {
      // print(e);
    }
  }
}
