class AppConstants {
  // App Info
  static const String appName = 'Our Pomodoro';
  static const String appVersion = '1.0.0';

  // Pomodoro Timer Constants
  static const int pomodoroMinutes = 25;
  static const int shortBreakMinutes = 5;
  static const int longBreakMinutes = 15;
  static const int sessionsUntilLongBreak = 4;

  // Local Storage Keys
  static const String pomodoroSettingsKey = 'pomodoro_settings';
  static const String totalSessionsKey = 'total_sessions';
  static const String totalFocusTimeKey = 'total_focus_time';
  static const String isFirstLaunchKey = 'is_first_launch';
  static const String soundEnabledKey = 'sound_enabled';
  static const String notificationsEnabledKey = 'notifications_enabled';

  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 300);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 500);
  static const Duration longAnimationDuration = Duration(milliseconds: 800);

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  static const double buttonHeight = 56.0;
}
