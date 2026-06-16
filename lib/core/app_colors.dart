import 'package:flutter/material.dart';

class AppColors {
  // Primary colors
  static const Color primaryOrange = Color(0xFFFF7300);
  static const Color primaryGreen = Color(0xFF40B63C);
  static const Color primaryPurple = Color.fromARGB(255, 128, 0, 128);

  // Orange shades
  static const Color orangeLight = Color.fromARGB(255, 255, 115, 0);
  static const Color orange600 = Color.fromARGB(255, 230, 126, 34);
  static const Color orange700 = Color.fromARGB(255, 204, 85, 0);

  // Green shades
  static const Color green600 = Color.fromARGB(255, 76, 175, 80);
  static const Color green700 = Color.fromARGB(255, 56, 142, 60);

  // Blue shades
  static const Color blueDark900 = Color.fromARGB(255, 0, 36, 90);
  static const Color blueAccent = Colors.blueAccent;

  // Neutral colors
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color grey = Colors.grey;
  static const Color greyLight = Color.fromARGB(255, 240, 240, 240);

  // Transparent
  static Color withAlpha(Color color, double alpha) => color.withValues(alpha: alpha);
}
