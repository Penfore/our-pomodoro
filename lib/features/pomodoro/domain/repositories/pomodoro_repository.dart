import '../../../../core/utils/result.dart';
import '../entities/pomodoro_session.dart';
import '../entities/pomodoro_settings.dart';
import '../entities/pomodoro_statistics.dart';

abstract class PomodoroRepository {
  // Session Management
  Future<Result<PomodoroSession>> createSession(PomodoroType type, int currentSession);
  Future<Result<PomodoroSession>> updateSession(PomodoroSession session);
  Future<Result<PomodoroSession?>> getCurrentSession();

  // Settings Management
  Future<Result<PomodoroSettings>> getSettings();
  Future<Result<void>> updateSettings(PomodoroSettings settings);

  // Statistics Management
  Future<Result<PomodoroStatistics>> getStatistics();
  Future<Result<void>> updateStatistics(PomodoroStatistics statistics);
  Future<Result<void>> incrementCompletedSession(PomodoroType type, int durationMinutes);

  // Data Management
  Future<Result<void>> clearCurrentSession();
  Future<Result<void>> clearAllData();
}
