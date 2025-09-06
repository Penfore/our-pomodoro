# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Planned
- Timer functionality (start/pause/reset)
- UI implementation
- Settings screen
- Statistics dashboard
- Notifications system
- Sound alerts

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
