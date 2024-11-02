import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRepository({FirebaseAuth? firebaseAuth, FirebaseFirestore? firestore})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  Future<UserModel?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      String uid = userCredential.user!.uid;

      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();
      String role = userDoc.get('role');
      String displayName = userDoc.get('displayName');

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', uid);
      await prefs.setString('role', role);

      return UserModel(uid: uid, role: role, displayName: displayName);
    } catch (e) {
      // print('Login failed: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('role');
    await _firebaseAuth.signOut();
  }

  Future<UserModel?> getCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('token');
    final role = prefs.getString('role');

    if (uid != null && role != null) {
      return UserModel(uid: uid, role: role);
    } else {
      return null;
    }
  }

  Future<UserModel?> registerWithEmailAndPassword(
      String email, String password, String role) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      String uid = userCredential.user!.uid;

      // Create user document in Firestore
      await _firestore.collection('users').doc(uid).set({'role': role});

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', uid);
      await prefs.setString('role', role);

      return UserModel(uid: uid, role: role);
    } catch (e) {
      // print('Registration failed: $e');
      return null;
    }
  }
}
