import 'package:flutter/material.dart';

class AppColors {
  // Colors extracted from logo.png
  static const Color white = Color(0xFFFFFFFF);
  static const Color darkGreen = Color(0xFF076633); // (7, 102, 51)
  static const Color deepBlue = Color(0xFF2B2E83);  // (43, 46, 131)
  static const Color skyBlue = Color(0xFF009FE3);   // (0, 159, 227)
  static const Color yellow = Color(0xFFFDC500);    // (253, 197, 0)

  // Primary palette based on dominant logo colors
  static const Color primary = deepBlue;
  static const Color secondary = darkGreen;
  static const Color accent = skyBlue;
  static const Color warning = yellow;
  static const Color background = Color(0xFFF8F9FA);
  
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF666666);
  
  static const Color cardPurple = deepBlue;
  static const Color cardTeal = skyBlue;
  static const Color cardOrange = yellow;
  
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [deepBlue, skyBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [skyBlue, darkGreen],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Backwards compatibility or legacy references
  static const LinearGradient purpleGradient = primaryGradient;
  static const LinearGradient tealGradient = accentGradient;
}

class AppTextStyles {
  static const TextStyle heading = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
    fontFamily: 'Poppins',
  );

  static const TextStyle subHeading = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    fontFamily: 'Poppins',
  );

  static const TextStyle body = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
    height: 1.5,
    fontFamily: 'Poppins',
  );
}
