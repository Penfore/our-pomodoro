import 'package:flutter/material.dart';

class AppColors {
  // Primary colors
  static const Color primary = Color(0xFFE74C3C);
  static const Color primaryDark = Color(0xFFC0392B);
  static const Color primaryLight = Color(0xFFEC7063);

  // Secondary colors
  static const Color secondary = Color(0xFF2ECC71);
  static const Color secondaryDark = Color(0xFF27AE60);
  static const Color secondaryLight = Color(0xFF58D68D);

  // Background colors - Light Mode
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Color(0xFFFFFFFF);

  // Background colors - Dark Mode
  static const Color backgroundDark = Color(0xFF0F0F0F);
  static const Color surfaceDark = Color(0xFF1A1A1A);
  static const Color surfaceDark2 = Color(0xFF242424);
  static const Color surfaceDark3 = Color(0xFF2E2E2E);

  // Text colors - Light Mode
  static const Color textPrimary = Color(0xFF2C3E50);
  static const Color textSecondary = Color(0xFF7F8C8D);
  static const Color textLight = Color(0xFFFFFFFF);

  // Text colors - Dark Mode
  static const Color textDarkPrimary = Color(0xFFE5E5E5);
  static const Color textDarkSecondary = Color(0xFFB0B0B0);
  static const Color textDarkTertiary = Color(0xFF808080);

  // Status colors
  static const Color success = Color(0xFF27AE60);
  static const Color warning = Color(0xFFF39C12);
  static const Color error = Color(0xFFE74C3C);
  static const Color info = Color(0xFF3498DB);

  // Neutral colors
  static const Color grey50 = Color(0xFFF8F9FA);
  static const Color grey100 = Color(0xFFE9ECEF);
  static const Color grey200 = Color(0xFFDEE2E6);
  static const Color grey300 = Color(0xFFCED4DA);
  static const Color grey400 = Color(0xFFADB5BD);
  static const Color grey500 = Color(0xFF6C757D);
  static const Color grey600 = Color(0xFF495057);
  static const Color grey700 = Color(0xFF343A40);
  static const Color grey800 = Color(0xFF212529);
  static const Color grey900 = Color(0xFF0C0D0E);

  // Timer states
  static const Color timerWork = primary;
  static const Color timerWorkDark = Color(0xFFFF6B6B);
  static const Color timerShortBreak = secondary;
  static const Color timerShortBreakDark = Color(0xFF51CF66);
  static const Color timerLongBreak = Color(0xFF9B59B6);
  static const Color timerLongBreakDark = Color(0xFFAA67E3);
  static const Color timerPaused = grey400;
  static const Color timerPausedDark = Color(0xFF6B7280);

  // Accent colors for dark mode
  static const Color accentOrange = Color(0xFFFF9F43);
  static const Color accentBlue = Color(0xFF5F9BFF);
  static const Color accentPurple = Color(0xFFAA67E3);
  static const Color accentGreen = Color(0xFF51CF66);

  // Border and divider colors
  static const Color dividerLight = grey200;
  static const Color dividerDark = Color(0xFF2E2E2E);

  // Overlay colors
  static const Color overlayLight = Color(0x80000000);
  static const Color overlayDark = Color(0x80000000); // 50% pret
}
