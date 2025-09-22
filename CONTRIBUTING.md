# Contributing to Our Pomodoro

First off, thank you for considering contributing to Our Pomodoro! 🎉

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [How Can I Contribute?](#how-can-i-contribute)
- [Development Process](#development-process)
- [Style Guidelines](#style-guidelines)
- [Commit Guidelines](#commit-guidelines)
- [Pull Request Process](#pull-request-process)

## Code of Conduct

This project and everyone participating in it is governed by our Code of Conduct. By participating, you are expected to uphold this code.

### Our Pledge

We pledge to make participation in our project a harassment-free experience for everyone, regardless of age, body size, disability, ethnicity, gender identity and expression, level of experience, nationality, personal appearance, race, religion, or sexual identity and orientation.

### Our Standards

Examples of behavior that contributes to creating a positive environment include:
- Using welcoming and inclusive language
- Being respectful of differing viewpoints and experiences
- Gracefully accepting constructive criticism
- Focusing on what is best for the community
- Showing empathy towards other community members

## Getting Started

### Prerequisites

- Flutter 3.35.4 or later
- Dart 3.0 or later
- Git
- A code editor (VS Code, Android Studio, etc.)

### Setup Development Environment

1. Fork the repository on GitHub
2. Clone your fork locally:
   ```bash
   git clone https://github.com/your-username/our_pomodoro.git
   cd our_pomodoro
   ```
3. Add the original repository as upstream:
   ```bash
   git remote add upstream https://github.com/original-username/our_pomodoro.git
   ```
4. Install dependencies:
   ```bash
   flutter pub get
   ```
5. Run the app to make sure everything works:
   ```bash
   flutter run
   ```

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check existing issues as you might find that the problem has already been reported.

When you create a bug report, please include:
- **A clear and descriptive title**
- **Steps to reproduce** the behavior
- **Expected behavior**
- **Actual behavior**
- **Screenshots** if applicable
- **Device information** (OS, version, etc.)
- **App version**

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion, please include:
- **A clear and descriptive title**
- **A detailed description** of the suggested enhancement
- **The motivation** for the enhancement
- **Examples** of how the enhancement would be used

### Code Contributions

#### Good First Issues

Look for issues labeled `good first issue` if you're new to the project.

#### Areas Where We Need Help

- UI/UX improvements
- Performance optimizations
- Testing coverage
- Documentation
- Accessibility features
- Internationalization

## Development Process

### Branching Strategy

We use a simplified Git flow:
- `main` - Production ready code
- `develop` - Integration branch for features
- `feature/feature-name` - Feature branches
- `bugfix/bug-description` - Bug fix branches
- `hotfix/critical-fix` - Critical fixes

### Workflow

1. Create a new branch from `develop`:
   ```bash
   git checkout develop
   git pull upstream develop
   git checkout -b feature/your-feature-name
   ```

2. Make your changes and commit them:
   ```bash
   git add .
   git commit -m "feat: add your feature description"
   ```

3. Push to your fork:
   ```bash
   git push origin feature/your-feature-name
   ```

4. Create a Pull Request

## Style Guidelines

### Dart Code Style

We follow the [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines:

- Use `dart format` to format your code
- Run `flutter analyze` before committing
- Follow the existing code patterns in the project

### Architecture Guidelines

- Follow Clean Architecture principles
- Maintain separation of concerns
- Use dependency injection
- Write testable code
- Keep business logic in use cases
- Use BLoC for state management

### File Organization

```
lib/
├── core/                 # Shared utilities
├── features/            # Feature modules
│   └── feature_name/
│       ├── data/        # Data layer
│       ├── domain/      # Domain layer
│       └── presentation/# Presentation layer
```

## Commit Guidelines

We follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

### Commit Format

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

### Types

- `feat`: A new feature
- `fix`: A bug fix
- `docs`: Documentation only changes
- `style`: Changes that don't affect code meaning (white-space, formatting, etc.)
- `refactor`: A code change that neither fixes a bug nor adds a feature
- `perf`: A code change that improves performance
- `test`: Adding missing tests or correcting existing tests
- `chore`: Changes to the build process or auxiliary tools

### Examples

```bash
feat(timer): add pause functionality
fix(notifications): resolve notification not showing issue
docs(readme): update installation instructions
test(timer): add unit tests for timer logic
```

## Pull Request Process

### Before Submitting

1. Ensure your code follows the style guidelines
2. Run `flutter analyze` and fix any issues
3. Run `flutter test` and ensure all tests pass
4. Add tests for new functionality
5. Update documentation if needed
6. Rebase your branch on the latest `develop`

### Pull Request Template

When creating a PR, please include:

- **Description** - Clear description of what the PR does
- **Type of Change** - Bug fix, new feature, documentation, etc.
- **Testing** - How you tested your changes
- **Screenshots** - If UI changes are involved
- **Checklist** - Ensure all requirements are met

### Review Process

1. At least one maintainer must approve the PR
2. All CI checks must pass
3. No merge conflicts
4. Code must follow project standards

### After Approval

- PRs are typically merged by maintainers
- Your branch will be deleted after merge
- Thank you for your contribution! 🎉

## Recognition

Contributors are recognized in:
- README.md contributors section
- Release notes for significant contributions
- Special recognition for long-term contributors

## Questions?

Feel free to:
- Open a GitHub Discussion
- Create an issue with the `question` label
- Contact maintainers directly

Thank you for contributing to Our Pomodoro! 🍅
