import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/pomodoro_session.dart';
import '../repositories/pomodoro_repository.dart';

class StartPomodoroSession
    implements UseCase<PomodoroSession, StartPomodoroSessionParams> {
  final PomodoroRepository repository;

  StartPomodoroSession(this.repository);

  @override
  Future<Result<PomodoroSession>> call(
    StartPomodoroSessionParams params,
  ) async {
    return await repository.createSession(params.type, params.currentSession);
  }
}

class StartPomodoroSessionParams extends Equatable {
  final PomodoroType type;
  final int currentSession;

  const StartPomodoroSessionParams({
    required this.type,
    required this.currentSession,
  });

  @override
  List<Object> get props => [type, currentSession];
}
