import 'package:flutter/material.dart';

class AppTextStyles {
  // Headings
  static const TextStyle h1 = TextStyle(fontSize: 32, fontWeight: FontWeight.bold, height: 1.2);

  static const TextStyle h2 = TextStyle(fontSize: 28, fontWeight: FontWeight.bold, height: 1.2);

  static const TextStyle h3 = TextStyle(fontSize: 24, fontWeight: FontWeight.w600, height: 1.3);

  static const TextStyle h4 = TextStyle(fontSize: 20, fontWeight: FontWeight.w600, height: 1.3);

  static const TextStyle h5 = TextStyle(fontSize: 18, fontWeight: FontWeight.w500, height: 1.4);

  // Body text
  static const TextStyle bodyLarge = TextStyle(fontSize: 16, fontWeight: FontWeight.normal, height: 1.5);

  static const TextStyle bodyMedium = TextStyle(fontSize: 14, fontWeight: FontWeight.normal, height: 1.5);

  static const TextStyle bodySmall = TextStyle(fontSize: 12, fontWeight: FontWeight.normal, height: 1.5);

  // Button text
  static const TextStyle buttonLarge = TextStyle(fontSize: 16, fontWeight: FontWeight.w600, height: 1.2);

  static const TextStyle buttonMedium = TextStyle(fontSize: 14, fontWeight: FontWeight.w600, height: 1.2);

  static const TextStyle buttonSmall = TextStyle(fontSize: 12, fontWeight: FontWeight.w600, height: 1.2);

  // Caption and overlines
  static const TextStyle caption = TextStyle(fontSize: 12, fontWeight: FontWeight.normal, height: 1.4);

  static const TextStyle overline = TextStyle(fontSize: 10, fontWeight: FontWeight.w500, height: 1.6, letterSpacing: 1.5);

  // Timer specific
  static const TextStyle timerLarge = TextStyle(
    fontSize: 72,
    fontWeight: FontWeight.bold,
    height: 1.0,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  static const TextStyle timerMedium = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.bold,
    height: 1.0,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  static const TextStyle timerSmall = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.2,
    fontFeatures: [FontFeature.tabularFigures()],
  );
}
