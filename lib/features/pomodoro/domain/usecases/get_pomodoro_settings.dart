import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/pomodoro_settings.dart';
import '../repositories/pomodoro_repository.dart';

class GetPomodoroSettings implements UseCase<PomodoroSettings, NoParams> {
  final PomodoroRepository repository;

  GetPomodoroSettings(this.repository);

  @override
  Future<Either<Failure, PomodoroSettings>> call(NoParams params) async {
    return await repository.getSettings();
  }
}
