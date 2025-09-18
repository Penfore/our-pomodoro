import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/pomodoro_settings.dart';
import '../repositories/pomodoro_repository.dart';

class UpdatePomodoroSettings
    implements UseCase<void, UpdatePomodoroSettingsParams> {
  final PomodoroRepository repository;

  UpdatePomodoroSettings(this.repository);

  @override
  Future<Result<void>> call(UpdatePomodoroSettingsParams params) async {
    return await repository.updateSettings(params.settings);
  }
}

class UpdatePomodoroSettingsParams extends Equatable {
  final PomodoroSettings settings;

  const UpdatePomodoroSettingsParams({required this.settings});

  @override
  List<Object> get props => [settings];
}
