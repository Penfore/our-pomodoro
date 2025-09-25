import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/dialog_utils.dart';
import '../../../../injection_container.dart' as service_locator;
import '../../../settings/presentation/pages/settings_screen.dart';
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
      create: (context) =>
          service_locator.sl<PomodoroBloc>()..add(LoadCurrentSessionEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            '🍅 Our Pomodoro',
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.settings, color: Colors.black54),
              tooltip: 'Configurações',
            ),
            BlocBuilder<PomodoroBloc, PomodoroState>(
              builder: (context, state) {
                if (state is PomodoroInitial) return const SizedBox.shrink();
                return IconButton(
                  onPressed: () {
                    DialogUtils.showResetConfirmation(context);
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
                const SizedBox(height: 160, child: SessionInfoWidget()),
                // Timer widget
                const SizedBox(height: 300, child: PomodoroTimerWidget()),
                // Controls
                Container(
                  height: 140,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: const TimerControlsWidget(),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
        floatingActionButton: const _SessionTypeSelector(),
      ),
    );
  }
}

class _SessionTypeSelector extends StatelessWidget {
  const _SessionTypeSelector();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PomodoroBloc, PomodoroState>(
      builder: (context, state) {
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
