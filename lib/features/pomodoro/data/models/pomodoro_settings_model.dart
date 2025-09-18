import '../../domain/entities/pomodoro_settings.dart';

class PomodoroSettingsModel {
  final int workMinutes;
  final int shortBreakMinutes;
  final int longBreakMinutes;
  final int sessionsUntilLongBreak;
  final bool soundEnabled;
  final bool notificationsEnabled;
  final bool autoStartBreaks;
  final bool autoStartWorkSessions;

  const PomodoroSettingsModel({
    required this.workMinutes,
    required this.shortBreakMinutes,
    required this.longBreakMinutes,
    required this.sessionsUntilLongBreak,
    required this.soundEnabled,
    required this.notificationsEnabled,
    required this.autoStartBreaks,
    required this.autoStartWorkSessions,
  });

  factory PomodoroSettingsModel.fromEntity(PomodoroSettings entity) {
    return PomodoroSettingsModel(
      workMinutes: entity.workMinutes,
      shortBreakMinutes: entity.shortBreakMinutes,
      longBreakMinutes: entity.longBreakMinutes,
      sessionsUntilLongBreak: entity.sessionsUntilLongBreak,
      soundEnabled: entity.soundEnabled,
      notificationsEnabled: entity.notificationsEnabled,
      autoStartBreaks: entity.autoStartBreaks,
      autoStartWorkSessions: entity.autoStartWorkSessions,
    );
  }

  PomodoroSettings toEntity() {
    return PomodoroSettings(
      workMinutes: workMinutes,
      shortBreakMinutes: shortBreakMinutes,
      longBreakMinutes: longBreakMinutes,
      sessionsUntilLongBreak: sessionsUntilLongBreak,
      soundEnabled: soundEnabled,
      notificationsEnabled: notificationsEnabled,
      autoStartBreaks: autoStartBreaks,
      autoStartWorkSessions: autoStartWorkSessions,
    );
  }

  factory PomodoroSettingsModel.fromJson(Map<String, dynamic> json) {
    return PomodoroSettingsModel(
      workMinutes: json['workMinutes'],
      shortBreakMinutes: json['shortBreakMinutes'],
      longBreakMinutes: json['longBreakMinutes'],
      sessionsUntilLongBreak: json['sessionsUntilLongBreak'],
      soundEnabled: json['soundEnabled'],
      notificationsEnabled: json['notificationsEnabled'],
      autoStartBreaks: json['autoStartBreaks'],
      autoStartWorkSessions: json['autoStartWorkSessions'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'workMinutes': workMinutes,
      'shortBreakMinutes': shortBreakMinutes,
      'longBreakMinutes': longBreakMinutes,
      'sessionsUntilLongBreak': sessionsUntilLongBreak,
      'soundEnabled': soundEnabled,
      'notificationsEnabled': notificationsEnabled,
      'autoStartBreaks': autoStartBreaks,
      'autoStartWorkSessions': autoStartWorkSessions,
    };
  }

  PomodoroSettingsModel copyWith({
    int? workMinutes,
    int? shortBreakMinutes,
    int? longBreakMinutes,
    int? sessionsUntilLongBreak,
    bool? soundEnabled,
    bool? notificationsEnabled,
    bool? autoStartBreaks,
    bool? autoStartWorkSessions,
  }) {
    return PomodoroSettingsModel(
      workMinutes: workMinutes ?? this.workMinutes,
      shortBreakMinutes: shortBreakMinutes ?? this.shortBreakMinutes,
      longBreakMinutes: longBreakMinutes ?? this.longBreakMinutes,
      sessionsUntilLongBreak:
          sessionsUntilLongBreak ?? this.sessionsUntilLongBreak,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      autoStartBreaks: autoStartBreaks ?? this.autoStartBreaks,
      autoStartWorkSessions:
          autoStartWorkSessions ?? this.autoStartWorkSessions,
    );
  }
}
