import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/pomodoro_statistics.dart';
import '../repositories/pomodoro_repository.dart';

class GetPomodoroStatistics implements UseCase<PomodoroStatistics, NoParams> {
  final PomodoroRepository repository;

  GetPomodoroStatistics(this.repository);

  @override
  Future<Either<Failure, PomodoroStatistics>> call(NoParams params) async {
    return await repository.getStatistics();
  }
}
