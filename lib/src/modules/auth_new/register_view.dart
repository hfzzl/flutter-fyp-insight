import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app/widget/custom_elevated_button_widget.dart';
import '../app/widget/custom_snack_bar_widget.dart';
import '../app/widget/custom_auth_text_field_widget.dart';
import 'user_view_model.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.pink],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Container(
            margin: const EdgeInsets.only(left: 20, right: 20),
            padding: const EdgeInsets.all(20),
            height: 450,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Get Started',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Let\'s get started by filling out the form below',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
                CustomAuthTextField(
                    controller: _emailController,
                    hintText: 'Email',
                    icon: const Icon(Icons.email)),
                const Divider(),
                CustomAuthTextField(
                    controller: _passwordController,
                    hintText: 'Password',
                    obscureText: true,
                    icon: const Icon(Icons.lock)),
                const SizedBox(height: 20),
                CustomElevatedButton(
                  onPressed: () async {
                    if (_emailController.text.isEmpty ||
                        _passwordController.text.isEmpty) {
                      showCustomSnackBar(context, 'Please fill in all fields');
                      return;
                    }
                    if (!RegExp(
                            r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                        .hasMatch(_emailController.text)) {
                      showCustomSnackBar(context, 'Please enter a valid email');
                      return;
                    }
                    if (_passwordController.text.length < 6 ||
                        !RegExp(r'^(?=.*[A-Z])(?=.*\d).+$')
                            .hasMatch(_passwordController.text)) {
                      showCustomSnackBar(context,
                          'Password should be at least 6 characters, with at least one capital letter and one digit');
                      return;
                    }
                    setState(() {
                      _isLoading = true;
                    });
                    await context.read<UserViewModel>().register(context,
                        _emailController.text, _passwordController.text);
                    setState(() {
                      _isLoading = false;
                    });
                  },
                  buttonText: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('Create Account'),
                ),
                const SizedBox(height: 10),
                CustomElevatedButton(
                  onPressed: () async {
                    if (_emailController.text.isEmpty ||
                        _passwordController.text.isEmpty) {
                      showCustomSnackBar(context, 'Please fill in all fields');
                      return;
                    }
                    if (!RegExp(
                            r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                        .hasMatch(_emailController.text)) {
                      showCustomSnackBar(context, 'Please enter a valid email');
                      return;
                    }
                    if (_passwordController.text.length < 6 ||
                        !RegExp(r'^(?=.*[A-Z])(?=.*\d).+$')
                            .hasMatch(_passwordController.text)) {
                      showCustomSnackBar(context,
                          'Password should be at least 6 characters, with at least one capital letter and one digit');
                      return;
                    }
                    setState(() {
                      _isLoading = true;
                    });
                    await context.read<UserViewModel>().registerTherapist(
                        context,
                        _emailController.text,
                        _passwordController.text);
                    setState(() {
                      _isLoading = false;
                    });
                  },
                  // buttonText: const Text('Register as Therapist'),
                  buttonText: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('Register as Therapist'),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Don\'t have an account? ',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed('/login');
                      },
                      child: const Text(
                        'Sign In here',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.deepPurpleAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
