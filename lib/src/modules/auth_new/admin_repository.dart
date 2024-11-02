import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insight/src/modules/auth_new/therapist_model.dart';

class AdminRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<TherapistModel>> getTherapistsList() {
    // print('Getting therapists list');
    try {
      return _firestore
          .collection('therapist_reviewing').where('status', isNotEqualTo: 'rejected')
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          return TherapistModel.fromDocument(doc);
        }).toList();
      });
    } catch (e) {
      throw Exception('Failed to get therapists list');
    }
  }

  Stream<List<TherapistModel>> getApprovedTherapistsList() {
    // print('Getting approved therapists list');
    try {
      return _firestore
          .collection('therapist_approved')
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          return TherapistModel.fromDocument(doc);
        }).toList();
      });
    } catch (e) {
      throw Exception('Failed to get approved therapists list');
    }
  }

  Future<void> approveTherapist(String uid) async {
    try {
      final doc =
          await _firestore.collection('therapist_reviewing').doc(uid).get();
      if (doc.exists) {
        Map<String, dynamic> dataToUpdate = doc.data()!;
        // Update the status field
        dataToUpdate['status'] = 'approved';

        await _firestore
            .collection('therapist_approved')
            .doc(uid)
            .set(dataToUpdate);
        await _firestore.collection('therapist_reviewing').doc(uid).delete();
        await _firestore.collection('users').doc(uid).collection('profiles').doc('profile').update({
          'status': 'approved',
        });
      } else {
        throw Exception('Therapist document does not exist');
      }
    } catch (e) {
      throw Exception('Failed to approve therapist: $e');
    }
  }

  Future<void> rejectTherapist(String uid) async {
    try {
      await _firestore.collection('therapist_reviewing').doc(uid).update( {
        'status': 'rejected',
      });

      await _firestore.collection('users').doc(uid).collection('profiles').doc('profile').update({
        'status': 'rejected',
      });
    } catch (e) {
      throw Exception('Failed to reject therapist');
    }
  }
}
