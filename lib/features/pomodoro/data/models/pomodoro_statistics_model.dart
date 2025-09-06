import '../../domain/entities/pomodoro_statistics.dart';

class PomodoroStatisticsModel {
  final int totalCompletedSessions;
  final int totalFocusTimeMinutes;
  final int totalBreakTimeMinutes;
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastSessionDate;
  final Map<DateTime, int> dailySessions;

  const PomodoroStatisticsModel({
    required this.totalCompletedSessions,
    required this.totalFocusTimeMinutes,
    required this.totalBreakTimeMinutes,
    required this.currentStreak,
    required this.longestStreak,
    this.lastSessionDate,
    required this.dailySessions,
  });

  factory PomodoroStatisticsModel.fromEntity(PomodoroStatistics entity) {
    return PomodoroStatisticsModel(
      totalCompletedSessions: entity.totalCompletedSessions,
      totalFocusTimeMinutes: entity.totalFocusTimeMinutes,
      totalBreakTimeMinutes: entity.totalBreakTimeMinutes,
      currentStreak: entity.currentStreak,
      longestStreak: entity.longestStreak,
      lastSessionDate: entity.lastSessionDate,
      dailySessions: entity.dailySessions,
    );
  }

  PomodoroStatistics toEntity() {
    return PomodoroStatistics(
      totalCompletedSessions: totalCompletedSessions,
      totalFocusTimeMinutes: totalFocusTimeMinutes,
      totalBreakTimeMinutes: totalBreakTimeMinutes,
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      lastSessionDate: lastSessionDate,
      dailySessions: dailySessions,
    );
  }

  factory PomodoroStatisticsModel.fromJson(Map<String, dynamic> json) {
    final dailySessionsJson = json['dailySessions'] as Map<String, dynamic>? ?? {};
    final dailySessions = <DateTime, int>{};

    for (final entry in dailySessionsJson.entries) {
      dailySessions[DateTime.parse(entry.key)] = entry.value as int;
    }

    return PomodoroStatisticsModel(
      totalCompletedSessions: json['totalCompletedSessions'] ?? 0,
      totalFocusTimeMinutes: json['totalFocusTimeMinutes'] ?? 0,
      totalBreakTimeMinutes: json['totalBreakTimeMinutes'] ?? 0,
      currentStreak: json['currentStreak'] ?? 0,
      longestStreak: json['longestStreak'] ?? 0,
      lastSessionDate: json['lastSessionDate'] != null ? DateTime.parse(json['lastSessionDate']) : null,
      dailySessions: dailySessions,
    );
  }

  Map<String, dynamic> toJson() {
    final dailySessionsJson = <String, int>{};
    for (final entry in dailySessions.entries) {
      dailySessionsJson[entry.key.toIso8601String()] = entry.value;
    }

    return {
      'totalCompletedSessions': totalCompletedSessions,
      'totalFocusTimeMinutes': totalFocusTimeMinutes,
      'totalBreakTimeMinutes': totalBreakTimeMinutes,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'lastSessionDate': lastSessionDate?.toIso8601String(),
      'dailySessions': dailySessionsJson,
    };
  }

  PomodoroStatisticsModel copyWith({
    int? totalCompletedSessions,
    int? totalFocusTimeMinutes,
    int? totalBreakTimeMinutes,
    int? currentStreak,
    int? longestStreak,
    DateTime? lastSessionDate,
    Map<DateTime, int>? dailySessions,
  }) {
    return PomodoroStatisticsModel(
      totalCompletedSessions: totalCompletedSessions ?? this.totalCompletedSessions,
      totalFocusTimeMinutes: totalFocusTimeMinutes ?? this.totalFocusTimeMinutes,
      totalBreakTimeMinutes: totalBreakTimeMinutes ?? this.totalBreakTimeMinutes,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastSessionDate: lastSessionDate ?? this.lastSessionDate,
      dailySessions: dailySessions ?? this.dailySessions,
    );
  }
}
