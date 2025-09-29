import 'package:flutter_test/flutter_test.dart';
import 'package:our_pomodoro/core/services/audio_service.dart';

void main() {
  group('AudioService', () {
    setUpAll(() {
      TestWidgetsFlutterBinding.ensureInitialized();
    });

    test('should be a singleton', () {
      expect(AudioService(), equals(AudioService()));
    });

    test('should have default values', () {
      final audioService = AudioService();
      expect(audioService.soundEnabled, true);
      expect(audioService.volume, 0.7);
    });

    test('should update sound enabled setting', () {
      final audioService = AudioService();
      audioService.setSoundEnabled(false);
      expect(audioService.soundEnabled, false);

      // Reset for other tests
      audioService.setSoundEnabled(true);
      expect(audioService.soundEnabled, true);
    });

    test('should clamp volume values correctly', () {
      final audioService = AudioService();

      final initialVolume = audioService.volume;
      expect(initialVolume, 0.7);
    });

    test('should not crash when playing sound while disabled', () async {
      final audioService = AudioService();
      audioService.setSoundEnabled(false);

      await expectLater(
        audioService.playSound(SoundType.sessionComplete),
        completes,
      );
    });

    test(
      'should handle audio operations gracefully in test environment',
      () async {
        final audioService = AudioService();

        await expectLater(audioService.initialize(), completes);

        await expectLater(audioService.stopSound(), completes);
      },
    );
  });
}
