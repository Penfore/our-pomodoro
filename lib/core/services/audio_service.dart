import 'package:audioplayers/audioplayers.dart';

enum SoundType { sessionComplete, breakComplete, cycleComplete, tick }

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  AudioPlayer? _audioPlayer;
  bool _soundEnabled = true;
  double _volume = 0.7;

  bool get soundEnabled => _soundEnabled;
  double get volume => _volume;

  AudioPlayer get _player {
    _audioPlayer ??= AudioPlayer();
    return _audioPlayer!;
  }

  Future<void> initialize() async {
    try {
      await _player.setVolume(_volume);
    } catch (e) {
      // Silent fail for test environments
    }
  }

  /// Set sound enabled/disabled
  void setSoundEnabled(bool enabled) {
    _soundEnabled = enabled;
  }

  /// Set volume (0.0 to 1.0)
  void setVolume(double volume) {
    _volume = volume.clamp(0.0, 1.0);
    try {
      _player.setVolume(_volume);
    } catch (e) {
      // Silent fail for test environments
    }
  }

  Future<void> playSound(SoundType soundType) async {
    if (!_soundEnabled) return;

    try {
      final soundPath = _getSoundPath(soundType);

      // Stop any currently playing sound first
      await _player.stop();

      // Set volume before playing
      await _player.setVolume(_volume);

      // Play the sound
      await _player.play(AssetSource(soundPath));
    } catch (e) {
      // Silent fail - audio errors shouldn't break the app
    }
  }

  String _getSoundPath(SoundType soundType) {
    switch (soundType) {
      case SoundType.sessionComplete:
        return 'sounds/session_complete.mp3';
      case SoundType.breakComplete:
        return 'sounds/break_complete.mp3';
      case SoundType.cycleComplete:
        return 'sounds/cycle_complete.mp3';
      case SoundType.tick:
        return 'sounds/tick.mp3';
    }
  }

  Future<void> stopSound() async {
    try {
      await _player.stop();
    } catch (e) {
      // Silent fail for test environments
    }
  }

  void dispose() {
    _audioPlayer?.dispose();
  }
}
