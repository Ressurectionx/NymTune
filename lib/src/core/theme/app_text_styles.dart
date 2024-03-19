import 'package:flutter/material.dart';

// Define the font families for easy access
class AppFonts {
  static const String comme = 'Comme';
  static const String michroma = 'Michroma';
  static const String oldTurkic = 'OldTurkic';
}

// Define text styles using the specified fonts
class AppTextStyles {
  // Header text style
  static const TextStyle header = TextStyle(
    fontFamily: AppFonts.comme,
    fontSize: 24,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  // Sub-header text style
  static const TextStyle subHeader = TextStyle(
    fontFamily: AppFonts.comme,
    fontSize: 18,
    color: Colors.white,
    fontWeight: FontWeight.w600,
  );

  // Title text style
  static const TextStyle title = TextStyle(
    fontFamily: AppFonts.comme,
    fontSize: 16,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  // Subtitle text style
  static const TextStyle subtitle = TextStyle(
    fontFamily: AppFonts.comme,
    fontSize: 14,
    color: Colors.white,
    fontWeight: FontWeight.w600,
  );

  // Info text style
  static const TextStyle info = TextStyle(
    fontFamily: AppFonts.michroma,
    color: Colors.white,
    fontSize: 12,
  );

  // Description text style
  static const TextStyle description = TextStyle(
    fontFamily: AppFonts.oldTurkic,
    fontSize: 14,
    color: Colors.white,
  );
}
