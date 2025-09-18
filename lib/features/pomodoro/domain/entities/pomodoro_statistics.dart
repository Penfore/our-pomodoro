import 'package:equatable/equatable.dart';

class PomodoroStatistics extends Equatable {
  final int totalCompletedSessions;
  final int totalFocusTimeMinutes;
  final int totalBreakTimeMinutes;
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastSessionDate;
  final Map<DateTime, int> dailySessions;

  const PomodoroStatistics({
    required this.totalCompletedSessions,
    required this.totalFocusTimeMinutes,
    required this.totalBreakTimeMinutes,
    required this.currentStreak,
    required this.longestStreak,
    this.lastSessionDate,
    required this.dailySessions,
  });

  PomodoroStatistics copyWith({
    int? totalCompletedSessions,
    int? totalFocusTimeMinutes,
    int? totalBreakTimeMinutes,
    int? currentStreak,
    int? longestStreak,
    DateTime? lastSessionDate,
    Map<DateTime, int>? dailySessions,
  }) {
    return PomodoroStatistics(
      totalCompletedSessions:
          totalCompletedSessions ?? this.totalCompletedSessions,
      totalFocusTimeMinutes:
          totalFocusTimeMinutes ?? this.totalFocusTimeMinutes,
      totalBreakTimeMinutes:
          totalBreakTimeMinutes ?? this.totalBreakTimeMinutes,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastSessionDate: lastSessionDate ?? this.lastSessionDate,
      dailySessions: dailySessions ?? this.dailySessions,
    );
  }

  factory PomodoroStatistics.empty() {
    return const PomodoroStatistics(
      totalCompletedSessions: 0,
      totalFocusTimeMinutes: 0,
      totalBreakTimeMinutes: 0,
      currentStreak: 0,
      longestStreak: 0,
      lastSessionDate: null,
      dailySessions: {},
    );
  }

  String get totalFocusTimeFormatted {
    final hours = totalFocusTimeMinutes ~/ 60;
    final minutes = totalFocusTimeMinutes % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}min';
    }
    return '${minutes}min';
  }

  int get todaySessions {
    final today = DateTime.now();
    final todayKey = DateTime(today.year, today.month, today.day);
    return dailySessions[todayKey] ?? 0;
  }

  @override
  List<Object?> get props => [
    totalCompletedSessions,
    totalFocusTimeMinutes,
    totalBreakTimeMinutes,
    currentStreak,
    longestStreak,
    lastSessionDate,
    dailySessions,
  ];
}
