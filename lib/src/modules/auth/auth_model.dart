import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = userCredential.user;
    } catch (e) {
      // handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = userCredential.user;
    } catch (e) {
      // handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }
}
