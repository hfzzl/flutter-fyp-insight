import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import 'therapist_profile.dart';

class TherapistProfileRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> saveProfile(TherapistProfile profile) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception("User is not logged in");
      }

      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('users').doc(user.uid).get();
      String email;
      if (snapshot.exists && snapshot.data()!.containsKey('email')) {
        // Retrieve the 'email' field
        email = snapshot.data()!['email'];
      } else {
        // Handle the case where 'email' is not found or the document does not exist
        throw Exception('Email not found or user does not exist');
      }
      // await  _firestore.collection('users').doc(user.uid).collection('profiles').add({
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('profiles')
          .doc('profile')
          .set({
        'email': email,
        'fullName': profile.fullName,
        'name': profile.name,
        'specialization': profile.specialization,
        'phoneNumber': profile.phoneNumber,
        'bio': profile.bio,
        'imageUrl': profile.imageUrl,
        'joinDate': DateTime.now(),
        'status': 'reviewing',
      });

      await _firestore.collection('users').doc(user.uid).update({
        'isProfileComplete': true,
        // 'status': 'reviewing',
      });

      await _firestore.collection('therapist_reviewing').doc(user.uid).set({
        'fullName': profile.fullName,
        'name': profile.name,
        'specialization': profile.specialization,
        'email': email,
        'phoneNumber': profile.phoneNumber,
        'bio': profile.bio,
        'imageUrl': profile.imageUrl,
        'joinDate': DateTime.now(),
        'status': 'reviewing', //latest
      });
    } catch (e) {
      throw Exception("Failed to save profile");
    }
  }

  Future<String> uploadTempImage(File image) async {
    User? user = _auth.currentUser;
    if (user == null) {
      throw Exception("User is not logged in");
    }

    if (await image.exists()) {
      // FirebaseStorage firebaseStorageRef = FirebaseStorage.instance;
      Reference ref = _storage
          .ref()
          .child('users/${user.uid}')
          .child('tempProfileImage.jpg');
      await ref.putFile(image);
      String url = await ref.getDownloadURL();
      return url;
    } else {
      print('file not exist');
      return '';
    }
  }

  Future<String> uploadImage(File image) async {
    User? user = _auth.currentUser;
    if (user == null) {
      throw Exception("User is not logged in");
    }

    if (await image.exists()) {
      // FirebaseStorage firebaseStorageRef = FirebaseStorage.instance;
      Reference ref =
          _storage.ref().child('users/${user.uid}').child('profileImage.jpg');
      await ref.putFile(image);
      String url = await ref.getDownloadURL();
      return url;
    } else {
      print('file not exist');
      return '';
    }
  }

  Future<TherapistProfile> getProfile() async {
    User? user = _auth.currentUser;
    if (user == null) {
      throw Exception("User is not logged in");
    }
    DocumentSnapshot snapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('profiles')
        .doc('profile')
        .get();
    return TherapistProfile.fromMap(snapshot.data()!);
  }

  Future<TherapistProfile> getOtherUser(String userId) async {
    User? user = _auth.currentUser;
    if (user == null) {
      throw Exception("User is not logged in");
    }

    DocumentSnapshot snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('profiles')
        .doc('profile')
        .get();
    return TherapistProfile.fromMap(snapshot.data()!);
  }
}
