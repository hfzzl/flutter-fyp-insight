import 'package:flutter/material.dart';

class ColorsConstant {
  static const Color primary = Color(0xFF13728B);
  static const Color secondary = Color(0xFF00CFA7);

  static const Color gray = Color(0xFF909090);
  static const Color grey = Color(0xFF7B7B7B);
  static const Color grayAccent = Color(0xFFCECECE);
  static const Color grayLight = Color(0xffEBEDF2);
  static const Color scaffoldBackground = Color(0xFFF5F7FB);
  static const Color background = Color(0xFFF5F7FB);

  static const Color danger = Color(0xFFD41C47);
  static const Color purple = Color(0xFF747EDB);
  static const Color blue = Color(0xFF266DD3);
  static const Color greenDark = Color(0xFF00CFA7);
  static const Color primaryDark = Color(0xFF0C1D3D);
  
  static const Color white = Colors.white;

  Color fromHex(String hexColor) {
    hexColor = hexColor.replaceAll('#', '0xFF');
    return Color(int.parse(hexColor));
  }
}
