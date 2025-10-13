import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/platform/local_data_source.dart';
import 'core/services/audio_service.dart';
import 'core/services/initialization_service.dart';
import 'core/services/notification_service.dart';
import 'features/pomodoro/data/datasources/pomodoro_local_data_source.dart';
import 'features/pomodoro/data/repositories/pomodoro_repository_impl.dart';
import 'features/pomodoro/domain/repositories/pomodoro_repository.dart';
import 'features/pomodoro/domain/usecases/clear_current_session.dart';
import 'features/pomodoro/domain/usecases/get_current_session.dart';
import 'features/pomodoro/domain/usecases/get_pomodoro_settings.dart';
import 'features/pomodoro/domain/usecases/get_pomodoro_statistics.dart';
import 'features/pomodoro/domain/usecases/start_pomodoro_session.dart';
import 'features/pomodoro/domain/usecases/update_pomodoro_session.dart';
import 'features/pomodoro/domain/usecases/update_pomodoro_settings.dart';
import 'features/pomodoro/presentation/bloc/pomodoro_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Pomodoro
  // Bloc
  sl.registerFactory(
    () => PomodoroBloc(
      startPomodoroSession: sl(),
      updatePomodoroSession: sl(),
      getCurrentSession: sl(),
      clearCurrentSession: sl(),
      audioService: sl(),
      notificationService: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => StartPomodoroSession(sl()));
  sl.registerLazySingleton(() => UpdatePomodoroSession(sl()));
  sl.registerLazySingleton(() => GetCurrentSession(sl()));
  sl.registerLazySingleton(() => ClearCurrentSession(sl()));
  sl.registerLazySingleton(() => GetPomodoroSettings(sl()));
  sl.registerLazySingleton(() => UpdatePomodoroSettings(sl()));
  sl.registerLazySingleton(() => GetPomodoroStatistics(sl()));

  // Repository
  sl.registerLazySingleton<PomodoroRepository>(
    () => PomodoroRepositoryImpl(localDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<PomodoroLocalDataSource>(
    () => PomodoroLocalDataSourceImpl(localDataSource: sl()),
  );

  //! Core
  sl.registerLazySingleton<LocalDataSource>(
    () => LocalDataSourceImpl(sharedPreferences: sl()),
  );

  // Services
  sl.registerLazySingleton(() => AudioService());
  sl.registerLazySingleton(() => NotificationService());
  sl.registerLazySingleton(() => InitializationService());

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}
