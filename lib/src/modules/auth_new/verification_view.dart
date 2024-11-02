import 'dart:async';

import 'package:flutter/material.dart';
import 'package:insight/src/modules/app/widget/custom_snack_bar_widget.dart';
import 'package:provider/provider.dart';

import '../app/widget/custom_elevated_button_widget.dart';
import 'user_view_model.dart';

class VerificationView extends StatefulWidget {
  final String email;

  const VerificationView({super.key, required this.email});

  // VerificationView(String email);

  @override
  State<VerificationView> createState() => _VerificationViewState();
}

class _VerificationViewState extends State<VerificationView> {
  int _counter = 180;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // Step 3
      if (_counter > 0) {
        if (mounted) {
          // Step 5
          setState(() {
            _counter--;
          });
        } else {
          _timer?.cancel(); // Optionally cancel the timer if not mounted
        }
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Step 4
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.blue, Colors.pink],
          ),
        ),
        child: Center(
          child: Container(
            height: 210,
            margin: const EdgeInsets.only(left: 20, right: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  textAlign: TextAlign.center,
                  'A verification email has been sent to  ${widget.email} ',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.timer_outlined,
                        color: Color.fromARGB(255, 32, 88, 34)),
                    Text(
                      ' $_counter seconds',
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 32, 88, 34)),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                CustomElevatedButton(
                  onPressed: () async {
                    // bool isVerified = context.read<UserViewModel>().isEmailVerified();
                    if (await context.read<UserViewModel>().isEmailVerified()) {
                      // print('user');

                      Navigator.of(context)
                          .pushReplacementNamed('/complete-profile');
                    } else {
                      showCustomSnackBar(context, 'Email not verified');
                    }
                    // Navigator.of(context).pushReplacementNamed('/complete-profile');
                  },
                  buttonText: const Text('I have verified my email'),
                ),
                CustomElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/register');
                  },
                  buttonColor: Colors.transparent,
                  buttonText: const Text('Back to register page'),
                  textColor: Colors.black,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
