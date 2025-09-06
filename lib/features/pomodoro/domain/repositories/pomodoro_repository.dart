import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/pomodoro_session.dart';
import '../entities/pomodoro_settings.dart';
import '../entities/pomodoro_statistics.dart';

abstract class PomodoroRepository {
  // Session Management
  Future<Either<Failure, PomodoroSession>> createSession(PomodoroType type, int currentSession);
  Future<Either<Failure, PomodoroSession>> updateSession(PomodoroSession session);
  Future<Either<Failure, PomodoroSession?>> getCurrentSession();

  // Settings Management
  Future<Either<Failure, PomodoroSettings>> getSettings();
  Future<Either<Failure, void>> updateSettings(PomodoroSettings settings);

  // Statistics Management
  Future<Either<Failure, PomodoroStatistics>> getStatistics();
  Future<Either<Failure, void>> updateStatistics(PomodoroStatistics statistics);
  Future<Either<Failure, void>> incrementCompletedSession(PomodoroType type, int durationMinutes);

  // Data Management
  Future<Either<Failure, void>> clearAllData();
}
