import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget buttonText;
  final Color? buttonColor;
  final Color? textColor;

  const CustomElevatedButton({
    super.key,
    required this.onPressed,
    required this.buttonText,
    this.buttonColor = const Color.fromARGB(255, 117, 46, 231),
    this.textColor = Colors.white,
  });
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: textColor,
        minimumSize: const Size(305, 40),
        backgroundColor: buttonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 0,
      ),
      child: buttonText,
    );
  }
}
