import 'package:flutter_test/flutter_test.dart';
import 'package:our_pomodoro/core/services/audio_service.dart';

void main() {
  group('AudioService', () {
    late AudioService audioService;

    setUp(() {
      audioService = AudioService();
    });

    test('should be a singleton', () {
      final instance1 = AudioService();
      final instance2 = AudioService();

      expect(instance1, equals(instance2));
    });

    test('should have default values', () {
      expect(audioService.soundEnabled, true);
      expect(audioService.volume, 0.7);
    });

    test('should update sound enabled setting', () {
      audioService.setSoundEnabled(false);

      expect(audioService.soundEnabled, false);
    });

    test('should update volume setting', () {
      audioService.setVolume(0.5);

      expect(audioService.volume, 0.5);
    });

    test('should clamp volume between 0.0 and 1.0', () {
      audioService.setVolume(-0.5);
      expect(audioService.volume, 0.0);

      audioService.setVolume(1.5);
      expect(audioService.volume, 1.0);

      audioService.setVolume(0.3);
      expect(audioService.volume, 0.3);
    });

    test('should not crash when playing sound while disabled', () async {
      audioService.setSoundEnabled(false);

      await audioService.playSound(SoundType.sessionComplete);
    });

    test('should stop sound without error', () async {
      await audioService.stopSound();
    });
  });
}
