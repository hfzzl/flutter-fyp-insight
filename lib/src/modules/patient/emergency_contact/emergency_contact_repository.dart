import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'emergency_contact_model.dart';

class EmergencyContactRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addEmergencyContact(
      EmergencyContactModel emergencyContact) async {
    // Add emergency contact to the database
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception("User is not logged in");
      }
      DocumentReference ref = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('emergency-contact')
          .add({
        'name': emergencyContact.name,
        'phoneNumber': emergencyContact.phoneNumber,
        'relationship': emergencyContact.relationship,
      });

      final id = ref.id;

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('emergency-contact')
          .doc(id)
          .update({
        'contactId': id,
      });
    } catch (e) {
      print(e);
    }
  }

  Stream<List<EmergencyContactModel>> getEmergencyContacts() {
    // Get emergency contacts from the database
    User? user = _auth.currentUser;
    if (user == null) {
      throw Exception("User is not logged in");
    }
    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('emergency-contact')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => EmergencyContactModel.fromDocument(doc))
          .toList();
    });
  }

  Future<void> updateEmergencyContact(
      String? contactId, EmergencyContactModel emergencyContact) async {
    // Update emergency contact in the database
    User? user = _auth.currentUser;
    if (user == null) {
      throw Exception("User is not logged in");
    }
    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('emergency-contact')
        .doc(contactId)
        .update({
      'name': emergencyContact.name,
      'phoneNumber': emergencyContact.phoneNumber,
      'relationship': emergencyContact.relationship,
    });
  }

  Future<void> deleteEmergencyContact(
      EmergencyContactModel emergencyContact) async {
    // Delete emergency contact from the database
    User? user = _auth.currentUser;
    if (user == null) {
      throw Exception("User is not logged in");
    }
    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('emergency-contact')
        .doc(emergencyContact.id)
        .delete();
  }
}
