# Initialization Service

## 📋 Overview

The `InitializationService` is responsible for initializing all app services during app startup. It provides a clean separation of concerns by moving service initialization logic out of the main.dart file.

## 🎯 Purpose

- **Clean Main**: Keeps the main.dart file focused on app setup
- **Error Handling**: Gracefully handles initialization errors without crashing the app
- **Centralized Logic**: Single place to manage all service initialization
- **Maintainability**: Easy to add/remove services without touching main.dart

## 🏗️ Architecture

```dart
InitializationService.initializeServices()
├── AudioService.initialize()
├── NotificationService.initialize()
└── NotificationService.requestPermission()
```

## 🔧 Usage

### In main.dart
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  await service_locator.init();

  // Initialize all app services
  await InitializationService.initializeServices();

  runApp(const MyApp());
}
```

### Adding New Services
To initialize a new service, add it to the `initializeServices()` method:

```dart
static Future<void> initializeServices() async {
  await _initializeAudioService();
  await _initializeNotificationService();
  await _initializeYourNewService(); // Add here
}

static Future<void> _initializeYourNewService() async {
  try {
    await service_locator.sl<YourNewService>().initialize();
  } catch (e) {
    print('Error initializing YourNewService: $e');
  }
}
```## ⚠️ Error Handling

The service uses try-catch blocks to handle initialization errors gracefully:

- **AudioService errors**: Logged but app continues (audio is optional)
- **NotificationService errors**: Logged but app continues (notifications are optional)
- **App doesn't crash**: Critical services should be handled separately if needed

## 🧪 Testing

The InitializationService is fully tested with:

- ✅ Service initialization success scenarios
- ✅ Error handling for each service
- ✅ Graceful degradation when services fail
- ✅ Singleton pattern verification

## 📊 Services Initialized

| Service | Purpose | Error Impact |
|---------|---------|--------------|
| AudioService | Sound alerts for session completions | App works without sound |
| NotificationService | System notifications | App works without notifications |

## 🚀 Benefits

1. **Separation of Concerns**: Main.dart focuses on app structure
2. **Error Resilience**: App starts even if some services fail
3. **Testability**: Each service initialization can be unit tested
4. **Maintainability**: Easy to modify service initialization
5. **Debugging**: Clear error messages for each service
