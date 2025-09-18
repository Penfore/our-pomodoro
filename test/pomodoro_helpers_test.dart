import 'package:flutter_test/flutter_test.dart';
import 'package:our_pomodoro/features/pomodoro/domain/entities/pomodoro_session.dart';

void main() {
  group('Pomodoro Helper Functions Tests', () {
    test('Should determine next session type correctly', () {
      PomodoroType getNextSessionType(
        int currentSession,
        PomodoroType currentType,
      ) {
        if (currentType == PomodoroType.work) {
          if (currentSession == 4) {
            return PomodoroType.longBreak;
          } else {
            return PomodoroType.shortBreak;
          }
        } else {
          return PomodoroType.work;
        }
      }

      expect(getNextSessionType(1, PomodoroType.work), PomodoroType.shortBreak);
      expect(getNextSessionType(2, PomodoroType.shortBreak), PomodoroType.work);
      expect(getNextSessionType(4, PomodoroType.work), PomodoroType.longBreak);
      expect(getNextSessionType(4, PomodoroType.longBreak), PomodoroType.work);
    });

    test('Should calculate session duration correctly', () {
      int getSessionDuration(PomodoroType type) {
        switch (type) {
          case PomodoroType.work:
            return 25 * 60; // 25 minutes in seconds
          case PomodoroType.shortBreak:
            return 5 * 60; // 5 minutes in seconds
          case PomodoroType.longBreak:
            return 15 * 60; // 15 minutes in seconds
        }
      }

      expect(getSessionDuration(PomodoroType.work), 1500);
      expect(getSessionDuration(PomodoroType.shortBreak), 300);
      expect(getSessionDuration(PomodoroType.longBreak), 900);
    });

    test('Should format remaining time with proper units', () {
      String formatRemainingTime(int seconds) {
        if (seconds <= 0) return 'Concluído';

        final minutes = seconds ~/ 60;
        final remainingSeconds = seconds % 60;

        if (minutes > 0 && remainingSeconds > 0) {
          return '${minutes}m ${remainingSeconds}s restantes';
        } else if (minutes > 0) {
          return '${minutes}m restantes';
        } else {
          return '${remainingSeconds}s restantes';
        }
      }

      expect(formatRemainingTime(1500), '25m restantes');
      expect(formatRemainingTime(65), '1m 5s restantes');
      expect(formatRemainingTime(30), '30s restantes');
      expect(formatRemainingTime(0), 'Concluído');
      expect(formatRemainingTime(-5), 'Concluído');
    });

    test('Should validate session completion correctly', () {
      bool isSessionCompleted(PomodoroSession session) {
        return session.remainingSeconds <= 0 ||
            session.status == PomodoroStatus.completed;
      }

      final completedSession = PomodoroSession(
        id: 'completed',
        type: PomodoroType.work,
        durationMinutes: 25,
        remainingSeconds: 0,
        status: PomodoroStatus.completed,
        startedAt: DateTime.now(),
        currentSession: 1,
        totalSessions: 4,
      );

      final runningSession = PomodoroSession(
        id: 'running',
        type: PomodoroType.work,
        durationMinutes: 25,
        remainingSeconds: 500,
        status: PomodoroStatus.running,
        startedAt: DateTime.now(),
        currentSession: 1,
        totalSessions: 4,
      );

      expect(isSessionCompleted(completedSession), true);
      expect(isSessionCompleted(runningSession), false);
    });

    test('Should calculate total elapsed time correctly', () {
      Duration getElapsedTime(PomodoroSession session) {
        final totalDuration = Duration(minutes: session.durationMinutes);
        final remainingDuration = Duration(seconds: session.remainingSeconds);
        return totalDuration - remainingDuration;
      }

      final session = PomodoroSession(
        id: 'elapsed-test',
        type: PomodoroType.work,
        durationMinutes: 25,
        remainingSeconds: 900, // 15 minutes remaining
        status: PomodoroStatus.running,
        startedAt: DateTime.now(),
        currentSession: 1,
        totalSessions: 4,
      );

      final elapsed = getElapsedTime(session);
      expect(elapsed.inMinutes, 10); // 10 minutes elapsed
      expect(elapsed.inSeconds, 600); // 600 seconds elapsed
    });

    test('Should determine if session needs notification', () {
      bool shouldNotify(PomodoroSession session, int notificationThreshold) {
        return session.remainingSeconds == notificationThreshold &&
            session.status == PomodoroStatus.running;
      }

      final session = PomodoroSession(
        id: 'notification-test',
        type: PomodoroType.work,
        durationMinutes: 25,
        remainingSeconds: 60, // 1 minute remaining
        status: PomodoroStatus.running,
        startedAt: DateTime.now(),
        currentSession: 1,
        totalSessions: 4,
      );

      expect(shouldNotify(session, 60), true); // Should notify at 1 minute
      expect(
        shouldNotify(session, 30),
        false,
      ); // Shouldn't notify at 30 seconds
    });

    test('Should generate unique session IDs', () {
      String generateSessionId() {
        return 'pomodoro_${DateTime.now().millisecondsSinceEpoch}_${(DateTime.now().microsecond * 1000).toString()}';
      }

      final id1 = generateSessionId();
      final id2 = generateSessionId();

      expect(id1, startsWith('pomodoro_'));
      expect(id2, startsWith('pomodoro_'));
      expect(id1, isNot(equals(id2))); // Should be different
    });

    test('Should calculate productivity statistics', () {
      Map<String, dynamic> calculateStats(
        List<PomodoroSession> completedSessions,
      ) {
        int totalWorkSessions = 0;
        int totalBreakSessions = 0;
        int totalWorkMinutes = 0;
        int totalBreakMinutes = 0;

        for (final session in completedSessions) {
          if (session.status == PomodoroStatus.completed) {
            if (session.type == PomodoroType.work) {
              totalWorkSessions++;
              totalWorkMinutes += session.durationMinutes;
            } else {
              totalBreakSessions++;
              totalBreakMinutes += session.durationMinutes;
            }
          }
        }

        return {
          'workSessions': totalWorkSessions,
          'breakSessions': totalBreakSessions,
          'workMinutes': totalWorkMinutes,
          'breakMinutes': totalBreakMinutes,
          'totalSessions': totalWorkSessions + totalBreakSessions,
          'totalMinutes': totalWorkMinutes + totalBreakMinutes,
        };
      }

      final sessions = [
        PomodoroSession(
          id: '1',
          type: PomodoroType.work,
          durationMinutes: 25,
          remainingSeconds: 0,
          status: PomodoroStatus.completed,
          startedAt: DateTime.now(),
          currentSession: 1,
          totalSessions: 4,
        ),
        PomodoroSession(
          id: '2',
          type: PomodoroType.shortBreak,
          durationMinutes: 5,
          remainingSeconds: 0,
          status: PomodoroStatus.completed,
          startedAt: DateTime.now(),
          currentSession: 2,
          totalSessions: 4,
        ),
      ];

      final stats = calculateStats(sessions);
      expect(stats['workSessions'], 1);
      expect(stats['breakSessions'], 1);
      expect(stats['workMinutes'], 25);
      expect(stats['breakMinutes'], 5);
      expect(stats['totalSessions'], 2);
      expect(stats['totalMinutes'], 30);
    });

    test('Should handle session state transitions', () {
      String getActionButtonText(PomodoroSession? session) {
        if (session == null) return 'Iniciar Pomodoro';

        switch (session.status) {
          case PomodoroStatus.initial:
            return 'Iniciar';
          case PomodoroStatus.running:
            return 'Pausar';
          case PomodoroStatus.paused:
            return 'Retomar';
          case PomodoroStatus.completed:
            return 'Próxima Sessão';
        }
      }

      expect(getActionButtonText(null), 'Iniciar Pomodoro');

      final initialSession = PomodoroSession(
        id: 'initial',
        type: PomodoroType.work,
        durationMinutes: 25,
        remainingSeconds: 1500,
        status: PomodoroStatus.initial,
        startedAt: DateTime.now(),
        currentSession: 1,
        totalSessions: 4,
      );

      expect(getActionButtonText(initialSession), 'Iniciar');
      expect(
        getActionButtonText(
          initialSession.copyWith(status: PomodoroStatus.running),
        ),
        'Pausar',
      );
      expect(
        getActionButtonText(
          initialSession.copyWith(status: PomodoroStatus.paused),
        ),
        'Retomar',
      );
      expect(
        getActionButtonText(
          initialSession.copyWith(status: PomodoroStatus.completed),
        ),
        'Próxima Sessão',
      );
    });

    test('Should validate session data integrity', () {
      bool isValidSession(PomodoroSession session) {
        return session.id.isNotEmpty &&
            session.durationMinutes > 0 &&
            session.remainingSeconds >= 0 &&
            session.currentSession > 0 &&
            session.currentSession <= session.totalSessions &&
            session.totalSessions > 0;
      }

      final validSession = PomodoroSession(
        id: 'valid',
        type: PomodoroType.work,
        durationMinutes: 25,
        remainingSeconds: 1500,
        status: PomodoroStatus.running,
        startedAt: DateTime.now(),
        currentSession: 2,
        totalSessions: 4,
      );

      expect(isValidSession(validSession), true);

      // Test invalid scenarios
      expect(isValidSession(validSession.copyWith(id: '')), false);
      expect(isValidSession(validSession.copyWith(durationMinutes: 0)), false);
      expect(
        isValidSession(validSession.copyWith(remainingSeconds: -1)),
        false,
      );
      expect(isValidSession(validSession.copyWith(currentSession: 0)), false);
      expect(
        isValidSession(
          validSession.copyWith(currentSession: 5, totalSessions: 4),
        ),
        false,
      );
    });
  });
}
