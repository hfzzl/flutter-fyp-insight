import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:insight/src/modules/journey/repository/journey_repository.dart';
import '../model/journey_entry.dart';

class JourneyViewModel extends ChangeNotifier {
  List<JourneyEntry> _entries = [];

  List<JourneyEntry> get entries => _entries;

  JourneyViewModel(JourneyRepository read) {
    _fetchEntries();
  }

  Future<void> _fetchEntries() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userId = user.uid;
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('entries')
          .orderBy('createdAt', descending: true)
          .get();

      _entries = snapshot.docs.map((doc) {
        final data = doc.data();
        return JourneyEntry(
          id: doc.id,
          title: data['title'] ?? '',
          content: data['content'] ?? '',
          createdAt: (data['createdAt'] as Timestamp).toDate(),
        );
      }).toList();
      notifyListeners();
    }
  }

  Future<void> addEntry(JourneyEntry entry) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userId = user.uid;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('entries')
          .doc(entry.id)
          .set({
        'title': entry.title,
        'content': entry.content,
        'createdAt': entry.createdAt,
      });

      _entries.add(entry);
      notifyListeners();
    }
  }

  Future<void> deleteEntry(String id) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userId = user.uid;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('entries')
          .doc(id)
          .delete();

      _entries.removeWhere((entry) => entry.id == id);
      notifyListeners();
    }
  }
}
