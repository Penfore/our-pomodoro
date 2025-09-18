import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:our_pomodoro/core/theme/app_colors.dart';

import '../../features/pomodoro/presentation/bloc/pomodoro_bloc.dart';
import '../../features/pomodoro/presentation/bloc/pomodoro_event.dart';

class DialogUtils {
  static void showResetConfirmation(BuildContext context) {
    final pomodoroBloc = context.read<PomodoroBloc>();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Resetar Timer', textAlign: TextAlign.center),
          content: const Text(
            'Tem certeza que deseja resetar o timer? Todo o progresso será perdido.',
            textAlign: TextAlign.center,
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.grey400, foregroundColor: AppColors.textLight),
              child: const Text('Cancelar'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                pomodoroBloc.add(ResetPomodoroEvent());
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: AppColors.textLight),
              child: const Text('Resetar'),
            ),
          ],
        );
      },
    );
  }
}
