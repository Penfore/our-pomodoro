import 'package:equatable/equatable.dart';

import '../../domain/entities/pomodoro_session.dart';

abstract class PomodoroState extends Equatable {
  const PomodoroState();

  @override
  List<Object?> get props => [];
}

class PomodoroInitial extends PomodoroState {}

class PomodoroLoading extends PomodoroState {}

class PomodoroRunning extends PomodoroState {
  final PomodoroSession session;

  const PomodoroRunning({required this.session});

  @override
  List<Object> get props => [session];
}

class PomodoroPaused extends PomodoroState {
  final PomodoroSession session;

  const PomodoroPaused({required this.session});

  @override
  List<Object> get props => [session];
}

class PomodoroCompleted extends PomodoroState {
  final PomodoroSession session;

  const PomodoroCompleted({required this.session});

  @override
  List<Object> get props => [session];
}

class PomodoroError extends PomodoroState {
  final String message;

  const PomodoroError({required this.message});

  @override
  List<Object> get props => [message];
}
