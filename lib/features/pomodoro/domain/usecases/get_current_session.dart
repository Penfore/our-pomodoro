import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/pomodoro_session.dart';
import '../repositories/pomodoro_repository.dart';

class GetCurrentSession implements UseCase<PomodoroSession?, NoParams> {
  final PomodoroRepository repository;

  GetCurrentSession(this.repository);

  @override
  Future<Either<Failure, PomodoroSession?>> call(NoParams params) async {
    return await repository.getCurrentSession();
  }
}
