# 🍅 Our Pomodoro

<div align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" />
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart" />
  <img src="https://img.shields.io/badge/version-0.1.0-blue?style=for-the-badge" alt="Version" />
  <img src="https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge" alt="License" />
  <img src="https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=for-the-badge" alt="PRs Welcome" />
</div>

<div align="center">
  <h3>🎯 Maximize your productivity with the Pomodoro Technique</h3>
  <p>A beautiful, clean, and efficient Pomodoro Timer app built with Flutter following Clean Architecture principles.</p>
</div>

---

## ✨ Planned Features

> **Note**: This project is in early development (v0.1.0). Currently only the Clean Architecture foundation is implemented.

### 🚧 **In Development**
- �️ **Clean Architecture** - Maintainable, testable, and scalable codebase ✅
- 📦 **Dependency Injection** - GetIt setup with manual configuration ✅
- 🏛️ **Domain Layer** - Entities, repositories, and use cases ✅
- 💾 **Data Layer** - Local storage with SharedPreferences ✅
- 🎛️ **State Management** - BLoC pattern implementation ✅

### 📋 **Planned Features**
- �🍅 **Classic Pomodoro Timer** - 25min work, 5min break, 15min long break
- ⚙️ **Customizable Settings** - Adjust timer durations to your preference
- 📊 **Productivity Statistics** - Track your focus sessions and streaks
- 🔔 **Smart Notifications** - Get notified when sessions complete
- 🎵 **Sound Alerts** - Customizable notification sounds
- 🌙 **Dark/Light Theme** - Beautiful themes for any time of day
- 📱 **Cross Platform** - Works on Android and iOS
- 💾 **Offline First** - All data stored locally, works without internet

## 📱 Screenshots

*Screenshots will be added as features are implemented. Currently showing basic app structure (v0.1.0)*

## 🚀 Getting Started

### Prerequisites

Before you begin, ensure you have the following installed:

- [Flutter](https://flutter.dev/docs/get-started/install) (3.9.2 or later)
- [Dart](https://dart.dev/get-dart) (3.0.0 or later)
- [Android Studio](https://developer.android.com/studio) or [VS Code](https://code.visualstudio.com/)
- Android SDK (for Android development)
- Xcode (for iOS development - macOS only)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/our_pomodoro.git
   cd our_pomodoro
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Build for Production

**Android (APK)**
```bash
flutter build apk --release
```

**Android (App Bundle)**
```bash
flutter build appbundle --release
```

**iOS**
```bash
flutter build ios --release
```

## 🏗️ Architecture

This project follows **Clean Architecture** principles, ensuring:

- **Separation of Concerns** - Each layer has a single responsibility
- **Dependency Inversion** - High-level modules don't depend on low-level modules
- **Testability** - Easy to unit test business logic
- **Maintainability** - Easy to modify and extend

### Project Structure

```
lib/
├── core/                     # Shared functionality
│   ├── constants/           # App constants
│   ├── error/              # Error handling
│   ├── network/            # Network utilities
│   ├── platform/           # Platform specific code
│   ├── theme/              # App theming
│   └── usecase/            # Base use case interface
├── features/               # Feature modules
│   └── pomodoro/          # Pomodoro feature
│       ├── data/          # Data layer (models, repositories, datasources)
│       ├── domain/        # Domain layer (entities, repositories, use cases)
│       └── presentation/  # Presentation layer (pages, widgets, BLoC)
├── injection_container.dart # Dependency injection setup
└── main.dart              # App entry point
```

### Tech Stack

- **Framework**: Flutter 3.9.2+
- **Language**: Dart 3.0+
- **State Management**: Flutter BLoC
- **Dependency Injection**: GetIt
- **Local Storage**: SharedPreferences
- **Functional Programming**: Dartz (Either, Option)
- **Testing**: Flutter Test, BLoC Test, Mocktail

## 🧪 Testing

Run all tests:
```bash
flutter test
```

Run tests with coverage:
```bash
flutter test --coverage
```

View coverage report:
```bash
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## 📋 Development Roadmap

### Phase 1: Core Features ✅
- [x] Clean Architecture setup
- [x] Dependency injection
- [x] Basic BLoC structure
- [x] Data models and entities

### Phase 2: Timer Implementation 🚧
- [ ] Timer functionality (start/pause/reset)
- [ ] Session transitions
- [ ] Sound notifications
- [ ] Local notifications

### Phase 3: UI/UX 📝
- [ ] Modern, intuitive UI design
- [ ] Smooth animations
- [ ] Dark/Light theme
- [ ] Responsive design

### Phase 4: Advanced Features 📝
- [ ] Statistics dashboard
- [ ] Customizable settings
- [ ] Export data functionality
- [ ] Widgets for home screen

### Phase 5: Platform Features 📝
- [ ] Background execution
- [ ] System integration
- [ ] Accessibility features
- [ ] Performance optimizations

## 🤝 Contributing

We love contributions! Please read our [Contributing Guide](CONTRIBUTING.md) to learn about our development process.

### Quick Start for Contributors

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/AmazingFeature`)
3. **Commit** your changes (`git commit -m 'Add some AmazingFeature'`)
4. **Push** to the branch (`git push origin feature/AmazingFeature`)
5. **Open** a Pull Request

### Development Guidelines

- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
- Write meaningful commit messages
- Add tests for new features
- Update documentation as needed
- Ensure code passes `flutter analyze`

### Types of Contributions

- 🐛 **Bug reports** - Help us identify issues
- 💡 **Feature requests** - Suggest new functionality
- 🔧 **Code contributions** - Implement features or fix bugs
- 📚 **Documentation** - Improve docs and examples
- 🎨 **Design** - UI/UX improvements
- 🌍 **Translations** - Help localize the app

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Authors & Contributors

- **[Fúlvio Leo]** - *Initial work* - [@Penfore](https://github.com/Penfore)

See also the list of [contributors](https://github.com/Penfore/our_pomodoro/contributors) who participated in this project.

## 📞 Support & Community

- 🐛 **Issues**: [GitHub Issues](https://github.com/Penfore/our_pomodoro/issues)
- 💬 **Discussions**: [GitHub Discussions](https://github.com/Penfore/our_pomodoro/discussions)
- 📧 **Email**: fulvioleo.dev@pm.me

## 🙏 Acknowledgments

- Inspired by the [Pomodoro Technique](https://en.wikipedia.org/wiki/Pomodoro_Technique) by Francesco Cirillo
- Built with [Flutter](https://flutter.dev/) by Google
- Icons provided by [Flutter Icons](https://flutter.dev/docs/development/ui/widgets/icon)
- Thanks to all [contributors](https://github.com/Penfore/our_pomodoro/contributors)

## 📈 Project Stats

<div align="center">
  <img src="https://img.shields.io/github/stars/yourusername/our_pomodoro?style=social" alt="GitHub stars" />
  <img src="https://img.shields.io/github/forks/yourusername/our_pomodoro?style=social" alt="GitHub forks" />
  <img src="https://img.shields.io/github/issues/yourusername/our_pomodoro" alt="GitHub issues" />
  <img src="https://img.shields.io/github/issues-pr/yourusername/our_pomodoro" alt="GitHub pull requests" />
</div>

---

<div align="center">
  <p>Made with ❤️ and ☕ by developers, for developers</p>
  <p>If this project helped you, please consider giving it a ⭐!</p>
</div>
