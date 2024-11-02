// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../app/widget/custom_alert_box_dialog_widget.dart';
import 'therapist_verification_view.dart';
import 'user_repository.dart';
import 'verification_view.dart';

class UserViewModel extends ChangeNotifier {
  final UserRepository _userRepository;
  User? _user;
  bool _isLoading = false;

  UserViewModel(this._userRepository) {
    _userRepository.firebaseAuth.authStateChanges().listen((User? user) {
      this.user = user; // Use the setter here
    });
  }

  bool get isLoading => _isLoading;

  User? get user => _user;

  set user(User? newUser) {
    _user = newUser;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  Future<void> signIn(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      _isLoading = true;

      _user = await _userRepository.signIn(email, password);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => CustomAlertDialog(
          title: 'We are getting an error for signing in you.',
          content: e.toString(),
          buttonText: 'OK',
        ),
      );
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register(
      BuildContext context, String email, String password) async {
    try {
      _isLoading = true;
      _user = await _userRepository.register(email, password);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => VerificationView(email: email)),
      );
      notifyListeners();

      // Wait for a certain time limit for the user to verify their email
      await Future.delayed(const Duration(minutes: 3));

      // Check if the email is verified
      if (!await _userRepository.isEmailVerified(_user)) {
        // If the email is not verified, delete the user
        await _userRepository.deleteUser(_user);
        _user = null;
        showDialog(
          context: context,
          builder: (context) => const CustomAlertDialog(
            title: 'Registration Failed',
            content:
                'Email not verified within the time limit. Please try again.',
            buttonText: 'OK',
          ),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => CustomAlertDialog(
          title: 'Registration Error',
          content: e.toString(),
          buttonText: 'OK',
        ),
      );
    }
  }

  Future<void> registerTherapist(
      BuildContext context, String email, String password) async {
    try {
      _isLoading = true;
      _user = await _userRepository.registerTherapist(email, password);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TherapistVerificationView(email: email)),
      );
      notifyListeners();

      // Wait for a certain time limit for the user to verify their email
      await Future.delayed(const Duration(minutes: 3));

      // Check if the email is verified
      if (!await _userRepository.isEmailVerified(_user)) {
        // If the email is not verified, delete the user
        await _userRepository.deleteUser(_user);
        _user = null;
        showDialog(
          context: context,
          builder: (context) => const CustomAlertDialog(
            title: 'Registration Failed',
            content:
                'Email not verified within the time limit. Please try again.',
            buttonText: 'OK',
          ),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => CustomAlertDialog(
          title: 'Registration Error',
          content: e.toString(),
          buttonText: 'OK',
        ),
      );
    }
  }

  Future<void> signOut() async {
    await _userRepository.signOut();
    _user = null;
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> isEmailVerified() async {
    // return _user?.emailVerified ?? false;
    bool isVerified = await _userRepository.isEmailVerified(_user);
    // print("viewmodel isVerified: $isVerified");
    return isVerified;
  }
}
