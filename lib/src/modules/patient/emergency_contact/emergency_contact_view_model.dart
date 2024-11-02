import 'package:flutter/material.dart';

import 'emergency_contact_model.dart';
import 'emergency_contact_repository.dart';

class EmergencyContactViewModel extends ChangeNotifier {
  final EmergencyContactRepository _emergencyContactRepository =
      EmergencyContactRepository();

  Future<void> addEmergencyContact(
      EmergencyContactModel emergencyContact) async {
    await _emergencyContactRepository.addEmergencyContact(emergencyContact);
    notifyListeners();
  }

  Stream<List<EmergencyContactModel>> getEmergencyContacts() {
    return _emergencyContactRepository.getEmergencyContacts();
  }

  Future<void> updateEmergencyContact(
      String? contactId, EmergencyContactModel emergencyContact) async {
    await _emergencyContactRepository.updateEmergencyContact(
        contactId, emergencyContact);
    notifyListeners();
  }

  Future<void> deleteEmergencyContact(
      EmergencyContactModel emergencyContact) async {
    await _emergencyContactRepository.deleteEmergencyContact(emergencyContact);
    notifyListeners();
  }
}
