# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Planned
- Enhanced dark theme design
- iOS native interface with Cupertino widgets
- Adaptive design that feels native on each platform
- Smooth animations and transitions
- Statistics dashboard with detailed analytics
- Customizable timer durations
- Multiple sound themes
- Multiple language support

## [0.3.2] - 2025-10-07

### 🔧 Fixed - Critical Background Timer Bug (Issue #1)

This release fixes a critical bug where the timer would not work correctly when the app was in background mode, reported by @GustavoEduardoMB.

#### **Background Timer Accuracy**
- 🐛 **Fixed timer calculation** - Timer now uses timestamp-based calculation instead of tick-based countdown
  - Changed from `Timer.periodic` decrement to `DateTime` difference calculation
  - Timer now shows accurate time even after being in background for extended periods
  - Eliminated accumulated error from missed ticks when app was suspended

#### **Scheduled Notifications**
- 🔔 **Added scheduled notifications** - Notifications are now sent even if app is killed by system
  - Implemented `zonedSchedule` with `AndroidScheduleMode.exactAllowWhileIdle`
  - Notifications work when app is in foreground, background, or completely closed
  - Automatic notification rescheduling when pausing/resuming sessions
  - Smart cancellation of outdated scheduled notifications

#### **Enhanced Android Configuration**
- ⚙️ **Added critical Android permissions** for scheduled notifications
  - `SCHEDULE_EXACT_ALARM` - Required for exact alarm scheduling (Android 12+)
  - `USE_EXACT_ALARM` - Alternative exact alarm permission
  - Added notification receivers for proper scheduled notification handling
  - Added boot receiver to maintain scheduled notifications after device restart

#### **Timezone Management**
- 🌍 **Automatic timezone detection** - App now uses device's local timezone
  - Moved timezone initialization to `InitializationService`
  - Automatic detection from device settings (no longer hardcoded to São Paulo)
  - Fallback mechanism using UTC offset if timezone name not found
  - Universal support for any country/timezone

### Added
- 📅 **Timestamp-based timer calculation** - `recalculateRemainingTime()` method in `PomodoroSession`
- 🔔 **Scheduled notification system** - `scheduleSessionCompletionNotification()` in `NotificationService`
- 🌐 **Auto timezone detection** - Intelligent timezone setup in `InitializationService`
- 📦 **New dependency**: `timezone ^0.10.1` for scheduled notifications
- 🔄 **Background completion handler** - `_handleBackgroundCompletion()` in `PomodoroBloc`

### Changed
- ⏱️ **Timer logic refactored** - Uses `startedAt` as fixed reference instead of `lastResumedAt`
- 🔄 **Tick event simplified** - `TickPomodoroEvent.remainingSeconds` now optional
- 📱 **AndroidManifest updated** with notification receivers and boot handling
- 🏗️ **Service initialization** - Timezone setup centralized in `InitializationService`

### Technical Details
- **Entity Changes**:
  - Added `lastResumedAt` field to `PomodoroSession`
  - Added `recalculateRemainingTime()` method using timestamp calculation

- **Model Changes**:
  - Updated `PomodoroSessionModel` serialization for `lastResumedAt`
  - Full support in `fromJson()`, `toJson()`, `fromEntity()`, `toEntity()`

- **BLoC Changes**:
  - Timer now recalculates on every tick using timestamps
  - Scheduled notification on start/resume
  - Cancelled scheduled notification on pause/reset/skip/complete
  - Background completion detection and handling

- **Android Configuration**:
  - Added `ScheduledNotificationReceiver` and `ScheduledNotificationBootReceiver`
  - Enhanced activity with `showWhenLocked` and `turnScreenOn`
  - Proper notification channel setup with exact alarm scheduling

### Testing
- ✅ All 57 tests passing
- ✅ Background timer accuracy verified
- ✅ Scheduled notifications tested on physical device
- ✅ Timezone detection tested across different locales

### Notes
- **⚠️ Important**: Users must reinstall the app completely (not update) to apply AndroidManifest changes
- **📱 Device Permissions**: On Android 12+, users may need to grant "Alarms & Reminders" permission
- **🔋 Battery Optimization**: Some devices (Xiaomi, Samsung) may require disabling battery restrictions for the app

## [0.3.1] - 2025-09-25

### Added
- 🔔 **Robust Notification System**
  - Comprehensive permission handling for Android and iOS
  - Dedicated notification channel for better Android management
  - Automatic permission verification before showing notifications
  - High-priority notification settings to bypass battery optimizations
  - Platform-specific notification testing (Android only)

- 🛠️ **Enhanced Settings Screen**
  - Notification test button (Android only, since iOS doesn't show notifications when app is open)
  - Improved notification permission management
  - Better user feedback for notification status
  - Platform-aware UI elements

- 🏆 **Credits Screen Integration**
  - Complete attribution for Pixabay sound resources
  - Clickable links with copy-to-clipboard functionality
  - Proper licensing information display
  - Library acknowledgments

### Enhanced
- 📱 **Android Permissions**
  - Added `VIBRATE` permission for notification vibration
  - Added `WAKE_LOCK` permission to wake device for notifications
  - Added `POST_NOTIFICATIONS` permission for Android 13+ support
  - Added `RECEIVE_BOOT_COMPLETED` for post-reboot notifications

- 🍎 **iOS Configuration**
  - Added `UIBackgroundModes` for background processing
  - Added `BGTaskSchedulerPermittedIdentifiers` for scheduled tasks
  - Improved background notification handling

- 🔧 **Notification Service**
  - Created explicit notification channel for Android
  - Implemented permission checking before notification attempts
  - Added graceful fallback for notification errors
  - Enhanced notification details with maximum priority settings

### Fixed
- 🐛 **Real Device Notifications**
  - Resolved notifications not appearing on physical Android devices
  - Fixed permission-related notification failures
  - Improved notification reliability across different Android versions
  - Better handling of device-specific notification settings

### Technical
- Updated to version 0.3.1+4
- Improved notification architecture with robust error handling
- Enhanced cross-platform notification support
- Better separation between platform-specific features

## [0.3.0] - 2025-09-22

### Added
- 🔔 **Sound Alerts System**
  - Customizable audio notifications for session completions
  - Different sounds for work sessions, breaks, and cycle completions
  - AudioService with volume control and enable/disable options
  - Graceful error handling for missing sound files

- 📢 **Push Notifications**
  - System notifications when sessions complete
  - Contextual notification messages for different session types
  - NotificationService with permission handling
  - Cross-platform notification support (Android/iOS)

- ⚙️ **Settings Screen**
  - Sound alerts configuration (enable/disable, volume control)
  - Notification preferences
  - Test sound functionality
  - Modern Material Design 3 interface

- 🛠️ **Service Architecture**
  - AudioService singleton for consistent audio management
  - NotificationService for system notification handling
  - Proper dependency injection integration
  - Service initialization in app startup

### Enhanced
- 🎛️ **Timer Screen**
  - Added settings button in app bar
  - Integrated sound and notification triggers
  - Better user experience with audio feedback

- 🏗️ **Clean Architecture**
  - New core/services directory structure
  - Improved separation of concerns
  - Enhanced dependency injection container

- 🧪 **Testing Coverage**
  - AudioService unit tests
  - Sound configuration testing
  - Maintained comprehensive test suite (48+ tests)

### Technical
- Updated to version 0.3.0+3
- Added audioplayers and flutter_local_notifications dependencies
- Asset management for sound files
- Cross-platform audio and notification support

## [0.2.0] - 2025-09-18

### Added
- 🍅 **Complete Pomodoro Timer Functionality**
  - Start, pause, resume, and reset timer operations
  - Work sessions (25 minutes), short breaks (5 minutes), long breaks (15 minutes)
  - Automatic session transitions with 2-second delay
  - Visual circular progress indicator with responsive design

- ⏭️ **Skip Session Feature**
  - Skip current session (work or break) with confirmation dialog
  - Automatic transition to next appropriate session type
  - Intelligent cycle management and completion detection

- 📊 **Session Progress Tracking**
  - Real-time session counter ("Session X of Y")
  - Visual progress dots showing completed/current/future work sessions
  - Smart session numbering that tracks work sessions specifically

- 🎯 **Advanced Session Management**
  - Automatic Pomodoro cycle progression (4 work sessions + breaks + long break)
  - Session state persistence using SharedPreferences
  - Proper cycle completion and reset functionality

- 🏗️ **Enhanced Architecture**
  - SessionHelpers utility class for session logic
  - Improved BLoC event handling for skip and completion
  - Better separation of concerns for session transitions

- 🧪 **Comprehensive Testing**
  - 46 automated tests covering all functionality
  - Unit tests for session helpers and business logic
  - BLoC testing for state management
  - Skip session functionality testing

### Changed
- 🔄 **Improved Timer Controls UI**
  - Redesigned control layout with skip button
  - Better responsive design for different screen sizes
  - Enhanced button styling with consistent Material Design

- 💫 **Better User Experience**
  - Instant transition when skipping sessions
  - Confirmation dialogs for destructive actions
  - Clear visual feedback for session progress
  - Automatic flow reduces manual intervention

- 📚 **Enhanced Documentation**
  - Complete visual documentation with screenshots
  - Updated README with current feature showcase
  - Comprehensive release notes and changelog### Technical Details
- Advanced session state management with automatic transitions
- Robust error handling and edge case management
- Timer precision with proper resource cleanup
- Memory leak prevention with proper disposal patterns
- Type-safe session helpers with comprehensive validation

## [0.1.0] - 2025-09-06

### Added
- 🏗️ Clean Architecture foundation
- 📦 Dependency injection with GetIt (manual setup)
- 🏛️ Domain layer with entities, repositories, and use cases
- 💾 Data layer with SharedPreferences integration
- 🎛️ BLoC state management setup
- 🎨 Basic theming system (light/dark themes)
- 🔧 Core utilities (error handling, network info, constants)
- 📱 Basic app structure and navigation
- 🧪 Unit testing framework setup
- 📚 Complete documentation and contribution guidelines

### Technical Details
- Project structure following Clean Architecture principles
- Type-safe error handling with Either<Failure, Success>
- Modular feature-based organization
- Testable architecture with dependency injection
- Material Design 3 theming system

---

## Format Guidelines

### Types of Changes
- **Added** for new features
- **Changed** for changes in existing functionality
- **Deprecated** for soon-to-be removed features
- **Removed** for now removed features
- **Fixed** for any bug fixes
- **Security** in case of vulnerabilities

### Version Format
- Follow [Semantic Versioning](https://semver.org/)
- MAJOR.MINOR.PATCH
- MAJOR: Breaking changes
- MINOR: New features (backward compatible)
- PATCH: Bug fixes (backward compatible)
