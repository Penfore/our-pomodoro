import 'package:uuid/uuid.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/pomodoro_session.dart';
import '../../domain/entities/pomodoro_settings.dart';
import '../../domain/entities/pomodoro_statistics.dart';
import '../../domain/repositories/pomodoro_repository.dart';
import '../datasources/pomodoro_local_data_source.dart';
import '../models/pomodoro_session_model.dart';
import '../models/pomodoro_settings_model.dart';
import '../models/pomodoro_statistics_model.dart';

class PomodoroRepositoryImpl implements PomodoroRepository {
  final PomodoroLocalDataSource localDataSource;
  final Uuid _uuid = const Uuid();

  PomodoroRepositoryImpl({required this.localDataSource});

  @override
  Future<Result<PomodoroSession>> createSession(
    PomodoroType type,
    int currentSession,
  ) async {
    try {
      final settings = await localDataSource.getSettings();
      final settingsEntity = settings.toEntity();

      int durationMinutes;
      switch (type) {
        case PomodoroType.work:
          durationMinutes = settingsEntity.workMinutes;
          break;
        case PomodoroType.shortBreak:
          durationMinutes = settingsEntity.shortBreakMinutes;
          break;
        case PomodoroType.longBreak:
          durationMinutes = settingsEntity.longBreakMinutes;
          break;
      }

      final session = PomodoroSessionModel(
        id: _uuid.v4(),
        type: type,
        durationMinutes: durationMinutes,
        remainingSeconds: durationMinutes * 60,
        status: PomodoroStatus.initial,
        startedAt: DateTime.now(),
        currentSession: currentSession,
        totalSessions: settingsEntity.sessionsUntilLongBreak,
      );

      await localDataSource.cacheCurrentSession(session);
      return success(session.toEntity());
    } on CacheException {
      return failure(CacheFailure());
    } catch (e) {
      return failure(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Result<PomodoroSession>> updateSession(PomodoroSession session) async {
    try {
      final sessionModel = PomodoroSessionModel.fromEntity(session);
      await localDataSource.cacheCurrentSession(sessionModel);
      return success(session);
    } on CacheException {
      return failure(CacheFailure());
    } catch (e) {
      return failure(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Result<PomodoroSession?>> getCurrentSession() async {
    try {
      final sessionModel = await localDataSource.getCurrentSession();
      return success(sessionModel?.toEntity());
    } on CacheException {
      return failure(CacheFailure());
    } catch (e) {
      return failure(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Result<PomodoroSettings>> getSettings() async {
    try {
      final settingsModel = await localDataSource.getSettings();
      return success(settingsModel.toEntity());
    } on CacheException {
      return failure(CacheFailure());
    } catch (e) {
      return failure(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> updateSettings(PomodoroSettings settings) async {
    try {
      final settingsModel = PomodoroSettingsModel.fromEntity(settings);
      await localDataSource.cacheSettings(settingsModel);
      return success(null);
    } on CacheException {
      return failure(CacheFailure());
    } catch (e) {
      return failure(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Result<PomodoroStatistics>> getStatistics() async {
    try {
      final statisticsModel = await localDataSource.getStatistics();
      return success(statisticsModel.toEntity());
    } on CacheException {
      return failure(CacheFailure());
    } catch (e) {
      return failure(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> updateStatistics(PomodoroStatistics statistics) async {
    try {
      final statisticsModel = PomodoroStatisticsModel.fromEntity(statistics);
      await localDataSource.cacheStatistics(statisticsModel);
      return success(null);
    } on CacheException {
      return failure(CacheFailure());
    } catch (e) {
      return failure(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> incrementCompletedSession(
    PomodoroType type,
    int durationMinutes,
  ) async {
    try {
      final statisticsResult = await getStatistics();
      return statisticsResult.fold((error) => failure(error), (
        statistics,
      ) async {
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);

        final newDailySessions = Map<DateTime, int>.from(
          statistics.dailySessions,
        );
        newDailySessions[today] = (newDailySessions[today] ?? 0) + 1;

        // Calculate streak
        int newCurrentStreak = statistics.currentStreak;
        if (statistics.lastSessionDate != null) {
          final lastSessionDay = DateTime(
            statistics.lastSessionDate!.year,
            statistics.lastSessionDate!.month,
            statistics.lastSessionDate!.day,
          );
          final yesterday = today.subtract(const Duration(days: 1));

          if (lastSessionDay == today) {
            // Same day, keep streak
          } else if (lastSessionDay == yesterday) {
            // Consecutive day, increment streak
            newCurrentStreak++;
          } else {
            // Streak broken, reset to 1
            newCurrentStreak = 1;
          }
        } else {
          // First session ever
          newCurrentStreak = 1;
        }

        final updatedStatistics = statistics.copyWith(
          totalCompletedSessions: statistics.totalCompletedSessions + 1,
          totalFocusTimeMinutes: type == PomodoroType.work
              ? statistics.totalFocusTimeMinutes + durationMinutes
              : statistics.totalFocusTimeMinutes,
          totalBreakTimeMinutes: type != PomodoroType.work
              ? statistics.totalBreakTimeMinutes + durationMinutes
              : statistics.totalBreakTimeMinutes,
          currentStreak: newCurrentStreak,
          longestStreak: newCurrentStreak > statistics.longestStreak
              ? newCurrentStreak
              : statistics.longestStreak,
          lastSessionDate: now,
          dailySessions: newDailySessions,
        );

        return await updateStatistics(updatedStatistics);
      });
    } catch (e) {
      return failure(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> clearCurrentSession() async {
    try {
      await localDataSource.clearCurrentSession();
      return success(null);
    } on CacheException {
      return failure(CacheFailure());
    } catch (e) {
      return failure(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> clearAllData() async {
    try {
      await localDataSource.clearAllData();
      return success(null);
    } on CacheException {
      return failure(CacheFailure());
    } catch (e) {
      return failure(UnexpectedFailure(e.toString()));
    }
  }
}
