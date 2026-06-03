# Contributing to Pocketa

Thank you for your interest in contributing to Pocketa!

## Getting Started

1. Fork the repository
2. Clone your fork: `git clone https://github.com/<your-fork>/Pocketa-V2.git`
3. Install dependencies: `flutter pub get`
4. Run code generation: `flutter packages pub run build_runner build --delete-conflicting-outputs`
5. Run tests to confirm setup: `flutter test`

## Development Workflow

1. Create a feature branch from `main`: `git checkout -b feature/your-feature`
2. Make your changes
3. Add or update tests for new functionality
4. Run `flutter analyze` and fix any issues
5. Run `dart format .` to format code
6. Run `flutter test` and ensure all tests pass
7. Commit with a conventional commit message (e.g., `feat: add wallet export`)
8. Push and open a Pull Request against `main`

## CI Requirements

All PRs must pass the CI pipeline before merge:

- `flutter analyze` — zero warnings
- `flutter test` — all tests pass
- Build verification — Android and iOS builds succeed

## Code Style

- Follow [Effective Dart](https://dart.dev/effective-dart) guidelines
- Use `package:` imports (not relative imports)
- Prefer `final` for local variables
- Avoid `print()` — use proper logging
- Follow the existing Clean Architecture layer conventions (see CLAUDE.md)

## Architecture

Each feature follows Clean Architecture: `data/` → `domain/` → `presentation/`. See the [CLAUDE.md](CLAUDE.md) file for full architecture details.

## Reporting Issues

Use [GitHub Issues](https://github.com/rakibulmehedi/Pocketa-V2/issues) to report bugs or request features. Include:

- Steps to reproduce
- Expected vs actual behavior
- Flutter version (`flutter --version`)
- Device/OS information

## License

By contributing, you agree that your contributions will be licensed under the [MIT License](LICENSE).
