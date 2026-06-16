import 'package:flutter/material.dart';
import 'package:unisafe/core/app_colors.dart';

class AppTextStyles {
  static const TextStyle heading1 = TextStyle(fontFamily: 'Poppins', fontSize: 24, fontWeight: FontWeight.bold);

  static const TextStyle heading2 = TextStyle(fontFamily: 'Poppins', fontSize: 20, fontWeight: FontWeight.bold);

  static const TextStyle heading3 = TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.bold);

  static const TextStyle bodyLarge = TextStyle(fontSize: 16, fontWeight: FontWeight.normal);

  static const TextStyle bodyMedium = TextStyle(fontSize: 14, fontWeight: FontWeight.normal);

  static const TextStyle bodySmall = TextStyle(fontSize: 12, fontWeight: FontWeight.normal);

  static const TextStyle buttonText = TextStyle(fontSize: 16, fontWeight: FontWeight.w600);

  static const TextStyle titleSmall = TextStyle(fontSize: 14, fontWeight: FontWeight.w500);
}

class AppThemes {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light().copyWith(primary: AppColors.primaryOrange),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark().copyWith(primary: AppColors.primaryOrange),
    );
  }
}
