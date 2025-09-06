import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/pomodoro_session.dart';
import '../repositories/pomodoro_repository.dart';

class UpdatePomodoroSession implements UseCase<PomodoroSession, UpdatePomodoroSessionParams> {
  final PomodoroRepository repository;

  UpdatePomodoroSession(this.repository);

  @override
  Future<Either<Failure, PomodoroSession>> call(UpdatePomodoroSessionParams params) async {
    return await repository.updateSession(params.session);
  }
}

class UpdatePomodoroSessionParams extends Equatable {
  final PomodoroSession session;

  const UpdatePomodoroSessionParams({required this.session});

  @override
  List<Object> get props => [session];
}
