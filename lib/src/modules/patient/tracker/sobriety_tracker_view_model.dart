import 'package:flutter/material.dart';
import 'sobriety_tracker_repository.dart';
import 'sobriety_tracker_model.dart';

class SobrietyTrackerViewModel extends ChangeNotifier {
  final SobrietyTrackerRepository _sobrietyTrackerRepository =
      SobrietyTrackerRepository();

  Future<void> addSobrietyTracker(SobrietyTrackerModel sobrietyTracker) async {
    await _sobrietyTrackerRepository.addSobrietyTracker(sobrietyTracker);
    notifyListeners();
  }

  Stream<List<SobrietyTrackerModel>> getSobrietyTrackers() {
    return _sobrietyTrackerRepository.getSobrietyTrackers();
  }

  Future<void> updateStreak() async {
    await _sobrietyTrackerRepository.updateStreak();
    notifyListeners();
  }

  Future<void> updateSobrietyTracker(
      SobrietyTrackerModel sobrietyTracker) async {
    await _sobrietyTrackerRepository.updateSobrietyTracker(sobrietyTracker);
    notifyListeners();
  }

  Future<void> deleteSobrietyTracker(
      SobrietyTrackerModel sobrietyTracker) async {
    await _sobrietyTrackerRepository.deleteSobrietyTracker(sobrietyTracker);
    notifyListeners();
  }
}
