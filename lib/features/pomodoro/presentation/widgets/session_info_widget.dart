import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/theme_extensions.dart';
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
              color: context.isDarkMode
                  ? Colors.black.withValues(alpha: 0.3)
                  : Colors.black.withValues(alpha: 0.1),
              blurRadius: context.isDarkMode ? 12 : 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.timeline, size: 20, color: context.textPrimary),
            const SizedBox(width: 8),
            Text(
              'Sessão $currentSession de $totalSessions',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: context.textPrimary,
              ),
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
      return Builder(
        builder: (context) => Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(
                Icons.access_time,
                size: 32,
                color: context.timerPausedColor,
              ),
              const SizedBox(height: 8),
              Text(
                'Aguardando início da sessão',
                style: TextStyle(fontSize: 14, color: context.textTertiary),
              ),
            ],
          ),
        ),
      );
    }

    final session = (state as dynamic).session as PomodoroSession;

    return Builder(
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSessionDot(
                  context,
                  0,
                  session.currentSession,
                  session.totalSessions,
                ),
                _buildSessionDot(
                  context,
                  1,
                  session.currentSession,
                  session.totalSessions,
                ),
                _buildSessionDot(
                  context,
                  2,
                  session.currentSession,
                  session.totalSessions,
                ),
                _buildSessionDot(
                  context,
                  3,
                  session.currentSession,
                  session.totalSessions,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              _getProgressMessage(session),
              style: TextStyle(fontSize: 12, color: context.textTertiary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionDot(
    BuildContext context,
    int index,
    int currentSession,
    int totalSessions,
  ) {
    final workSessionsCompleted = (currentSession - 1).clamp(0, totalSessions);

    final isCompleted = index < workSessionsCompleted;
    final isCurrent =
        index == workSessionsCompleted && workSessionsCompleted < totalSessions;

    Color dotColor;
    if (isCompleted) {
      dotColor = context.timerShortBreakColor;
    } else if (isCurrent) {
      dotColor = context.timerLongBreakColor;
    } else {
      dotColor = context.adaptiveColor(
        light: Colors.grey.shade300,
        dark: Colors.grey.shade700,
      );
    }

    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: dotColor,
        border: isCurrent
            ? Border.all(color: context.timerLongBreakColor, width: 2)
            : null,
        boxShadow: context.isDarkMode && (isCompleted || isCurrent)
            ? [
                BoxShadow(
                  color: dotColor.withValues(alpha: 0.4),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ]
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
