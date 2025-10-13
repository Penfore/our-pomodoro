import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/utils/dialog_utils.dart';
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
    return Builder(
      builder: (context) => Column(
        children: [
          Icon(
            Icons.play_circle_outline,
            size: 64,
            color: context.timerPausedColor,
          ),
          const SizedBox(height: 16),
          Text(
            'Escolha um tipo de sessão\npara começar',
            style: TextStyle(fontSize: 16, color: context.textTertiary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRunningControls(BuildContext context) {
    return Column(
      children: [
        Row(
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
                  backgroundColor: AppColors.accentOrange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Reset button
            Flexible(
              child: OutlinedButton.icon(
                onPressed: () {
                  DialogUtils.showResetConfirmation(context);
                },
                icon: const Icon(Icons.replay),
                label: const Text('Reiniciar'),
                style: OutlinedButton.styleFrom(
                  backgroundColor: context.adaptiveColor(
                    light: Colors.white,
                    dark: Colors.transparent,
                  ),
                  foregroundColor: context.timerPausedColor,
                  side: BorderSide(color: context.timerPausedColor),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Skip button
        SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: ElevatedButton.icon(
              onPressed: () {
                DialogUtils.showSkipConfirmation(context);
              },
              icon: const Icon(Icons.skip_next),
              label: const Text('Pular Sessão'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPausedControls(BuildContext context) {
    return Column(
      children: [
        Row(
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
                  backgroundColor: context.timerShortBreakColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Reset button
            Flexible(
              child: ElevatedButton.icon(
                onPressed: () {
                  DialogUtils.showResetConfirmation(context);
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Resetar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.timerPausedColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Skip button
        SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: ElevatedButton.icon(
              onPressed: () {
                DialogUtils.showSkipConfirmation(context);
              },
              icon: const Icon(Icons.skip_next),
              label: const Text('Pular Sessão'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
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
            backgroundColor: context.timerLongBreakColor,
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
        Icon(
          Icons.error_outline,
          size: 48,
          color: Theme.of(context).colorScheme.error,
        ),
        const SizedBox(height: 16),
        Text(
          message,
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.error,
          ),
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
            backgroundColor: Theme.of(context).colorScheme.error,
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
}
