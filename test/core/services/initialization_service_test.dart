import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:our_pomodoro/core/services/audio_service.dart';
import 'package:our_pomodoro/core/services/initialization_service.dart';
import 'package:our_pomodoro/core/services/notification_service.dart';
import 'package:our_pomodoro/injection_container.dart' as service_locator;

class MockAudioService extends Mock implements AudioService {}

class MockNotificationService extends Mock implements NotificationService {}

void main() {
  group('InitializationService', () {
    late MockAudioService mockAudioService;
    late MockNotificationService mockNotificationService;

    setUp(() {
      mockAudioService = MockAudioService();
      mockNotificationService = MockNotificationService();

      // Reset GetIt and register our mocks
      service_locator.sl.reset();
      service_locator.sl.registerLazySingleton<AudioService>(
        () => mockAudioService,
      );
      service_locator.sl.registerLazySingleton<NotificationService>(
        () => mockNotificationService,
      );
    });

    tearDown(() {
      service_locator.sl.reset();
    });

    test('should be a singleton', () {
      final instance1 = InitializationService();
      final instance2 = InitializationService();

      expect(instance1, equals(instance2));
    });

    test('should initialize all services successfully', () async {
      when(() => mockAudioService.initialize()).thenAnswer((_) async {});
      when(() => mockNotificationService.initialize()).thenAnswer((_) async {});
      when(
        () => mockNotificationService.ensurePermissions(),
      ).thenAnswer((_) async => true);

      await InitializationService.initializeServices();

      verify(() => mockAudioService.initialize()).called(1);
      verify(() => mockNotificationService.initialize()).called(1);
      verify(() => mockNotificationService.ensurePermissions()).called(1);
    });

    test(
      'should handle audio service initialization error gracefully',
      () async {
        when(
          () => mockAudioService.initialize(),
        ).thenThrow(Exception('Audio error'));
        when(
          () => mockNotificationService.initialize(),
        ).thenAnswer((_) async {});
        when(
          () => mockNotificationService.ensurePermissions(),
        ).thenAnswer((_) async => true);

        await InitializationService.initializeServices();

        verify(() => mockAudioService.initialize()).called(1);
        verify(() => mockNotificationService.initialize()).called(1);
        verify(() => mockNotificationService.ensurePermissions()).called(1);
      },
    );

    test(
      'should handle notification service initialization error gracefully',
      () async {
        when(() => mockAudioService.initialize()).thenAnswer((_) async {});
        when(
          () => mockNotificationService.initialize(),
        ).thenThrow(Exception('Notification error'));

        await InitializationService.initializeServices();

        verify(() => mockAudioService.initialize()).called(1);
        verify(() => mockNotificationService.initialize()).called(1);
        // ensurePermissions should not be called if initialize fails
        verifyNever(() => mockNotificationService.ensurePermissions());
      },
    );

    test(
      'should handle notification permission request error gracefully',
      () async {
        when(() => mockAudioService.initialize()).thenAnswer((_) async {});
        when(
          () => mockNotificationService.initialize(),
        ).thenAnswer((_) async {});
        when(
          () => mockNotificationService.ensurePermissions(),
        ).thenThrow(Exception('Permission error'));

        await InitializationService.initializeServices();

        verify(() => mockAudioService.initialize()).called(1);
        verify(() => mockNotificationService.initialize()).called(1);
        verify(() => mockNotificationService.ensurePermissions()).called(1);
      },
    );
  });
}
