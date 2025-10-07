import 'package:equatable/equatable.dart';

enum PomodoroType { work, shortBreak, longBreak }

enum PomodoroStatus { initial, running, paused, completed }

class PomodoroSession extends Equatable {
  final String id;
  final PomodoroType type;
  final int durationMinutes;
  final int remainingSeconds;
  final PomodoroStatus status;
  final DateTime startedAt;
  final DateTime? completedAt;
  final DateTime? lastResumedAt;
  final int currentSession;
  final int totalSessions;

  const PomodoroSession({
    required this.id,
    required this.type,
    required this.durationMinutes,
    required this.remainingSeconds,
    required this.status,
    required this.startedAt,
    this.completedAt,
    this.lastResumedAt,
    required this.currentSession,
    required this.totalSessions,
  });

  PomodoroSession copyWith({
    String? id,
    PomodoroType? type,
    int? durationMinutes,
    int? remainingSeconds,
    PomodoroStatus? status,
    DateTime? startedAt,
    DateTime? completedAt,
    DateTime? lastResumedAt,
    int? currentSession,
    int? totalSessions,
  }) {
    return PomodoroSession(
      id: id ?? this.id,
      type: type ?? this.type,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      status: status ?? this.status,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      lastResumedAt: lastResumedAt ?? this.lastResumedAt,
      currentSession: currentSession ?? this.currentSession,
      totalSessions: totalSessions ?? this.totalSessions,
    );
  }

  double get progress {
    final totalSeconds = durationMinutes * 60;
    final elapsedSeconds = totalSeconds - remainingSeconds;
    return elapsedSeconds / totalSeconds;
  }

  String get formattedTime {
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  bool get isCompleted => status == PomodoroStatus.completed;
  bool get isRunning => status == PomodoroStatus.running;
  bool get isPaused => status == PomodoroStatus.paused;

  PomodoroSession recalculateRemainingTime() {
    if (status != PomodoroStatus.running || lastResumedAt == null) {
      return this;
    }

    final now = DateTime.now();
    final totalElapsedSeconds = now.difference(startedAt).inSeconds;
    final totalDurationSeconds = durationMinutes * 60;

    final newRemainingSeconds = (totalDurationSeconds - totalElapsedSeconds)
        .clamp(0, totalDurationSeconds);

    return copyWith(remainingSeconds: newRemainingSeconds, lastResumedAt: now);
  }

  @override
  List<Object?> get props => [
    id,
    type,
    durationMinutes,
    remainingSeconds,
    status,
    startedAt,
    completedAt,
    lastResumedAt,
    currentSession,
    totalSessions,
  ];
}
