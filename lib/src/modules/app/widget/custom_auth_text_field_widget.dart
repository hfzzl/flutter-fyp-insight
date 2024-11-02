import 'package:flutter/material.dart';

class CustomAuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final Icon? icon;

  const CustomAuthTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        fillColor: Colors.black,
        icon: icon,
        hintText: hintText,
        border: InputBorder.none,
      ),
    );
  }
}
