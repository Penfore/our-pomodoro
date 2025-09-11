import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart' as di;
import '../../domain/entities/pomodoro_session.dart';
import '../bloc/pomodoro_bloc.dart';
import '../bloc/pomodoro_event.dart';
import '../bloc/pomodoro_state.dart';
import '../widgets/pomodoro_timer_widget.dart';
import '../widgets/session_info_widget.dart';
import '../widgets/timer_controls_widget.dart';

class TimerScreen extends StatelessWidget {
  const TimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<PomodoroBloc>()..add(LoadCurrentSessionEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            '🍅 Our Pomodoro',
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 20),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          actions: [
            BlocBuilder<PomodoroBloc, PomodoroState>(
              builder: (context, state) {
                if (state is PomodoroInitial) return const SizedBox.shrink();
                return IconButton(
                  onPressed: () {
                    _showResetConfirmation(context);
                  },
                  icon: const Icon(Icons.refresh, color: Colors.black54),
                  tooltip: 'Resetar Timer',
                );
              },
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // Session info
                SizedBox(height: 160, child: const SessionInfoWidget()),
                const SizedBox(height: 48),
                // Timer widget
                SizedBox(height: 340, child: const PomodoroTimerWidget()),
                const SizedBox(height: 24),
                // Controls
                Container(height: 140, padding: const EdgeInsets.symmetric(horizontal: 16), child: const TimerControlsWidget()),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
        floatingActionButton: const _SessionTypeSelector(),
      ),
    );
  }

  void _showResetConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Resetar Timer'),
          content: const Text('Tem certeza que deseja resetar o timer? Todo o progresso será perdido.'),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancelar')),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<PomodoroBloc>().add(ResetPomodoroEvent());
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade400, foregroundColor: Colors.white),
              child: const Text('Resetar'),
            ),
          ],
        );
      },
    );
  }
}

class _SessionTypeSelector extends StatelessWidget {
  const _SessionTypeSelector();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PomodoroBloc, PomodoroState>(
      builder: (context, state) {
        // Only show selector when timer is not running
        if (state is PomodoroRunning) {
          return const SizedBox.shrink();
        }

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton.extended(
              onPressed: () => _startSession(context, PomodoroType.work),
              backgroundColor: Colors.red.shade400,
              icon: const Icon(Icons.work),
              label: const Text('Trabalho'),
            ),
            const SizedBox(width: 8),
            FloatingActionButton.small(
              onPressed: () => _startSession(context, PomodoroType.shortBreak),
              backgroundColor: Colors.green.shade400,
              child: const Icon(Icons.coffee),
            ),
            const SizedBox(width: 8),
            FloatingActionButton.small(
              onPressed: () => _startSession(context, PomodoroType.longBreak),
              backgroundColor: Colors.blue.shade400,
              child: const Icon(Icons.spa),
            ),
          ],
        );
      },
    );
  }

  void _startSession(BuildContext context, PomodoroType type) {
    final bloc = context.read<PomodoroBloc>();
    bloc.add(StartPomodoroEvent(type: type, currentSession: 1));
  }
}
