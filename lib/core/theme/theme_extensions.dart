import 'package:flutter/material.dart';

import 'app_colors.dart';

extension ThemeExtensions on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  Color get textPrimary =>
      isDarkMode ? AppColors.textDarkPrimary : AppColors.textPrimary;

  Color get textSecondary =>
      isDarkMode ? AppColors.textDarkSecondary : AppColors.textSecondary;

  Color get textTertiary =>
      isDarkMode ? AppColors.textDarkTertiary : AppColors.grey500;

  Color get surface => isDarkMode ? AppColors.surfaceDark : AppColors.surface;

  Color get surfaceElevated =>
      isDarkMode ? AppColors.surfaceDark2 : AppColors.grey50;

  Color get timerWorkColor =>
      isDarkMode ? AppColors.timerWorkDark : AppColors.timerWork;

  Color get timerShortBreakColor =>
      isDarkMode ? AppColors.timerShortBreakDark : AppColors.timerShortBreak;

  Color get timerLongBreakColor =>
      isDarkMode ? AppColors.timerLongBreakDark : AppColors.timerLongBreak;

  Color get timerPausedColor =>
      isDarkMode ? AppColors.timerPausedDark : AppColors.timerPaused;

  Color get dividerColor =>
      isDarkMode ? AppColors.dividerDark : AppColors.dividerLight;

  Color adaptiveColor({required Color light, required Color dark}) {
    return isDarkMode ? dark : light;
  }
}

extension ColorExtensions on Color {
  Color lighten([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final lightness = (hsl.lightness + amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }

  Color darken([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final lightness = (hsl.lightness - amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }

  Color withSaturation(double saturation) {
    assert(saturation >= 0 && saturation <= 1);
    final hsl = HSLColor.fromColor(this);
    return hsl.withSaturation(saturation).toColor();
  }
}
