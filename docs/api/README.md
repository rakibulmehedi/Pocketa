# 🔌 PocketA API Documentation

Complete API reference for all services, repositories, and data models in the PocketA application.

## 📋 Table of Contents

- [Core Services API](./core-services.md) - Analytics, Error Handling, Performance
- [Data Layer API](./data-layer.md) - Repositories, Models, Database
- [Feature APIs](./features.md) - Onboarding, Transactions, Wallets, Categories
- [Widget API](./widgets.md) - Shared Components and UI Elements
- [State Management API](./state-management.md) - Riverpod Providers and Notifiers

---

## 🎯 API Overview

PocketA provides a comprehensive set of APIs organized into several categories:

### 🏗️ Core Services
- **AnalyticsService** - Event tracking and user analytics
- **ErrorHandler** - Global error handling and recovery
- **PerformanceMetrics** - Performance monitoring and optimization
- **SoundService** - Audio feedback and sound effects
- **CelebrationService** - User engagement and gamification

### 💾 Data Layer
- **Repository Pattern** - Abstract data access layer
- **Hive Integration** - Local database operations
- **Model Classes** - Data transfer objects and entities
- **Sync Services** - Offline-first data synchronization

### 🎯 Features
- **Onboarding** - User onboarding and personalization
- **Transactions** - Income, expense, and transfer management
- **Wallets** - Multi-wallet support and management
- **Categories** - Transaction categorization and budgeting

### 🎨 UI Components
- **Shared Widgets** - Reusable UI components
- **Input Fields** - Form controls and validation
- **Navigation** - Routing and navigation components
- **Responsive** - Adaptive UI for different screen sizes

---

## 🔧 Usage Patterns

### Service Injection
```dart
// Using Riverpod providers
final analyticsService = ref.read(analyticsProvider);
final soundService = ref.read(soundServiceProvider);
```

### Repository Pattern
```dart
// Data access through repositories
final transactionRepo = ref.read(transactionRepositoryProvider);
final transactions = await transactionRepo.getTransactions();
```

### State Management
```dart
// State management with Riverpod
final onboardingState = ref.watch(onboardingNotifierProvider);
final isLoading = ref.watch(onboardingNotifierProvider.select((state) => state.isLoading));
```

---

## 📚 API Categories

### 🏗️ [Core Services](./core-services.md)
Essential services that provide core functionality across the application.

### 💾 [Data Layer](./data-layer.md)
Data access layer including repositories, models, and database operations.

### 🎯 [Features](./features.md)
Feature-specific APIs for onboarding, transactions, wallets, and categories.

### 🎨 [Widgets](./widgets.md)
UI component APIs for building responsive and accessible interfaces.

### 🔄 [State Management](./state-management.md)
Riverpod-based state management patterns and providers.

---

## 🚀 Getting Started

1. **Choose your category** - Select the appropriate API category
2. **Read the overview** - Understand the purpose and scope
3. **Check examples** - Review code examples and usage patterns
4. **Implement** - Use the APIs in your implementation
5. **Test** - Verify functionality with provided test examples

---

*This API documentation is automatically generated and maintained. For the latest updates, check the source code and commit history.*
