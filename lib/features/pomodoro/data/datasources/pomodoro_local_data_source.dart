import 'dart:convert';

import '../../../../core/error/exceptions.dart';
import '../../../../core/platform/local_data_source.dart';
import '../../domain/entities/pomodoro_settings.dart';
import '../../domain/entities/pomodoro_statistics.dart';
import '../models/pomodoro_session_model.dart';
import '../models/pomodoro_settings_model.dart';
import '../models/pomodoro_statistics_model.dart';

abstract class PomodoroLocalDataSource {
  Future<PomodoroSessionModel?> getCurrentSession();
  Future<void> cacheCurrentSession(PomodoroSessionModel session);
  Future<void> clearCurrentSession();

  Future<PomodoroSettingsModel> getSettings();
  Future<void> cacheSettings(PomodoroSettingsModel settings);

  Future<PomodoroStatisticsModel> getStatistics();
  Future<void> cacheStatistics(PomodoroStatisticsModel statistics);

  Future<void> clearAllData();
}

class PomodoroLocalDataSourceImpl implements PomodoroLocalDataSource {
  final LocalDataSource localDataSource;

  static const String currentSessionKey = 'current_pomodoro_session';
  static const String settingsKey = 'pomodoro_settings';
  static const String statisticsKey = 'pomodoro_statistics';

  PomodoroLocalDataSourceImpl({required this.localDataSource});

  @override
  Future<PomodoroSessionModel?> getCurrentSession() async {
    try {
      final sessionJson = await localDataSource.getString(currentSessionKey);
      if (sessionJson != null) {
        final sessionMap = json.decode(sessionJson) as Map<String, dynamic>;
        return PomodoroSessionModel.fromJson(sessionMap);
      }
      return null;
    } catch (e) {
      throw CacheException('Failed to get current session: $e');
    }
  }

  @override
  Future<void> cacheCurrentSession(PomodoroSessionModel session) async {
    try {
      final sessionJson = json.encode(session.toJson());
      await localDataSource.setString(currentSessionKey, sessionJson);
    } catch (e) {
      throw CacheException('Failed to cache current session: $e');
    }
  }

  @override
  Future<void> clearCurrentSession() async {
    try {
      await localDataSource.remove(currentSessionKey);
    } catch (e) {
      throw CacheException('Failed to clear current session: $e');
    }
  }

  @override
  Future<PomodoroSettingsModel> getSettings() async {
    try {
      final settingsJson = await localDataSource.getString(settingsKey);
      if (settingsJson != null) {
        final settingsMap = json.decode(settingsJson) as Map<String, dynamic>;
        return PomodoroSettingsModel.fromJson(settingsMap);
      }
      // Return default settings if none cached
      return PomodoroSettingsModel.fromEntity(
        const PomodoroSettings(
          workMinutes: 25,
          shortBreakMinutes: 5,
          longBreakMinutes: 15,
          sessionsUntilLongBreak: 4,
          soundEnabled: true,
          notificationsEnabled: true,
          autoStartBreaks: false,
          autoStartWorkSessions: false,
        ),
      );
    } catch (e) {
      throw CacheException('Failed to get settings: $e');
    }
  }

  @override
  Future<void> cacheSettings(PomodoroSettingsModel settings) async {
    try {
      final settingsJson = json.encode(settings.toJson());
      await localDataSource.setString(settingsKey, settingsJson);
    } catch (e) {
      throw CacheException('Failed to cache settings: $e');
    }
  }

  @override
  Future<PomodoroStatisticsModel> getStatistics() async {
    try {
      final statisticsJson = await localDataSource.getString(statisticsKey);
      if (statisticsJson != null) {
        final statisticsMap =
            json.decode(statisticsJson) as Map<String, dynamic>;
        return PomodoroStatisticsModel.fromJson(statisticsMap);
      }
      // Return empty statistics if none cached
      return PomodoroStatisticsModel.fromEntity(PomodoroStatistics.empty());
    } catch (e) {
      throw CacheException('Failed to get statistics: $e');
    }
  }

  @override
  Future<void> cacheStatistics(PomodoroStatisticsModel statistics) async {
    try {
      final statisticsJson = json.encode(statistics.toJson());
      await localDataSource.setString(statisticsKey, statisticsJson);
    } catch (e) {
      throw CacheException('Failed to cache statistics: $e');
    }
  }

  @override
  Future<void> clearAllData() async {
    try {
      await localDataSource.remove(currentSessionKey);
      await localDataSource.remove(settingsKey);
      await localDataSource.remove(statisticsKey);
    } catch (e) {
      throw CacheException('Failed to clear all data: $e');
    }
  }
}
