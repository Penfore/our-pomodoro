import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/audio_service.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/pomodoro_session.dart';
import '../../domain/helpers/session_helpers.dart';
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
  final AudioService audioService;
  final NotificationService notificationService;

  Timer? _timer;
  PomodoroSession? _currentSession;

  PomodoroBloc({
    required this.startPomodoroSession,
    required this.updatePomodoroSession,
    required this.getCurrentSession,
    required this.clearCurrentSession,
    required this.audioService,
    required this.notificationService,
  }) : super(PomodoroInitial()) {
    on<StartPomodoroEvent>(_onStartPomodoro);
    on<PausePomodoroEvent>(_onPausePomodoro);
    on<ResumePomodoroEvent>(_onResumePomodoro);
    on<ResetPomodoroEvent>(_onResetPomodoro);
    on<SkipPomodoroEvent>(_onSkipPomodoro);
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
        add(const TickPomodoroEvent());
      } else {
        add(CompletePomodoroEvent());
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  Future<void> _onStartPomodoro(
    StartPomodoroEvent event,
    Emitter<PomodoroState> emit,
  ) async {
    emit(PomodoroLoading());

    final result = await startPomodoroSession(
      StartPomodoroSessionParams(
        type: event.type,
        currentSession: event.currentSession,
      ),
    );

    result.fold(
      (failure) => emit(PomodoroError(message: _mapFailureToMessage(failure))),
      (session) async {
        _currentSession = session.copyWith(
          status: PomodoroStatus.running,
          lastResumedAt: DateTime.now(),
        );
        emit(PomodoroRunning(session: _currentSession!));
        _startTimer();
        await _updateSessionInRepository();

        await _scheduleCompletionNotification();
      },
    );
  }

  Future<void> _onPausePomodoro(
    PausePomodoroEvent event,
    Emitter<PomodoroState> emit,
  ) async {
    if (_currentSession != null) {
      _stopTimer();

      await notificationService.cancelScheduledNotification();

      _currentSession = _currentSession!.copyWith(
        status: PomodoroStatus.paused,
      );
      emit(PomodoroPaused(session: _currentSession!));
      await _updateSessionInRepository();
    }
  }

  Future<void> _onResumePomodoro(
    ResumePomodoroEvent event,
    Emitter<PomodoroState> emit,
  ) async {
    if (_currentSession != null &&
        _currentSession!.status == PomodoroStatus.paused) {
      _currentSession = _currentSession!.copyWith(
        status: PomodoroStatus.running,
        lastResumedAt: DateTime.now(),
      );
      emit(PomodoroRunning(session: _currentSession!));
      _startTimer();
      await _updateSessionInRepository();

      await _scheduleCompletionNotification();
    }
  }

  Future<void> _onResetPomodoro(
    ResetPomodoroEvent event,
    Emitter<PomodoroState> emit,
  ) async {
    _stopTimer();

    await notificationService.cancelScheduledNotification();

    await clearCurrentSession(NoParams());

    _currentSession = null;
    emit(PomodoroInitial());
  }

  Future<void> _onSkipPomodoro(
    SkipPomodoroEvent event,
    Emitter<PomodoroState> emit,
  ) async {
    if (_currentSession != null) {
      _stopTimer();

      await notificationService.cancelScheduledNotification();

      await _playCompletionSoundAndNotification();

      _currentSession = _currentSession!.copyWith(
        status: PomodoroStatus.completed,
        remainingSeconds: 0,
        completedAt: DateTime.now(),
      );

      await _updateSessionInRepository();

      final nextSessionType = SessionHelpers.getNextSessionType(
        _currentSession!.currentSession,
        _currentSession!.type,
      );
      final nextSessionNumber = SessionHelpers.getNextSessionNumber(
        _currentSession!.currentSession,
        _currentSession!.type,
        _currentSession!.totalSessions,
      );

      if (SessionHelpers.shouldEndCycle(
        _currentSession!.currentSession,
        _currentSession!.type,
        _currentSession!.totalSessions,
      )) {
        emit(PomodoroCompleted(session: _currentSession!));
        await clearCurrentSession(NoParams());
        _currentSession = null;
        return;
      }

      if (nextSessionNumber > _currentSession!.totalSessions) {
        emit(PomodoroCompleted(session: _currentSession!));
        await clearCurrentSession(NoParams());
        _currentSession = null;
        return;
      }

      final result = await startPomodoroSession(
        StartPomodoroSessionParams(
          type: nextSessionType,
          currentSession: nextSessionNumber,
        ),
      );

      result.fold(
        (failure) =>
            emit(PomodoroError(message: _mapFailureToMessage(failure))),
        (session) async {
          _currentSession = session.copyWith(
            status: PomodoroStatus.running,
            lastResumedAt: DateTime.now(),
          );
          emit(PomodoroRunning(session: _currentSession!));
          _startTimer();
          await _updateSessionInRepository();

          await _scheduleCompletionNotification();
        },
      );
    }
  }

  Future<void> _onTickPomodoro(
    TickPomodoroEvent event,
    Emitter<PomodoroState> emit,
  ) async {
    if (_currentSession != null) {
      _currentSession = _currentSession!.recalculateRemainingTime();

      if (_currentSession!.remainingSeconds <= 0) {
        add(CompletePomodoroEvent());
        return;
      }

      emit(PomodoroRunning(session: _currentSession!));
      await _updateSessionInRepository();
    }
  }

  Future<void> _onCompletePomodoro(
    CompletePomodoroEvent event,
    Emitter<PomodoroState> emit,
  ) async {
    if (_currentSession != null) {
      _stopTimer();

      await notificationService.cancelScheduledNotification();

      await _playCompletionSoundAndNotification();

      _currentSession = _currentSession!.copyWith(
        status: PomodoroStatus.completed,
        remainingSeconds: 0,
        completedAt: DateTime.now(),
      );

      await _updateSessionInRepository();

      final nextSessionType = SessionHelpers.getNextSessionType(
        _currentSession!.currentSession,
        _currentSession!.type,
      );
      final nextSessionNumber = SessionHelpers.getNextSessionNumber(
        _currentSession!.currentSession,
        _currentSession!.type,
        _currentSession!.totalSessions,
      );

      if (SessionHelpers.shouldEndCycle(
        _currentSession!.currentSession,
        _currentSession!.type,
        _currentSession!.totalSessions,
      )) {
        if (_currentSession!.type == PomodoroType.longBreak) {
          await audioService.playSound(SoundType.cycleComplete);
        }

        emit(PomodoroCompleted(session: _currentSession!));
        await clearCurrentSession(NoParams());
        _currentSession = null;
        return;
      }

      if (nextSessionNumber > _currentSession!.totalSessions) {
        emit(PomodoroCompleted(session: _currentSession!));
        await clearCurrentSession(NoParams());
        _currentSession = null;
        return;
      }

      emit(PomodoroCompleted(session: _currentSession!));

      await Future<void>.delayed(const Duration(seconds: 1));

      final result = await startPomodoroSession(
        StartPomodoroSessionParams(
          type: nextSessionType,
          currentSession: nextSessionNumber,
        ),
      );

      result.fold(
        (failure) =>
            emit(PomodoroError(message: _mapFailureToMessage(failure))),
        (session) async {
          _currentSession = session.copyWith(
            status: PomodoroStatus.running,
            lastResumedAt: DateTime.now(),
          );
          emit(PomodoroRunning(session: _currentSession!));
          _startTimer();
          await _updateSessionInRepository();

          await _scheduleCompletionNotification();
        },
      );
    }
  }

  Future<void> _onLoadCurrentSession(
    LoadCurrentSessionEvent event,
    Emitter<PomodoroState> emit,
  ) async {
    emit(PomodoroLoading());

    final result = await getCurrentSession(NoParams());
    result.fold(
      (failure) => emit(PomodoroError(message: _mapFailureToMessage(failure))),
      (session) async {
        if (session != null) {
          _currentSession = session;

          if (session.status == PomodoroStatus.running &&
              session.lastResumedAt != null) {
            _currentSession = session.recalculateRemainingTime();

            if (_currentSession!.remainingSeconds <= 0) {
              await _handleBackgroundCompletion(emit);
              return;
            }
          }

          switch (_currentSession!.status) {
            case PomodoroStatus.initial:
              emit(PomodoroInitial());
              break;
            case PomodoroStatus.running:
              emit(PomodoroRunning(session: _currentSession!));
              _startTimer();
              await _scheduleCompletionNotification();
              break;
            case PomodoroStatus.paused:
              emit(PomodoroPaused(session: _currentSession!));
              break;
            case PomodoroStatus.completed:
              emit(PomodoroCompleted(session: _currentSession!));
              break;
          }
        } else {
          emit(PomodoroInitial());
        }
      },
    );
  }

  Future<void> _handleBackgroundCompletion(Emitter<PomodoroState> emit) async {
    if (_currentSession == null) return;

    await _playCompletionSoundAndNotification();

    _currentSession = _currentSession!.copyWith(
      status: PomodoroStatus.completed,
      remainingSeconds: 0,
      completedAt: DateTime.now(),
    );

    await _updateSessionInRepository();

    final nextSessionType = SessionHelpers.getNextSessionType(
      _currentSession!.currentSession,
      _currentSession!.type,
    );
    final nextSessionNumber = SessionHelpers.getNextSessionNumber(
      _currentSession!.currentSession,
      _currentSession!.type,
      _currentSession!.totalSessions,
    );

    if (SessionHelpers.shouldEndCycle(
      _currentSession!.currentSession,
      _currentSession!.type,
      _currentSession!.totalSessions,
    )) {
      if (_currentSession!.type == PomodoroType.longBreak) {
        await audioService.playSound(SoundType.cycleComplete);
      }

      emit(PomodoroCompleted(session: _currentSession!));
      await clearCurrentSession(NoParams());
      _currentSession = null;
      return;
    }

    if (nextSessionNumber > _currentSession!.totalSessions) {
      emit(PomodoroCompleted(session: _currentSession!));
      await clearCurrentSession(NoParams());
      _currentSession = null;
      return;
    }

    emit(PomodoroCompleted(session: _currentSession!));

    await Future<void>.delayed(const Duration(seconds: 1));

    final result = await startPomodoroSession(
      StartPomodoroSessionParams(
        type: nextSessionType,
        currentSession: nextSessionNumber,
      ),
    );

    result.fold(
      (failure) => emit(PomodoroError(message: _mapFailureToMessage(failure))),
      (session) async {
        _currentSession = session.copyWith(
          status: PomodoroStatus.running,
          lastResumedAt: DateTime.now(),
        );
        emit(PomodoroRunning(session: _currentSession!));
        _startTimer();
        await _updateSessionInRepository();

        await _scheduleCompletionNotification();
      },
    );
  }

  Future<void> _updateSessionInRepository() async {
    if (_currentSession != null) {
      await updatePomodoroSession(
        UpdatePomodoroSessionParams(session: _currentSession!),
      );
    }
  }

  Future<void> _playCompletionSoundAndNotification() async {
    if (_currentSession == null) return;

    final soundType = _getSoundTypeForSession(_currentSession!.type);
    await audioService.playSound(soundType);

    await notificationService.showSessionCompleteNotification(
      _currentSession!.type,
      _currentSession!.currentSession,
    );
  }

  SoundType _getSoundTypeForSession(PomodoroType sessionType) {
    switch (sessionType) {
      case PomodoroType.work:
        return SoundType.sessionComplete;
      case PomodoroType.shortBreak:
      case PomodoroType.longBreak:
        return SoundType.breakComplete;
    }
  }

  String _mapFailureToMessage(dynamic failure) {
    // Map specific failure types to user-friendly error messages
    return 'Ocorreu um erro. Por favor, tente novamente.';
  }

  Future<void> _scheduleCompletionNotification() async {
    if (_currentSession == null) return;

    final completionTime = DateTime.now().add(
      Duration(seconds: _currentSession!.remainingSeconds),
    );

    await notificationService.scheduleSessionCompletionNotification(
      sessionType: _currentSession!.type,
      sessionNumber: _currentSession!.currentSession,
      scheduledTime: completionTime,
    );
  }
}
