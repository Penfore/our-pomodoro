import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/pomodoro_session.dart';
import '../repositories/pomodoro_repository.dart';

class GetCurrentSession implements UseCase<PomodoroSession?, NoParams> {
  final PomodoroRepository repository;

  GetCurrentSession(this.repository);

  @override
  Future<Result<PomodoroSession?>> call(NoParams params) async {
    return await repository.getCurrentSession();
  }
}
