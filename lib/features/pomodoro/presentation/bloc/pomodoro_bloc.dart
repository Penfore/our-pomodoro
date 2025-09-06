import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/pomodoro_session.dart';
import '../../domain/usecases/clear_current_session.dart';
import '../../domain/usecases/get_current_session.dart';
import '../../domain/usecases/start_pomodoro_session.dart';
import '../../domain/usecases/update_pomodoro_session.dart';
import 'pomodoro_event.dart';
import 'pomodoro_state.dart';

class PomodoroBloc extends Bloc<PomodoroEvent, PomodoroState> {
  final StartPomodoroSession startPomodoroSession;
  final UpdatePomodoroSession updatePomodoroSession;
  final GetCurrentSession getCurrentSession;
  final ClearCurrentSession clearCurrentSession;

  Timer? _timer;
  PomodoroSession? _currentSession;

  PomodoroBloc({
    required this.startPomodoroSession,
    required this.updatePomodoroSession,
    required this.getCurrentSession,
    required this.clearCurrentSession,
  }) : super(PomodoroInitial()) {
    on<StartPomodoroEvent>(_onStartPomodoro);
    on<PausePomodoroEvent>(_onPausePomodoro);
    on<ResumePomodoroEvent>(_onResumePomodoro);
    on<ResetPomodoroEvent>(_onResetPomodoro);
    on<TickPomodoroEvent>(_onTickPomodoro);
    on<CompletePomodoroEvent>(_onCompletePomodoro);
    on<LoadCurrentSessionEvent>(_onLoadCurrentSession);
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentSession != null && _currentSession!.remainingSeconds > 0) {
        add(TickPomodoroEvent(remainingSeconds: _currentSession!.remainingSeconds - 1));
      } else {
        add(CompletePomodoroEvent());
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  Future<void> _onStartPomodoro(StartPomodoroEvent event, Emitter<PomodoroState> emit) async {
    emit(PomodoroLoading());

    final result = await startPomodoroSession(StartPomodoroSessionParams(type: event.type, currentSession: event.currentSession));

    result.fold((failure) => emit(PomodoroError(message: _mapFailureToMessage(failure))), (session) {
      _currentSession = session.copyWith(status: PomodoroStatus.running);
      emit(PomodoroRunning(session: _currentSession!));
      _startTimer();
      _updateSessionInRepository();
    });
  }

  Future<void> _onPausePomodoro(PausePomodoroEvent event, Emitter<PomodoroState> emit) async {
    if (_currentSession != null) {
      _stopTimer();
      _currentSession = _currentSession!.copyWith(status: PomodoroStatus.paused);
      emit(PomodoroPaused(session: _currentSession!));
      await _updateSessionInRepository();
    }
  }

  Future<void> _onResumePomodoro(ResumePomodoroEvent event, Emitter<PomodoroState> emit) async {
    if (_currentSession != null && _currentSession!.status == PomodoroStatus.paused) {
      _currentSession = _currentSession!.copyWith(status: PomodoroStatus.running);
      emit(PomodoroRunning(session: _currentSession!));
      _startTimer();
      await _updateSessionInRepository();
    }
  }

  Future<void> _onResetPomodoro(ResetPomodoroEvent event, Emitter<PomodoroState> emit) async {
    _stopTimer();

    // Clear current session from repository
    await clearCurrentSession(NoParams());

    _currentSession = null;
    emit(PomodoroInitial());
  }

  Future<void> _onTickPomodoro(TickPomodoroEvent event, Emitter<PomodoroState> emit) async {
    if (_currentSession != null) {
      _currentSession = _currentSession!.copyWith(remainingSeconds: event.remainingSeconds);

      if (event.remainingSeconds <= 0) {
        _stopTimer();
        _currentSession = _currentSession!.copyWith(
          status: PomodoroStatus.completed,
          remainingSeconds: 0,
          completedAt: DateTime.now(),
        );
        emit(PomodoroCompleted(session: _currentSession!));
      } else {
        emit(PomodoroRunning(session: _currentSession!));
      }

      await _updateSessionInRepository();
    }
  }

  Future<void> _onCompletePomodoro(CompletePomodoroEvent event, Emitter<PomodoroState> emit) async {
    if (_currentSession != null) {
      _stopTimer();
      _currentSession = _currentSession!.copyWith(
        status: PomodoroStatus.completed,
        remainingSeconds: 0,
        completedAt: DateTime.now(),
      );
      emit(PomodoroCompleted(session: _currentSession!));
      await _updateSessionInRepository();
    }
  }

  Future<void> _onLoadCurrentSession(LoadCurrentSessionEvent event, Emitter<PomodoroState> emit) async {
    emit(PomodoroLoading());

    final result = await getCurrentSession(NoParams());
    result.fold((failure) => emit(PomodoroError(message: _mapFailureToMessage(failure))), (session) {
      if (session != null) {
        _currentSession = session;

        switch (session.status) {
          case PomodoroStatus.initial:
            emit(PomodoroInitial());
            break;
          case PomodoroStatus.running:
            emit(PomodoroRunning(session: session));
            _startTimer();
            break;
          case PomodoroStatus.paused:
            emit(PomodoroPaused(session: session));
            break;
          case PomodoroStatus.completed:
            emit(PomodoroCompleted(session: session));
            break;
        }
      } else {
        emit(PomodoroInitial());
      }
    });
  }

  Future<void> _updateSessionInRepository() async {
    if (_currentSession != null) {
      await updatePomodoroSession(UpdatePomodoroSessionParams(session: _currentSession!));
    }
  }

  String _mapFailureToMessage(dynamic failure) {
    // Map specific failure types to user-friendly error messages
    return 'An error occurred. Please try again.';
  }
}
