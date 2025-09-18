import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/pomodoro_session.dart';
import '../bloc/pomodoro_bloc.dart';
import '../bloc/pomodoro_state.dart';

class SessionInfoWidget extends StatelessWidget {
  const SessionInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PomodoroBloc, PomodoroState>(
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSessionCounter(state),
            const SizedBox(height: 16),
            _buildProgressIndicator(state),
          ],
        );
      },
    );
  }

  Widget _buildSessionCounter(PomodoroState state) {
    int currentSession = 1;
    int totalSessions = 4;

    if (state is PomodoroRunning ||
        state is PomodoroPaused ||
        state is PomodoroCompleted) {
      final session = (state as dynamic).session as PomodoroSession;
      currentSession = session.currentSession;
      totalSessions = session.totalSessions;
    }

    return Builder(
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.timeline, size: 20),
            const SizedBox(width: 8),
            Text(
              'Sessão $currentSession de $totalSessions',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(PomodoroState state) {
    if (state is! PomodoroRunning &&
        state is! PomodoroPaused &&
        state is! PomodoroCompleted) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(Icons.access_time, size: 32, color: Colors.grey.shade400),
            const SizedBox(height: 8),
            Text(
              'Aguardando início da sessão',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    final session = (state as dynamic).session as PomodoroSession;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSessionDot(
                0,
                session.currentSession,
                session.totalSessions,
              ),
              _buildSessionDot(
                1,
                session.currentSession,
                session.totalSessions,
              ),
              _buildSessionDot(
                2,
                session.currentSession,
                session.totalSessions,
              ),
              _buildSessionDot(
                3,
                session.currentSession,
                session.totalSessions,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _getProgressMessage(session),
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSessionDot(int index, int currentSession, int totalSessions) {
    final isActive = index < currentSession;
    final isCurrent = index == currentSession - 1;

    Color dotColor;
    if (isActive && !isCurrent) {
      dotColor = Colors.green.shade400; // Completed sessions
    } else if (isCurrent) {
      dotColor = Colors.blue.shade400; // Current session
    } else {
      dotColor = Colors.grey.shade300; // Future sessions
    }

    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: dotColor,
        border: isCurrent
            ? Border.all(color: Colors.blue.shade600, width: 2)
            : null,
      ),
    );
  }

  String _getProgressMessage(PomodoroSession session) {
    if (session.isCompleted) {
      if (session.currentSession >= session.totalSessions) {
        return 'Parabéns! Você completou todas as sessões hoje! 🎉';
      } else {
        return 'Sessão concluída! Pronto para a próxima? 💪';
      }
    } else if (session.isPaused) {
      return 'Timer pausado. Continue quando estiver pronto! ⏸️';
    } else if (session.isRunning) {
      final typeMessage = session.type == PomodoroType.work
          ? 'Foco total! Você consegue! 🎯'
          : 'Aproveite sua pausa merecida! ☕';
      return typeMessage;
    }

    return 'Pronto para começar uma nova sessão!';
  }
}
