# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
# Get dependencies
flutter pub get

# Run the app
flutter run

# Code generation (Hive adapters, Freezed, JSON serialization)
flutter packages pub run build_runner build --delete-conflicting-outputs

# Watch mode for code generation
flutter packages pub run build_runner watch --delete-conflicting-outputs

# Generate localizations
flutter gen-l10n

# Analyze
flutter analyze

# Format
dart format .

# Run all tests
flutter test

# Run a single test file
flutter test test/features/transaction/presentation/widgets/transaction_amount_section_test.dart

# Run tests with coverage
flutter test --coverage

# Clean build
flutter clean && flutter pub get
```

## Architecture

Clean Architecture with feature-first organization. Three layers per feature: `data` → `domain` → `presentation`.

```
lib/
  main.dart              # Bootstraps Hive, then runs app
  app.dart               # MaterialApp root: theme, routing, Responsive.builder
  core/
    db/                  # Hive setup: hive_bootstrap.dart, hive_box.dart, hive_type.dart
    routing/router.dart  # GoRouter — redirect guards onboarding via HiveBoxes.prefs
    theme/               # AppColors, AppTheme, AppTypography
    responsive/          # Responsive system (context.layout, context.device, .ic()/.sp())
    errors/              # Failure sealed class, exception types, ExceptionMapper
    result/              # Result<T> type
    sync/                # SyncQueue, SyncRemote (Supabase stub — not yet live)
    utils/               # currency_utils, date_time_utc_converter, transaction_utils
  features/
    transaction/         # Core feature — most use cases live here
    wallets/
    categories/
    dashboard/
    onboarding/
  shared/
    widgets/             # Reusable UI: AppTextField, custom_snackbar, summary_header, etc.
    services/            # snackbar_service.dart
  l10n/                  # app_en.arb, app_bn.arb
```

### Feature layer convention

Each feature follows:
- `data/models/` — Hive DTOs (generated adapters via `@HiveType`/`@HiveField`)
- `data/*_repo_impl.dart` — implements domain repository interface
- `domain/entities/` — pure Dart entities (Freezed or Equatable)
- `domain/repositories/` — abstract interface
- `domain/usecases/` — one class per use case, calls repository
- `presentation/viewmodels/` — Riverpod providers/notifiers
- `presentation/pages/` — screens
- `presentation/widgets/` — screen-specific widgets

### State management

Riverpod throughout. Use cases are provided via `*_usecases_providers.dart` files, then consumed by `*_providers.dart`. Notifiers live in `*_notifier.dart` files. Computed/derived state goes in `*_computed_providers.dart`.

### Hive type IDs

Defined in `lib/core/db/hive_type.dart`. **Never change existing IDs** — doing so corrupts stored data. Current allocations:
- `1` — CategoryModel
- `10` — Transaction, `11` — TransactionType enum
- `52` — WalletModel, `53` — WalletTypeDto enum

### Routing

GoRouter in `core/routing/router.dart`. Onboarding gate: checks `HiveBoxes.prefs` key `onboarding_done`. Routes: `/` (dashboard), `/onboarding`, `/add_edit_transaction`, `/transactions/add_edit`.

### Responsive system

`Responsive.builder` wraps the widget tree in `app.dart`. Access via:
- `context.layout` — `AppSize` with spacing, typography, gutters
- `context.device` — `DeviceSize.phone/tablet/desktop`
- `24.ic(context)` — icon size scaled to uiScale
- `16.sp(context)` — font size scaled to textScale

Breakpoints use shortest side (rotation-safe): compact / mobile / tablet / desktop.

### Localization

ARB files in `lib/l10n/`. Supported: `en`, `bn`. After adding keys, run `flutter gen-l10n`. Access: `AppLocalizations.of(context).keyName`.

### Code generation

Three generators in use — all triggered by `build_runner`:
- `hive_generator` — Hive type adapters for `@HiveType` models
- `freezed` — immutable value types and sealed classes
- `json_serializable` — JSON fromJson/toJson

After modifying any annotated model, re-run build_runner.

### Sync (not yet live)

`core/sync/` contains `SyncQueue` and `SyncRemote`. Supabase is stubbed (`supabase_stub.dart`). The offline-first flow writes to Hive first, queues a sync operation, and will eventually replay to Supabase.

## Linting rules

Beyond `flutter_lints`: `prefer_final_locals`, `always_use_package_imports`, `avoid_print`.

## Agent loop system

Mandatory for all autonomous AI agent sessions. Full spec: [`docs/planning/AGENT_LOOP_SYSTEM.md`](docs/planning/AGENT_LOOP_SYSTEM.md).

**Core loop:** `OBSERVE → ORIENT → PLAN → EXECUTE → VERIFY → DOCUMENT → COMMIT → REFLECT`

**Session startup (every new session):**
1. Read this file (CLAUDE.md)
2. Read `docs/tracking/CURRENT_SPRINT.md`
3. Read `docs/tracking/TASKS.md`
4. `git status && git log --oneline -5`
5. Understand request in context of current sprint

**Key rules:**
- Verify repo state before trusting plans or memory
- Define blast radius before starting (list files you'll touch)
- Verify after each step, not just at the end
- One commit per logical change
- Fail loudly — never silently work around unexpected state
- Update tracking docs after every task
- Ask when confidence < 80% on irreversible decisions

**Invariants (never violate):**
- Never change Hive type IDs
- Never skip `build_runner` after modifying annotated models
- Never commit generated files (*.g.dart, *.freezed.dart)
- Never remove existing test coverage
- Always match existing code style

## Coding methodology (Karpathy rules)

These are mandatory, not optional. Every task must follow all four.

### 1. Think before coding

State assumptions explicitly before writing code. If multiple interpretations exist, present them — don't pick silently. If something is unclear, stop and ask. Never hide confusion.

### 2. Simplicity first

Write the minimum code that solves the problem. No features beyond what was asked. No abstractions for single-use code. No speculative flexibility or configurability. If 200 lines can be 50, rewrite it.

### 3. Surgical changes

Touch only what the request requires. Don't improve adjacent code, formatting, or comments. Match existing style even if you'd do it differently. If you notice unrelated dead code, mention it — don't delete it. Remove only imports/variables/functions that YOUR changes made unused.

### 4. Goal-driven execution

Before multi-step tasks, state a brief plan with verifiable success criteria:

```
1. [step] → verify: [check]
2. [step] → verify: [check]
```

Transform vague goals into testable ones: "fix the bug" → "write a failing test that reproduces it, then make it pass".
