# Sound Assets for Our Pomodoro App

## 🔊 Audio Alert System

The Our Pomodoro app now includes a comprehensive sound alert system to enhance your productivity experience. This document explains how to set up and customize the audio files.

## 📁 Sound Files (Included)

The app includes default sound files in the `assets/sounds/` directory:

- **`session_complete.mp3`** ✅ - Plays when a work session completes (25 minutes)
- **`break_complete.mp3`** ✅ - Plays when a break session completes (5 or 15 minutes)
- **`cycle_complete.mp3`** ✅ - Plays when a full Pomodoro cycle completes (4 work sessions + breaks)
- **`tick.mp3`** ⏳ - Optional tick sound for timer (future feature, not included yet)

### 🎵 Default Sound Credits
The included sounds are based on **"Chime 74910"** by freesound_community from Pixabay:
- **License**: Pixabay License (free for commercial use)
- **Modifications**: Original audio edited to create three alert variations
- **Source**: https://pixabay.com/sound-effects/chime-74910/

## 🎵 Audio Specifications

### Recommended Format: **MP3** ⭐
- **Why MP3**: Optimal balance of quality and file size for mobile apps
- **Bit Rate**: 128-192 kbps (perfect for 1-3 second alerts)
- **Sample Rate**: 44.1 kHz
- **Channels**: Mono (saves 50% space vs stereo)
- **Duration**: 1-3 seconds for alerts
- **Target Size**: 50-150 KB per sound file
- **Volume**: Moderate level (app controls final volume)

### Alternative: WAV (only if needed)
- **Use Case**: If you need absolutely perfect quality
- **Trade-off**: 10-15x larger file sizes
- **Impact**: Significantly increases APK size

### File Size Impact
```bash
# 4 Alert Sounds Comparison:
MP3 (128kbps): ~400 KB total
WAV (44.1kHz): ~6 MB total

# APK Size Impact:
With MP3: +2% APK size increase  ✅
With WAV: +33% APK size increase ❌
```

### Audio Characteristics
- **Tone**: Pleasant and non-jarring
- **Style**: Professional, focus-friendly sounds
- **Variants**: Different tones for work vs. break completions

## 📥 Where to Find Sounds

### Free Sound Libraries
1. **[Freesound.org](https://freesound.org/)** - Creative Commons licensed sounds
2. **[Zapsplat](https://www.zapsplat.com/)** - Professional sound effects (requires account)
3. **[BBC Sound Effects](https://sound-effects.bbcrewind.co.uk/)** - High-quality BBC sound archive
4. **[Pixabay Audio](https://pixabay.com/sound-effects/)** - Royalty-free sound effects

### Search Terms
- "bell chime notification"
- "soft beep alert"
- "meditation bell"
- "completion sound"
- "focus timer alert"

## � Using Your Own Sounds (Optional)

The app comes with default sounds, but you can replace them:

### Option 1: Use Default Sounds (Recommended)
- ✅ Already included and optimized
- ✅ Properly licensed for commercial use
- ✅ Mobile-optimized MP3 format
- ✅ No setup required

### Option 2: Add Your Own Custom Sounds
1. **Download** your chosen sound files
2. **Convert** to MP3 format (recommended)
3. **Rename** to match exact filenames above
4. **Replace** files in the `assets/sounds/` directory
5. **Test** using the settings screen in the app

## 📱 Platform-Specific Configuration

### Android Custom Notification Sounds
To use custom sounds in Android notifications (instead of default system notification sound):

1. **Create the raw directory** (if it doesn't exist):
   ```bash
   mkdir -p android/app/src/main/res/raw
   ```

2. **Copy sound files to Android resources**:
   ```bash
   # Copy from assets to Android raw resources
   cp assets/sounds/session_complete.mp3 android/app/src/main/res/raw/session_complete.mp3
   cp assets/sounds/break_complete.mp3 android/app/src/main/res/raw/break_complete.mp3
   cp assets/sounds/cycle_complete.mp3 android/app/src/main/res/raw/cycle_complete.mp3
   ```

3. **Requirements**:
   - Files must be in `android/app/src/main/res/raw/` directory
   - Filenames must match exactly: `session_complete.mp3`, `break_complete.mp3`, `cycle_complete.mp3`
   - Supported formats: MP3, WAV, OGG
   - No special characters in filenames

4. **Behavior**:
   - **With custom sounds**: Android notifications play your custom audio files
   - **Without custom sounds**: Android notifications use default system notification sound
   - **iOS**: Always uses the app's internal audio files (from `assets/sounds/`)

5. **Important Notes**:
   - The `android/app/src/main/res/raw/` directory should contain **only** sound files
   - Do not add README files or other documentation in this directory
   - Android build system only accepts specific file types in the raw resources folder

### iOS Notification Sounds
- iOS automatically uses the app's internal sound files from `assets/sounds/`
- No additional configuration required
- Sounds work in background mode
- In foreground mode, iOS typically doesn't show notifications (expected behavior)

## ⚙️ Audio Service Features

The app's AudioService provides:

- **Volume Control**: 0-100% adjustable volume
- **Enable/Disable**: Toggle sound alerts on/off
- **Sound Preview**: Test sounds from settings screen
- **Error Handling**: Graceful fallback if sound files are missing
- **Platform Support**: Works on Android and iOS

## 🔧 Development Notes

### Adding New Sound Types

To add new sound types, modify these files:

1. **`lib/core/services/audio_service.dart`**:
   ```dart
   enum SoundType {
     sessionComplete,
     breakComplete,
     cycleComplete,
     tick,
     // Add new sound type here
     newSoundType,
   }
   ```

2. **`_getSoundPath()` method**:
   ```dart
   case SoundType.newSoundType:
     return 'sounds/new_sound.mp3';
   ```

### Testing Audio

Use the settings screen or call directly:
```dart
await AudioService().playSound(SoundType.sessionComplete);
```

## 📋 Troubleshooting

### Sound Not Playing
1. Check if sound files exist in `assets/sounds/`
2. Verify exact filename matches
3. Ensure device volume is up
4. Check if sound alerts are enabled in settings

### File Format Issues
1. Convert to MP3 format if using other formats
2. Ensure audio file isn't corrupted
3. Test file plays in other audio players

## 📄 Licensing

### Included Sounds (Default)
The default sounds are licensed under **Pixabay License**:
- ✅ **Safe to use**: Free for commercial and personal use
- ✅ **No attribution required** (but appreciated)
- ✅ **Can be distributed**: Okay to include in app distribution
- ✅ **Repository safe**: Can be committed to Git repositories

**Full License**: https://pixabay.com/service/license-summary/

### Custom Sounds (If You Add Your Own)
Ensure all sound files you add have appropriate licenses for:
- Commercial use (if applicable)
- Distribution with app
- Attribution requirements (if any)

Always check the license terms of downloaded sound files and include proper attribution when required.

## 🎯 User Experience Tips

### Choosing Appropriate Sounds
- **Work Complete**: Gentle, celebratory tone
- **Break Complete**: Energizing, motivational sound
- **Cycle Complete**: Triumphant, achievement sound
- **Avoid**: Harsh, startling, or anxiety-inducing sounds

### Volume Recommendations
- Default volume: 70% (0.7)
- Allow users to customize volume
- Consider environment (office vs. home)



## 🚀 Future Enhancements

Planned audio features:
- Multiple sound themes
- Custom sound upload
- Background ambient sounds
- Tick sound during timer countdown
- Sound fade in/out effects

---

For technical questions about the audio system, see the AudioService class documentation in `lib/core/services/audio_service.dart`.
