import '../../domain/entities/pomodoro_session.dart';

class PomodoroSessionModel {
  final String id;
  final PomodoroType type;
  final int durationMinutes;
  final int remainingSeconds;
  final PomodoroStatus status;
  final DateTime startedAt;
  final DateTime? completedAt;
  final int currentSession;
  final int totalSessions;

  const PomodoroSessionModel({
    required this.id,
    required this.type,
    required this.durationMinutes,
    required this.remainingSeconds,
    required this.status,
    required this.startedAt,
    this.completedAt,
    required this.currentSession,
    required this.totalSessions,
  });

  factory PomodoroSessionModel.fromEntity(PomodoroSession entity) {
    return PomodoroSessionModel(
      id: entity.id,
      type: entity.type,
      durationMinutes: entity.durationMinutes,
      remainingSeconds: entity.remainingSeconds,
      status: entity.status,
      startedAt: entity.startedAt,
      completedAt: entity.completedAt,
      currentSession: entity.currentSession,
      totalSessions: entity.totalSessions,
    );
  }

  PomodoroSession toEntity() {
    return PomodoroSession(
      id: id,
      type: type,
      durationMinutes: durationMinutes,
      remainingSeconds: remainingSeconds,
      status: status,
      startedAt: startedAt,
      completedAt: completedAt,
      currentSession: currentSession,
      totalSessions: totalSessions,
    );
  }

  factory PomodoroSessionModel.fromJson(Map<String, dynamic> json) {
    return PomodoroSessionModel(
      id: json['id'],
      type: PomodoroType.values[json['type']],
      durationMinutes: json['durationMinutes'],
      remainingSeconds: json['remainingSeconds'],
      status: PomodoroStatus.values[json['status']],
      startedAt: DateTime.parse(json['startedAt']),
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
      currentSession: json['currentSession'],
      totalSessions: json['totalSessions'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.index,
      'durationMinutes': durationMinutes,
      'remainingSeconds': remainingSeconds,
      'status': status.index,
      'startedAt': startedAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'currentSession': currentSession,
      'totalSessions': totalSessions,
    };
  }

  PomodoroSessionModel copyWith({
    String? id,
    PomodoroType? type,
    int? durationMinutes,
    int? remainingSeconds,
    PomodoroStatus? status,
    DateTime? startedAt,
    DateTime? completedAt,
    int? currentSession,
    int? totalSessions,
  }) {
    return PomodoroSessionModel(
      id: id ?? this.id,
      type: type ?? this.type,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      status: status ?? this.status,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      currentSession: currentSession ?? this.currentSession,
      totalSessions: totalSessions ?? this.totalSessions,
    );
  }
}
