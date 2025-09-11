# 🚀 VS Code Launchers for Our Pomodoro

This project includes launch configurations to facilitate development in VS Code.

## 📋 Available Launchers

### 🎯 **Development and Debug**

1. **🚀 Flutter: Debug**
   - Runs the app in debug mode
   - Hot reload enabled
   - Best for day-to-day development

2. **📱 Flutter: iOS Simulator**
   - Runs specifically on iOS simulator
   - Useful when you have multiple devices connected

3. **🤖 Flutter: Android Emulator**
   - Runs specifically on Android emulator
   - Useful when you have multiple devices connected

### 🏗️ **Build and Production**

4. **🏗️ Flutter: Build iOS**
   - Compiles the app for iOS in release mode
   - Generates `.app` file for distribution

5. **🏗️ Flutter: Build Android APK**
   - Compiles the app for Android in release mode
   - Generates `.apk` file for direct distribution

### 🧪 **Testing**

6. **🧪 Flutter: Run Tests**
   - Runs all project tests
   - Generates coverage report
   - Ideal for CI/CD

7. **🧪 Flutter: Run Tests (Watch)**
   - Runs tests in watch mode
   - Runs automatically when files change
   - Useful during test development

8. **🔍 Flutter: Test Specific File**
   - Runs tests from the currently open file
   - Useful for testing specific functionalities

## 🎮 How to Use

### Through Debug Panel (F5):
1. Press `Cmd+Shift+P` (macOS) or `Ctrl+Shift+P` (Windows/Linux)
2. Type "Debug: Select and Start Debugging"
3. Choose the desired launcher

### Through Debug Menu:
1. Go to **Run > Start Debugging** or press `F5`
2. Select the configuration in the dropdown
3. Click the play button

### Using Shortcuts:
- `F5`: Starts the last used launcher
- `Shift+F5`: Stops current execution
- `Ctrl+F5`: Starts without debugger

## 🛠️ Auxiliary Tasks

The project also includes tasks that can be executed via `Cmd+Shift+P` > "Tasks: Run Task":

- **flutter-build-ios**: Build for iOS
- **flutter-build-android**: Build for Android APK
- **flutter-build-android-bundle**: Build for Android Bundle
- **flutter-test**: Run all tests
- **flutter-test-watch**: Run tests in watch mode
- **flutter-clean**: Clean build files
- **flutter-pub-get**: Update dependencies
- **dart-analyze**: Analyze Dart code
- **dart-format**: Format Dart code

## ⚙️ Custom Settings

### Automatic Save:
- **Hot reload** enabled on save
- **Automatic formatting** on save
- **Import organization** automatic

### Search Exclusions:
- Build folders ignored
- Generated files ignored
- Coverage reports ignored

### Appearance:
- Custom status bar (orange)
- Differentiated debug bar (blue-green)

## 🎯 Extension Recommendations

The `.vscode/extensions.json` file includes recommended extensions:
- **Dart & Flutter**: Official development support
- **GitHub Copilot**: AI for programming
- **Error Lens**: Inline error highlighting
- **TODO Tree**: TODO organization
- **Material Icon Theme**: Beautiful icons

## 📚 Usage Examples

```bash
# To run tests quickly:
Cmd+Shift+P > "Tasks: Run Task" > "flutter-test"

# To debug on iOS:
F5 > "📱 Flutter: iOS Simulator"

# To make production build:
F5 > "🏗️ Flutter: Build Android APK"
```

## 💡 Tips

1. **Use the test launcher during development** - it automatically detects changes
2. **iOS build requires Xcode** - make sure you have the tools installed
3. **Release builds are optimized** - use only for distribution
4. **Hot reload works better in debug mode** - use development launchers

---

These configurations make development more efficient and standardized! 🎉
