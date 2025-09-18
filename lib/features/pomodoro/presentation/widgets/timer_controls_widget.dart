import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:our_pomodoro/core/utils/dialog_utils.dart';

import '../bloc/pomodoro_bloc.dart';
import '../bloc/pomodoro_event.dart';
import '../bloc/pomodoro_state.dart';

class TimerControlsWidget extends StatelessWidget {
  const TimerControlsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PomodoroBloc, PomodoroState>(
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (state is PomodoroInitial) ...[
              _buildStartMessage(),
            ] else if (state is PomodoroLoading) ...[
              const CircularProgressIndicator(),
            ] else if (state is PomodoroRunning) ...[
              _buildRunningControls(context),
            ] else if (state is PomodoroPaused) ...[
              _buildPausedControls(context),
            ] else if (state is PomodoroCompleted) ...[
              _buildCompletedControls(context),
            ] else if (state is PomodoroError) ...[
              _buildErrorState(context, state.message),
            ],
          ],
        );
      },
    );
  }

  Widget _buildStartMessage() {
    return Column(
      children: [
        Icon(Icons.play_circle_outline, size: 64, color: Colors.grey.shade400),
        const SizedBox(height: 16),
        Text(
          'Escolha um tipo de sessão\npara começar',
          style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildRunningControls(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Pause button
        Flexible(
          child: ElevatedButton.icon(
            onPressed: () {
              context.read<PomodoroBloc>().add(PausePomodoroEvent());
            },
            icon: const Icon(Icons.pause),
            label: const Text('Pausar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange.shade400,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Reset button
        Flexible(
          child: ElevatedButton.icon(
            onPressed: () {
              DialogUtils.showResetConfirmation(context);
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Resetar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade400,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPausedControls(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Resume button
        Flexible(
          child: ElevatedButton.icon(
            onPressed: () {
              context.read<PomodoroBloc>().add(ResumePomodoroEvent());
            },
            icon: const Icon(Icons.play_arrow),
            label: const Text('Continuar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade400,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Reset button
        Flexible(
          child: ElevatedButton.icon(
            onPressed: () {
              DialogUtils.showResetConfirmation(context);
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Resetar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade400,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompletedControls(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () {
            context.read<PomodoroBloc>().add(ResetPomodoroEvent());
          },
          icon: const Icon(Icons.refresh),
          label: const Text('Nova Sessão'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade400,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Column(
      children: [
        Icon(Icons.error_outline, size: 48, color: Colors.red.shade400),
        const SizedBox(height: 16),
        Text(
          message,
          style: TextStyle(fontSize: 16, color: Colors.red.shade600),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () {
            context.read<PomodoroBloc>().add(ResetPomodoroEvent());
          },
          icon: const Icon(Icons.refresh),
          label: const Text('Tentar Novamente'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade400,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
        ),
      ],
    );
  }
}
