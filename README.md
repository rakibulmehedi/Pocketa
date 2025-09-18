# Pocketa - Personal Finance App

A modern, responsive personal finance application built with Flutter, following Clean Architecture principles and designed for simplicity and performance.

## 🚀 **Features**

- **📊 Dashboard**: Overview of your financial health
- **💰 Transactions**: Track income and expenses
- **💳 Wallets**: Manage multiple payment methods
- **📈 Analytics**: Visualize your spending patterns
- **🌍 Multi-language**: English and Bengali support
- **📱 Responsive**: Works on mobile, tablet, and desktop
- **🎨 Premium UI**: Beautiful, intuitive interface

## 🏗️ **Architecture**

Pocketa follows Clean Architecture with clear separation of concerns:

- **Domain Layer**: Business logic and entities
- **Data Layer**: Data sources and repositories
- **Presentation Layer**: UI and state management

See [ARCHITECTURE.md](docs/ARCHITECTURE.md) for detailed information.

## 🛠️ **Tech Stack**

- **Flutter 3.x**: UI framework
- **Dart 3.x**: Programming language
- **Riverpod**: State management
- **GoRouter**: Navigation
- **Hive**: Local storage
- **Supabase**: Backend services

## 📦 **Project Structure**

```
lib/
├── core/                    # Core functionality
├── features/               # Feature modules
├── shared/                 # Shared functionality
└── main.dart              # App entry point
```

## 🚀 **Getting Started**

### Prerequisites

- Flutter 3.x or later
- Dart 3.x or later
- Android Studio / VS Code
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/pocketa.git
   cd pocketa
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Configuration

1. **Environment Setup**
   - Copy `.env.example` to `.env`
   - Configure your environment variables

2. **Supabase Setup**
   - Create a Supabase project
   - Update the configuration in `lib/core/network/supabase_config.dart`

3. **Build Configuration**
   - Update `pubspec.yaml` with your app details
   - Configure signing for release builds

## 🧪 **Testing**

### Run Tests

```bash
# Run all tests
flutter test

# Run specific test
flutter test test/features/transaction/

# Run with coverage
flutter test --coverage
```

### Test Structure

- **Unit Tests**: Business logic and utilities
- **Widget Tests**: UI components
- **Integration Tests**: Complete user flows

## 📱 **Platform Support**

- **iOS**: 13.0+
- **Android**: API 21+
- **Web**: Modern browsers
- **Desktop**: Windows, macOS, Linux

## 🎨 **UI/UX Design**

### Design System

- **Colors**: Consistent color palette
- **Typography**: Clear, readable fonts
- **Spacing**: Consistent spacing system
- **Components**: Reusable UI components

### Responsive Design

- **Mobile**: Optimized for phones
- **Tablet**: Enhanced for tablets
- **Desktop**: Full desktop experience

## 🌍 **Internationalization**

- **English**: Primary language
- **Bengali**: Local language support
- **RTL Support**: Right-to-left languages
- **Pluralization**: Proper plural forms

## 🔒 **Security**

- **Data Encryption**: Sensitive data protection
- **Secure Storage**: Local data security
- **API Security**: Secure network requests
- **Authentication**: Secure user authentication

## 📊 **Performance**

- **60+ FPS**: Smooth animations
- **Memory Efficient**: Optimized memory usage
- **Fast Loading**: Quick app startup
- **Offline Support**: Works without internet

## 🚀 **Deployment**

### Build for Production

```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

### Release Process

1. **Version Bump**: Update version in `pubspec.yaml`
2. **Changelog**: Update `CHANGELOG.md`
3. **Build**: Create release builds
4. **Test**: Test on all platforms
5. **Deploy**: Deploy to app stores

## 🤝 **Contributing**

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for details.

### Development Setup

1. **Fork the repository**
2. **Create a feature branch**
3. **Make your changes**
4. **Add tests**
5. **Submit a pull request**

### Code Style

- Follow Flutter/Dart style guidelines
- Use meaningful variable names
- Add comments for complex logic
- Write tests for new features

## 📚 **Documentation**

- [Architecture](docs/ARCHITECTURE.md)
- [API Documentation](docs/API.md)
- [Development Guide](docs/DEVELOPMENT.md)
- [Design System](docs/DESIGN_SYSTEM.md)
- [Testing Guide](docs/TESTING.md)

## 🐛 **Bug Reports**

Found a bug? Please report it in the [Issues](https://github.com/your-username/pocketa/issues) section.

## 💡 **Feature Requests**

Have an idea? We'd love to hear it! Please create a [Feature Request](https://github.com/your-username/pocketa/issues/new?template=feature_request.md).

## 📄 **License**

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 **Acknowledgments**

- Flutter team for the amazing framework
- Riverpod team for state management
- Supabase team for backend services
- All contributors and supporters

## 📞 **Support**

- **Email**: support@pocketa.app
- **Discord**: [Join our community](https://discord.gg/pocketa)
- **Twitter**: [@PocketaApp](https://twitter.com/PocketaApp)

## 🗺️ **Roadmap**

- [ ] **Q1 2024**: Advanced analytics
- [ ] **Q2 2024**: Investment tracking
- [ ] **Q3 2024**: Budget planning
- [ ] **Q4 2024**: Social features

---

**Made with ❤️ by the Pocketa Team**