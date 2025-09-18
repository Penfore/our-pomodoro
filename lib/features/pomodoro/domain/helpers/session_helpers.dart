import '../entities/pomodoro_session.dart';

class SessionHelpers {
  static PomodoroType getNextSessionType(
    int currentSession,
    PomodoroType currentType,
  ) {
    if (currentType == PomodoroType.work) {
      if (currentSession % 4 == 0) {
        return PomodoroType.longBreak;
      } else {
        return PomodoroType.shortBreak;
      }
    } else {
      return PomodoroType.work;
    }
  }

  static int getNextSessionNumber(
    int currentSession,
    PomodoroType currentType,
    int totalSessions,
  ) {
    if (currentType == PomodoroType.work) {
      return currentSession;
    } else {
      return currentSession + 1;
    }
  }

  static bool isLastSession(int currentSession, int totalSessions) {
    return currentSession >= totalSessions;
  }

  static bool shouldEndCycle(
    int currentSession,
    PomodoroType currentType,
    int totalSessions,
  ) {
    if (currentType == PomodoroType.longBreak &&
        currentSession == totalSessions) {
      return true;
    }

    if (currentType != PomodoroType.work && currentSession >= totalSessions) {
      return true;
    }

    return false;
  }

  static int getCompletedWorkSessions(
    int currentSession,
    PomodoroType currentType,
    int totalSessions,
  ) {
    if (currentType == PomodoroType.work) {
      return currentSession - 1;
    } else {
      return currentSession.clamp(0, totalSessions);
    }
  }
}
