# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0](https://github.com/rakibulmehedi/Pocketa/compare/v0.1.0...v1.0.0) (2026-06-03)


### ⚠ BREAKING CHANGES

* **ui:** none
* **ui,perf,i18n:** centralize responsive usage, optimize lists, and tighten theming/error handling
* **responsive:** legacy responsive utilities removed; use `Responsive.builder` + `context.layout`.

### Features

* add user-defined categories and refactor transaction form UX ([cdfb11f](https://github.com/rakibulmehedi/Pocketa/commit/cdfb11fd476663f24631c6f2fde1a5412ad6ca28))
* Enhance theming, localization, and add onboarding flow ([6a02f0e](https://github.com/rakibulmehedi/Pocketa/commit/6a02f0ebc72d14417a2d0b18932e225fa83f7160))
* **transaction:** add form state, notifier, and providers ([682cfa3](https://github.com/rakibulmehedi/Pocketa/commit/682cfa3b3a6c491ab35c9252a9f1a6936eee38a6))
* **wallets,categories,tx:** add wallet & category modules + integrate pickers ([eae0981](https://github.com/rakibulmehedi/Pocketa/commit/eae098137f2bb33e4719b9817157bc949bf03856))


### Bug Fixes

* clean analyzer baseline and fix all failing tests ([c821b20](https://github.com/rakibulmehedi/Pocketa/commit/c821b20bf7b43775388a832eead8fe2c4cf5fb07))


### Code Refactoring

* **responsive:** unify responsive system and migrate UI components ([a029528](https://github.com/rakibulmehedi/Pocketa/commit/a029528058a47c124e73fce22325663e1af6296f))
* **ui,perf,i18n:** centralize responsive usage, optimize lists, and tighten theming/error handling ([acd34cf](https://github.com/rakibulmehedi/Pocketa/commit/acd34cf145cc01238e01d323d8a38c8684d1aebe))
* **ui:** responsive masonry/list perf, safer errors, i18n presets, iOS 13 ([d1d9c39](https://github.com/rakibulmehedi/Pocketa/commit/d1d9c39b2fdaf059fe1d23bb1d0522e30cd44781))

## [Unreleased]

### Added
- **Performance Optimizations**
  - `PerformanceOptimizedWidget` base class for automatic resource disposal
  - `PerformanceMonitor` service for tracking app performance metrics
  - Memory-optimized widgets with proper disposal patterns
  - Performance monitoring mixin for widgets

- **Error Handling System**
  - Centralized `ErrorHandler` service for consistent error management
  - `ErrorHandlingMixin` for widgets with built-in error handling
  - Global error handler for uncaught exceptions
  - User-friendly error messages with retry mechanisms

- **Widget Architecture Improvements**
  - Split large transaction screen into smaller, focused components:
    - `TransactionAmountSection` for amount input and quick chips
    - `TransactionCategorySection` for category selection
    - `TransactionWalletSection` for wallet selection
    - `TransactionDetailsSection` for notes and tags
  - Created `transaction_form_widgets.dart` barrel file for easy imports

- **Testing Infrastructure**
  - Comprehensive test suite for transaction form widgets
  - Error handling tests with various failure scenarios
  - Performance monitoring tests
  - Widget interaction tests with proper mocking

- **Documentation**
  - Comprehensive README with detailed setup instructions
  - Performance optimization guidelines
  - Error handling best practices
  - Testing strategies and examples
  - Security considerations and best practices

### Changed
- **Onboarding Flow**
  - Fixed syntax error in demo screen that was causing build failures
  - Made all onboarding screens properly scrollable to prevent overflow
  - Improved responsive design for different screen sizes
  - Enhanced user experience with better error handling

- **Code Quality**
  - Fixed all `withOpacity` deprecation warnings by replacing with `withValues(alpha: X)`
  - Improved code organization and separation of concerns
  - Enhanced type safety and null safety compliance
  - Better error handling throughout the application

### Fixed
- **Build Issues**
  - Fixed syntax error in `onboarding_demo_screen.dart` (extra closing parenthesis)
  - Resolved all deprecation warnings for better Flutter compatibility
  - Fixed responsive layout issues in onboarding screens

- **Performance Issues**
  - Reduced memory leaks by implementing proper disposal patterns
  - Optimized widget rebuilds with better state management
  - Improved app startup time with lazy loading

### Security
- **Error Sanitization**
  - Prevented sensitive data exposure in error messages
  - Implemented secure error logging without user data
  - Added input validation and sanitization

### Performance
- **Memory Management**
  - Automatic disposal of controllers and animations
  - Reduced memory footprint with optimized widgets
  - Better garbage collection with proper resource cleanup

- **State Management**
  - Optimized Riverpod providers for better performance
  - Reduced unnecessary rebuilds with selective updates
  - Improved state persistence and serialization

## [0.1.0+1] - 2024-01-15

### Added
- **Core Features**
  - Initial release of Pocketa personal finance app
  - Clean Architecture implementation with Flutter, Riverpod, and Hive
  - Offline-first data storage with Hive database
  - Multi-language support (English and Bengali)

- **Transaction Management**
  - CRUD operations for income, expense, and transfer transactions
  - Manual wallet support (Cash, bKash, Nagad, Bank)
  - Category management with predefined and custom categories
  - Transaction validation and error handling

- **User Interface**
  - Modern, responsive design with Material Design 3
  - Custom snackbar system for user feedback
  - Onboarding flow with progress tracking
  - Dashboard with financial insights and charts

- **Localization**
  - English and Bengali language support
  - Localized date and currency formatting
  - ARB-based translation system

- **State Management**
  - Riverpod for state management
  - Clean separation of concerns
  - Reactive UI updates

- **Data Persistence**
  - Hive database for offline storage
  - Data synchronization preparation
  - Secure data handling

### Technical Details
- **Architecture**: Clean Architecture with feature-based organization
- **State Management**: Riverpod with providers and notifiers
- **Database**: Hive for offline-first data storage
- **Navigation**: GoRouter for declarative routing
- **UI Framework**: Flutter with Material Design 3
- **Code Generation**: Freezed, JSON Serializable, Hive Generator
- **Testing**: Flutter Test with comprehensive coverage

---

## Version History

### v0.1.0+1 (Initial Release)
- Basic transaction management
- Onboarding flow
- Multi-language support
- Offline-first architecture

### v0.2.0 (Planned)
- Supabase authentication
- Real-time synchronization
- Advanced analytics
- Export functionality

### v0.3.0 (Planned)
- Budget management
- Goal tracking
- Advanced reporting
- Team collaboration

---

## Migration Guide

### From v0.1.0 to v0.2.0
- No breaking changes expected
- New features will be additive
- Existing data will be preserved

### Performance Improvements
- Update to latest Flutter version for better performance
- Clear app data if experiencing memory issues
- Restart app after major updates

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for details on how to contribute to this project.

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
