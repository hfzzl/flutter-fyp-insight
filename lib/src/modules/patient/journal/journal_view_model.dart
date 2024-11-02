import 'package:flutter/material.dart';

import 'journal_model.dart';
import 'journal_repository.dart';

class JournalViewModel extends ChangeNotifier {
  final JournalRepository _journalRepository = JournalRepository();

  Future<void> addJournal(JournalModel journal) async {
    await _journalRepository.addJournal(journal);
    notifyListeners();
  }

  Stream<List<JournalModel>> getJournals() {
    return _journalRepository.getJournals();
  }

  Future<void> updateJournal(JournalModel journal) async {
    await _journalRepository.updateJournal(journal);
    notifyListeners();
  }

  Future<void> deleteJournal(JournalModel journal) async {
    await _journalRepository.deleteJournal(journal);
    notifyListeners();
  }
}
