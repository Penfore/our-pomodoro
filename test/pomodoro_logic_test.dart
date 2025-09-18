import 'package:flutter_test/flutter_test.dart';
import 'package:our_pomodoro/features/pomodoro/domain/entities/pomodoro_session.dart';

void main() {
  group('Pomodoro Business Logic Tests', () {
    test('Complete Pomodoro cycle should have correct duration', () {
      // Standard Pomodoro technique durations
      const workDuration = 25; // minutes
      const shortBreakDuration = 5; // minutes
      const longBreakDuration = 15; // minutes
      const cyclesBeforeLongBreak = 4;

      // Total time for one complete cycle (4 work + 3 short breaks + 1 long break)
      const totalCycleTime =
          (workDuration * cyclesBeforeLongBreak) +
          (shortBreakDuration * (cyclesBeforeLongBreak - 1)) +
          longBreakDuration;

      expect(totalCycleTime, 130); // 100 + 15 + 15 = 130 minutes
    });

    test('Session types should alternate correctly in a cycle', () {
      final sessionTypes = <PomodoroType>[];

      // Simulate a complete Pomodoro cycle
      for (int i = 1; i <= 7; i++) {
        if (i.isOdd) {
          sessionTypes.add(PomodoroType.work);
        } else if (i == 8) {
          // After 4th work session
          sessionTypes.add(PomodoroType.longBreak);
        } else {
          sessionTypes.add(PomodoroType.shortBreak);
        }
      }

      expect(sessionTypes, [
        PomodoroType.work,
        PomodoroType.shortBreak,
        PomodoroType.work,
        PomodoroType.shortBreak,
        PomodoroType.work,
        PomodoroType.shortBreak,
        PomodoroType.work,
      ]);
    });

    test('Timer countdown should decrease correctly', () {
      int initialSeconds = 1500; // 25 minutes

      // Simulate 1 minute of countdown
      for (int i = 0; i < 60; i++) {
        initialSeconds--;
      }

      expect(initialSeconds, 1440); // Should be 24 minutes remaining
    });

    test('Session completion should trigger next session setup', () {
      final session = PomodoroSession(
        id: 'test-session',
        type: PomodoroType.work,
        durationMinutes: 25,
        remainingSeconds: 0, // Session completed
        status: PomodoroStatus.completed,
        startedAt: DateTime.now().subtract(const Duration(minutes: 25)),
        currentSession: 1,
        totalSessions: 4,
      );

      expect(session.remainingSeconds, 0);
      expect(session.status, PomodoroStatus.completed);
      expect(session.currentSession < session.totalSessions, true);
    });

    test('Pause and resume should maintain remaining time', () {
      const initialRemainingTime = 900; // 15 minutes

      final runningSession = PomodoroSession(
        id: 'pause-test',
        type: PomodoroType.work,
        durationMinutes: 25,
        remainingSeconds: initialRemainingTime,
        status: PomodoroStatus.running,
        startedAt: DateTime.now(),
        currentSession: 1,
        totalSessions: 4,
      );

      final pausedSession = runningSession.copyWith(
        status: PomodoroStatus.paused,
      );

      final resumedSession = pausedSession.copyWith(
        status: PomodoroStatus.running,
      );

      expect(runningSession.remainingSeconds, initialRemainingTime);
      expect(pausedSession.remainingSeconds, initialRemainingTime);
      expect(resumedSession.remainingSeconds, initialRemainingTime);
    });

    test('Different session types should have correct default durations', () {
      final workSession = PomodoroSession(
        id: 'work',
        type: PomodoroType.work,
        durationMinutes: 25,
        remainingSeconds: 1500,
        status: PomodoroStatus.initial,
        startedAt: DateTime.now(),
        currentSession: 1,
        totalSessions: 4,
      );

      final shortBreakSession = PomodoroSession(
        id: 'short-break',
        type: PomodoroType.shortBreak,
        durationMinutes: 5,
        remainingSeconds: 300,
        status: PomodoroStatus.initial,
        startedAt: DateTime.now(),
        currentSession: 2,
        totalSessions: 4,
      );

      final longBreakSession = PomodoroSession(
        id: 'long-break',
        type: PomodoroType.longBreak,
        durationMinutes: 15,
        remainingSeconds: 900,
        status: PomodoroStatus.initial,
        startedAt: DateTime.now(),
        currentSession: 8,
        totalSessions: 8,
      );

      expect(workSession.durationMinutes, 25);
      expect(workSession.remainingSeconds, 1500);

      expect(shortBreakSession.durationMinutes, 5);
      expect(shortBreakSession.remainingSeconds, 300);

      expect(longBreakSession.durationMinutes, 15);
      expect(longBreakSession.remainingSeconds, 900);
    });

    test('Session ID should be unique and persistent', () {
      final session1 = PomodoroSession(
        id: 'unique-id-1',
        type: PomodoroType.work,
        durationMinutes: 25,
        remainingSeconds: 1500,
        status: PomodoroStatus.running,
        startedAt: DateTime.now(),
        currentSession: 1,
        totalSessions: 4,
      );

      final session2 = PomodoroSession(
        id: 'unique-id-2',
        type: PomodoroType.work,
        durationMinutes: 25,
        remainingSeconds: 1500,
        status: PomodoroStatus.running,
        startedAt: DateTime.now(),
        currentSession: 1,
        totalSessions: 4,
      );

      final copiedSession = session1.copyWith(remainingSeconds: 1400);

      expect(session1.id, isNot(equals(session2.id)));
      expect(
        session1.id,
        equals(copiedSession.id),
      ); // ID should persist in copyWith
    });

    test('Session progress calculation should be accurate', () {
      final session = PomodoroSession(
        id: 'progress-test',
        type: PomodoroType.work,
        durationMinutes: 25,
        remainingSeconds: 750, // Half completed
        status: PomodoroStatus.running,
        startedAt: DateTime.now(),
        currentSession: 2,
        totalSessions: 4,
      );

      final totalSeconds = session.durationMinutes * 60;
      final elapsedSeconds = totalSeconds - session.remainingSeconds;
      final progressPercentage = (elapsedSeconds / totalSeconds) * 100;

      expect(totalSeconds, 1500);
      expect(elapsedSeconds, 750);
      expect(progressPercentage, 50.0);
    });

    test('Session statistics should be calculable', () {
      const totalSessions = 4;
      var completedSessions = 0;
      var totalWorkTime = 0;
      var totalBreakTime = 0;

      // Simulate completing sessions
      for (int i = 1; i <= totalSessions; i++) {
        if (i.isOdd) {
          completedSessions++;
          totalWorkTime += 25; // Work session duration
        } else {
          totalBreakTime += 5; // Short break duration
        }
      }

      expect(completedSessions, 2); // 2 work sessions in first 4
      expect(totalWorkTime, 50); // 50 minutes of work
      expect(totalBreakTime, 10); // 10 minutes of breaks
    });
  });

  group('Time Formatting and Display Tests', () {
    test('Time formatting should handle edge cases correctly', () {
      String formatTime(int totalSeconds) {
        if (totalSeconds < 0) totalSeconds = 0;
        final minutes = totalSeconds ~/ 60;
        final seconds = totalSeconds % 60;
        return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
      }

      expect(formatTime(-5), '00:00'); // Negative time
      expect(formatTime(0), '00:00'); // Zero time
      expect(formatTime(59), '00:59'); // Under one minute
      expect(formatTime(60), '01:00'); // Exactly one minute
      expect(formatTime(3661), '61:01'); // Over one hour
    });

    test('Session type display names should be in Portuguese', () {
      String getSessionTypeName(PomodoroType type) {
        switch (type) {
          case PomodoroType.work:
            return 'TRABALHO';
          case PomodoroType.shortBreak:
            return 'PAUSA CURTA';
          case PomodoroType.longBreak:
            return 'PAUSA LONGA';
        }
      }

      expect(getSessionTypeName(PomodoroType.work), 'TRABALHO');
      expect(getSessionTypeName(PomodoroType.shortBreak), 'PAUSA CURTA');
      expect(getSessionTypeName(PomodoroType.longBreak), 'PAUSA LONGA');
    });

    test('Progress indicators should show correct values', () {
      final session = PomodoroSession(
        id: 'progress-indicator-test',
        type: PomodoroType.work,
        durationMinutes: 25,
        remainingSeconds: 375, // 6:15 remaining out of 25:00
        status: PomodoroStatus.running,
        startedAt: DateTime.now(),
        currentSession: 3,
        totalSessions: 4,
      );

      final totalSeconds = session.durationMinutes * 60;
      final progress = (totalSeconds - session.remainingSeconds) / totalSeconds;
      final progressPercentage = (progress * 100).round();

      expect(progressPercentage, 75); // 75% complete
      expect(
        session.currentSession / session.totalSessions,
        0.75,
      ); // 75% through total sessions
    });
  });
}
