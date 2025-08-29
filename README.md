# pocketa

Clean Architecture-based Expense Management App built with Flutter, Riverpod, and Hive for offline-first personal finance tracking.

## Getting Started

## Project Structure

This repo follows a layered, feature-first structure with clear separation of concerns.

```
.
├── lib/
│  ├── main.dart                 # App entrypoint
│  ├── app.dart                  # Root MaterialApp / theme / routing
│  ├── l10n/                     # Localization scaffolding
│  ├── core/                     # App-wide building blocks
│  │  ├── routing/               # Navigation setup (e.g., router)
│  │  ├── theme/                 # Theme and color definitions
│  │  ├── utils/                 # General utilities/helpers
│  │  ├── errors/                # Error types and handling
│  │  ├── enums/                 # Shared enums
│  │  ├── result/                # Result/Either types
│  │  ├── responsive/            # Responsive layout widgets
│  │  └── locale/                # Locale helpers
│  ├── application/              # State management, providers, controllers
│  │  └── transaction/
│  │     ├── providers/          # Notifiers/providers (e.g., form notifier)
│  │     └── transaction_form_state.dart
│  ├── domain/                   # Enterprise business rules
│  │  ├── entities/              # Core domain entities
│  │  ├── repositories/          # Abstract repository interfaces
│  │  └── usecases/              # Application-specific business logic
│  ├── data/                     # Data access layer
│  │  ├── models/                # Data models (DTOs)
│  │  │  └── transaction/
│  │  └── repositories/          # Repository implementations
│  │     └── transaction/
│  ├── features/                 # Feature modules
│  │  ├── transaction/
│  │  │  ├── screens/            # UI screens (list, add/edit, etc.)
│  │  │  └── viewmodels/         # View models/state per screen
│  │  ├── dashboard/
│  │  │  └── presentation/
│  │  ├── onboarding/
│  │  │  └── presentation/
│  │  ├── budget/
│  │  ├── wallets/
│  │  └── categories/
│  └── widgets/                  # Reusable UI components
│     ├── input/                 # Common input fields
│     ├── summary_header.dart
│     └── custom_silver_app_bar.dart
├── assets/                      # Images, fonts, translations
├── test/                        # Tests
└── pubspec.yaml                 # Dependencies & Flutter config
```

Key paths referenced in the app:

- `lib/core/routing/router.dart`: Router configuration.
- `lib/features/transaction/screens/transaction_list_screen.dart`: Transaction list UI.
- `lib/features/transaction/screens/add_edit_transaction_screen.dart`: Add/Edit transaction UI.
- `lib/application/transaction/providers/transaction_form_notifier.dart`: Transaction form logic.
- `lib/application/transaction/transaction_form_state.dart`: Transaction form state model.
- `lib/widgets/input/app_amount_field.dart`: Amount input field.
- `lib/widgets/input/app_text_form_field.dart`: Text input field.

This structure keeps domain rules independent, isolates data access, and groups UI by feature for scalability.
