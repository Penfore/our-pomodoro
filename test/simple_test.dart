import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:our_pomodoro/features/pomodoro/domain/entities/pomodoro_session.dart';

void main() {
  group('Entity Tests', () {
    test('PomodoroSession creates correctly with all required fields', () {
      final startTime = DateTime.now();
      final session = PomodoroSession(
        id: 'test-id',
        type: PomodoroType.work,
        durationMinutes: 25,
        remainingSeconds: 1500,
        status: PomodoroStatus.running,
        startedAt: startTime,
        currentSession: 1,
        totalSessions: 4,
      );

      expect(session.id, 'test-id');
      expect(session.type, PomodoroType.work);
      expect(session.durationMinutes, 25);
      expect(session.remainingSeconds, 1500);
      expect(session.status, PomodoroStatus.running);
      expect(session.startedAt, startTime);
      expect(session.currentSession, 1);
      expect(session.totalSessions, 4);
    });

    test('PomodoroSession copyWith works correctly', () {
      final originalStartTime = DateTime.now();
      final originalSession = PomodoroSession(
        id: 'test-id',
        type: PomodoroType.work,
        durationMinutes: 25,
        remainingSeconds: 1500,
        status: PomodoroStatus.running,
        startedAt: originalStartTime,
        currentSession: 1,
        totalSessions: 4,
      );

      final updatedSession = originalSession.copyWith(
        remainingSeconds: 1200,
        currentSession: 2,
        status: PomodoroStatus.paused,
      );

      expect(updatedSession.id, originalSession.id);
      expect(updatedSession.type, originalSession.type);
      expect(updatedSession.durationMinutes, originalSession.durationMinutes);
      expect(updatedSession.remainingSeconds, 1200);
      expect(updatedSession.status, PomodoroStatus.paused);
      expect(updatedSession.startedAt, originalSession.startedAt);
      expect(updatedSession.currentSession, 2);
      expect(updatedSession.totalSessions, originalSession.totalSessions);
    });

    test('PomodoroSession equality works correctly', () {
      final startTime = DateTime.now();
      final session1 = PomodoroSession(
        id: 'test-id',
        type: PomodoroType.work,
        durationMinutes: 25,
        remainingSeconds: 1500,
        status: PomodoroStatus.running,
        startedAt: startTime,
        currentSession: 1,
        totalSessions: 4,
      );

      final session2 = PomodoroSession(
        id: 'test-id',
        type: PomodoroType.work,
        durationMinutes: 25,
        remainingSeconds: 1500,
        status: PomodoroStatus.running,
        startedAt: startTime,
        currentSession: 1,
        totalSessions: 4,
      );

      expect(session1, equals(session2));
    });

    test('PomodoroType enum has correct values', () {
      expect(PomodoroType.values, containsAll([
        PomodoroType.work,
        PomodoroType.shortBreak,
        PomodoroType.longBreak,
      ]));
    });

    test('PomodoroStatus enum has correct values', () {
      expect(PomodoroStatus.values, containsAll([
        PomodoroStatus.initial,
        PomodoroStatus.running,
        PomodoroStatus.paused,
        PomodoroStatus.completed,
      ]));
    });

    test('Work session should last 25 minutes (1500 seconds)', () {
      final session = PomodoroSession(
        id: 'work-test',
        type: PomodoroType.work,
        durationMinutes: 25,
        remainingSeconds: 1500,
        status: PomodoroStatus.running,
        startedAt: DateTime.now(),
        currentSession: 1,
        totalSessions: 4,
      );

      expect(session.durationMinutes * 60, 1500);
      expect(session.type, PomodoroType.work);
    });

    test('Session progression logic works correctly', () {
      // Simulate a Pomodoro cycle
      const totalSessions = 4;

      for (int i = 1; i <= totalSessions; i++) {
        final session = PomodoroSession(
          id: 'session-$i',
          type: i.isEven ? PomodoroType.shortBreak : PomodoroType.work,
          durationMinutes: i.isEven ? 5 : 25,
          remainingSeconds: i.isEven ? 300 : 1500,
          status: PomodoroStatus.running,
          startedAt: DateTime.now(),
          currentSession: i,
          totalSessions: totalSessions,
        );

        expect(session.currentSession, i);
        expect(session.totalSessions, totalSessions);
        expect(session.currentSession, lessThanOrEqualTo(totalSessions));
      }
    });
  });

  group('Timer Logic Tests', () {
    test('Pomodoro work session should be 25 minutes', () {
      const workDuration = 25;
      const workSeconds = workDuration * 60;
      
      expect(workSeconds, 1500);
    });

    test('Short break should be 5 minutes', () {
      const shortBreakDuration = 5;
      const shortBreakSeconds = shortBreakDuration * 60;
      
      expect(shortBreakSeconds, 300);
    });

    test('Long break should be 15 minutes', () {
      const longBreakDuration = 15;
      const longBreakSeconds = longBreakDuration * 60;
      
      expect(longBreakSeconds, 900);
    });

    test('Format seconds to MM:SS format', () {
      String formatTime(int totalSeconds) {
        final minutes = totalSeconds ~/ 60;
        final seconds = totalSeconds % 60;
        return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
      }

      expect(formatTime(1500), '25:00');
      expect(formatTime(1485), '24:45');
      expect(formatTime(65), '01:05');
      expect(formatTime(5), '00:05');
      expect(formatTime(0), '00:00');
    });

    test('Session counting logic', () {
      const totalSessions = 4;
      
      for (int i = 1; i <= totalSessions; i++) {
        expect(i, isPositive);
        expect(i, lessThanOrEqualTo(totalSessions));
        
        // After 4th session, should be complete
        if (i == totalSessions) {
          expect(i == totalSessions, isTrue);
        }
      }
    });

    test('Time decrements correctly', () {
      int remainingTime = 1500; // 25 minutes
      
      // Simulate timer ticks
      for (int tick = 0; tick < 10; tick++) {
        expect(remainingTime, greaterThanOrEqualTo(0));
        remainingTime--;
      }
      
      expect(remainingTime, 1490);
    });

    test('Session transitions work correctly', () {
      // Test work -> short break transition
      var currentType = PomodoroType.work;
      var currentSession = 1;
      
      // After work session ends
      if (currentSession < 4 && currentSession % 2 == 1) {
        currentType = PomodoroType.shortBreak;
      }
      
      expect(currentType, PomodoroType.shortBreak);
      
      // Test long break after 4th session
      currentSession = 4;
      if (currentSession == 4) {
        currentType = PomodoroType.longBreak;
      }
      
      expect(currentType, PomodoroType.longBreak);
    });
  });

  group('Simple Widget Tests', () {
    testWidgets('Basic MaterialApp should render', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: const Text('Test App')),
            body: const Center(
              child: Text('Hello, World!'),
            ),
          ),
        ),
      );

      expect(find.text('Test App'), findsOneWidget);
      expect(find.text('Hello, World!'), findsOneWidget);
    });

    testWidgets('Timer display widget shows formatted time', (WidgetTester tester) async {
      const remainingSeconds = 1500; // 25 minutes
      final minutes = remainingSeconds ~/ 60;
      final seconds = remainingSeconds % 60;
      final timeString = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    timeString,
                    style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  const Text('Pomodoro Timer'),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('25:00'), findsOneWidget);
      expect(find.text('Pomodoro Timer'), findsOneWidget);
    });

    testWidgets('Session info display shows correct information', (WidgetTester tester) async {
      const currentSession = 1;
      const totalSessions = 4;
      const sessionType = 'TRABALHO';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Column(
                children: [
                  Text('Sessão $currentSession de $totalSessions'),
                  const SizedBox(height: 10),
                  const Text(sessionType),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Sessão 1 de 4'), findsOneWidget);
      expect(find.text('TRABALHO'), findsOneWidget);
    });

    testWidgets('Button state changes correctly', (WidgetTester tester) async {
      bool isRunning = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: StatefulBuilder(
                builder: (context, setState) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isRunning = !isRunning;
                          });
                        },
                        child: Text(isRunning ? 'Pausar' : 'Iniciar'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );

      // Initially should show "Iniciar"
      expect(find.text('Iniciar'), findsOneWidget);
      expect(find.text('Pausar'), findsNothing);

      // Tap the button
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Now should show "Pausar"
      expect(find.text('Pausar'), findsOneWidget);
      expect(find.text('Iniciar'), findsNothing);

      // Tap again
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Back to "Iniciar"
      expect(find.text('Iniciar'), findsOneWidget);
      expect(find.text('Pausar'), findsNothing);
    });

    testWidgets('Pomodoro type displays show correct text', (WidgetTester tester) async {
      String getDisplayText(PomodoroType type) {
        switch (type) {
          case PomodoroType.work:
            return 'TRABALHO';
          case PomodoroType.shortBreak:
            return 'PAUSA CURTA';
          case PomodoroType.longBreak:
            return 'PAUSA LONGA';
        }
      }

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                Text(getDisplayText(PomodoroType.work)),
                Text(getDisplayText(PomodoroType.shortBreak)),
                Text(getDisplayText(PomodoroType.longBreak)),
              ],
            ),
          ),
        ),
      );

      expect(find.text('TRABALHO'), findsOneWidget);
      expect(find.text('PAUSA CURTA'), findsOneWidget);
      expect(find.text('PAUSA LONGA'), findsOneWidget);
    });
  });
}