import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/pomodoro_statistics.dart';
import '../repositories/pomodoro_repository.dart';

class GetPomodoroStatistics implements UseCase<PomodoroStatistics, NoParams> {
  final PomodoroRepository repository;

  GetPomodoroStatistics(this.repository);

  @override
  Future<Result<PomodoroStatistics>> call(NoParams params) async {
    return await repository.getStatistics();
  }
}
