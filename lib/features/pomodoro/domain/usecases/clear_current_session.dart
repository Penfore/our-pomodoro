import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../repositories/pomodoro_repository.dart';

class ClearCurrentSession implements UseCase<void, NoParams> {
  final PomodoroRepository repository;

  ClearCurrentSession(this.repository);

  @override
  Future<Result<void>> call(NoParams params) async {
    return await repository.clearCurrentSession();
  }
}
