import 'package:flutter/material.dart';
import 'package:insight/src/modules/auth_new/therapist_model.dart';

import 'admin_repository.dart';

class AdminViewModel extends ChangeNotifier {
  final AdminRepository _repository = AdminRepository();

  Stream<List<TherapistModel>> getTherapistsList() {
    return _repository.getTherapistsList();
  }

  Stream<List<TherapistModel>> getApprovedTherapistsList() {
    return _repository.getApprovedTherapistsList();
  }

  Future<void> approveTherapist(String uid) async {
    await _repository.approveTherapist(uid);
    notifyListeners();
  }

  Future<void> rejectTherapist(String uid) async {
    await _repository.rejectTherapist(uid);
    notifyListeners();
  }
}
