import 'package:equatable/equatable.dart';

class PomodoroSettings extends Equatable {
  final int workMinutes;
  final int shortBreakMinutes;
  final int longBreakMinutes;
  final int sessionsUntilLongBreak;
  final bool soundEnabled;
  final bool notificationsEnabled;
  final bool autoStartBreaks;
  final bool autoStartWorkSessions;

  const PomodoroSettings({
    required this.workMinutes,
    required this.shortBreakMinutes,
    required this.longBreakMinutes,
    required this.sessionsUntilLongBreak,
    required this.soundEnabled,
    required this.notificationsEnabled,
    required this.autoStartBreaks,
    required this.autoStartWorkSessions,
  });

  PomodoroSettings copyWith({
    int? workMinutes,
    int? shortBreakMinutes,
    int? longBreakMinutes,
    int? sessionsUntilLongBreak,
    bool? soundEnabled,
    bool? notificationsEnabled,
    bool? autoStartBreaks,
    bool? autoStartWorkSessions,
  }) {
    return PomodoroSettings(
      workMinutes: workMinutes ?? this.workMinutes,
      shortBreakMinutes: shortBreakMinutes ?? this.shortBreakMinutes,
      longBreakMinutes: longBreakMinutes ?? this.longBreakMinutes,
      sessionsUntilLongBreak: sessionsUntilLongBreak ?? this.sessionsUntilLongBreak,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      autoStartBreaks: autoStartBreaks ?? this.autoStartBreaks,
      autoStartWorkSessions: autoStartWorkSessions ?? this.autoStartWorkSessions,
    );
  }

  factory PomodoroSettings.defaultSettings() {
    return const PomodoroSettings(
      workMinutes: 25,
      shortBreakMinutes: 5,
      longBreakMinutes: 15,
      sessionsUntilLongBreak: 4,
      soundEnabled: true,
      notificationsEnabled: true,
      autoStartBreaks: false,
      autoStartWorkSessions: false,
    );
  }

  @override
  List<Object> get props => [
    workMinutes,
    shortBreakMinutes,
    longBreakMinutes,
    sessionsUntilLongBreak,
    soundEnabled,
    notificationsEnabled,
    autoStartBreaks,
    autoStartWorkSessions,
  ];
}
