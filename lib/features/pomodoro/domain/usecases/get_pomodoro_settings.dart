import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/pomodoro_settings.dart';
import '../repositories/pomodoro_repository.dart';

class GetPomodoroSettings implements UseCase<PomodoroSettings, NoParams> {
  final PomodoroRepository repository;

  GetPomodoroSettings(this.repository);

  @override
  Future<Result<PomodoroSettings>> call(NoParams params) async {
    return await repository.getSettings();
  }
}
