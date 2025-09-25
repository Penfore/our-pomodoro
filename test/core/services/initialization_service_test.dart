import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:our_pomodoro/core/services/audio_service.dart';
import 'package:our_pomodoro/core/services/initialization_service.dart';
import 'package:our_pomodoro/core/services/notification_service.dart';

class MockAudioService extends Mock implements AudioService {}

class MockNotificationService extends Mock implements NotificationService {}

void main() {
  group('InitializationService', () {
    late MockAudioService mockAudioService;
    late MockNotificationService mockNotificationService;
    late GetIt serviceLocator;

    setUp(() {
      mockAudioService = MockAudioService();
      mockNotificationService = MockNotificationService();

      serviceLocator = GetIt.instance;
      serviceLocator.reset();

      serviceLocator.registerLazySingleton<AudioService>(() => mockAudioService);
      serviceLocator.registerLazySingleton<NotificationService>(() => mockNotificationService);
    });

    tearDown(() {
      serviceLocator.reset();
    });

    test('should be a singleton', () {
      final instance1 = InitializationService();
      final instance2 = InitializationService();

      expect(instance1, equals(instance2));
    });

    test('should initialize all services successfully', () async {
      when(() => mockAudioService.initialize()).thenAnswer((_) async {});
      when(() => mockNotificationService.initialize()).thenAnswer((_) async {});
      when(() => mockNotificationService.requestPermission()).thenAnswer((_) async => true);

      await InitializationService.initializeServices();

      verify(() => mockAudioService.initialize()).called(1);
      verify(() => mockNotificationService.initialize()).called(1);
      verify(() => mockNotificationService.requestPermission()).called(1);
    });

    test('should handle audio service initialization error gracefully', () async {
      when(() => mockAudioService.initialize()).thenThrow(Exception('Audio error'));
      when(() => mockNotificationService.initialize()).thenAnswer((_) async {});
      when(() => mockNotificationService.requestPermission()).thenAnswer((_) async => true);

      await InitializationService.initializeServices();

      verify(() => mockNotificationService.initialize()).called(1);
      verify(() => mockNotificationService.requestPermission()).called(1);
    });

    test('should handle notification service initialization error gracefully', () async {
      when(() => mockAudioService.initialize()).thenAnswer((_) async {});
      when(() => mockNotificationService.initialize()).thenThrow(Exception('Notification error'));
      when(() => mockNotificationService.requestPermission()).thenAnswer((_) async => true);

      await InitializationService.initializeServices();

      verify(() => mockAudioService.initialize()).called(1);
    });

    test('should handle notification permission request error gracefully', () async {
      when(() => mockAudioService.initialize()).thenAnswer((_) async {});
      when(() => mockNotificationService.initialize()).thenAnswer((_) async {});
      when(() => mockNotificationService.requestPermission()).thenThrow(Exception('Permission error'));

      await InitializationService.initializeServices();

      verify(() => mockAudioService.initialize()).called(1);
      verify(() => mockNotificationService.initialize()).called(1);
    });
  });
}
