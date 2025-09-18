import 'package:equatable/equatable.dart';

import '../../domain/entities/pomodoro_session.dart';

abstract class PomodoroEvent extends Equatable {
  const PomodoroEvent();

  @override
  List<Object?> get props => [];
}

class StartPomodoroEvent extends PomodoroEvent {
  final PomodoroType type;
  final int currentSession;

  const StartPomodoroEvent({required this.type, required this.currentSession});

  @override
  List<Object> get props => [type, currentSession];
}

class PausePomodoroEvent extends PomodoroEvent {}

class ResumePomodoroEvent extends PomodoroEvent {}

class ResetPomodoroEvent extends PomodoroEvent {}

class SkipPomodoroEvent extends PomodoroEvent {}

class TickPomodoroEvent extends PomodoroEvent {
  final int remainingSeconds;

  const TickPomodoroEvent({required this.remainingSeconds});

  @override
  List<Object> get props => [remainingSeconds];
}

class CompletePomodoroEvent extends PomodoroEvent {}

class LoadCurrentSessionEvent extends PomodoroEvent {}
