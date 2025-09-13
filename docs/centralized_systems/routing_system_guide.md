# Routing System Implementation Guide
## PocketA - Advanced Navigation and Routing System

---

## 📋 Table of Contents

1. [Overview](#overview)
2. [System Architecture](#system-architecture)
3. [GoRouter Configuration](#gorouter-configuration)
4. [Route Definitions](#route-definitions)
5. [Navigation Patterns](#navigation-patterns)
6. [Route Guards and Redirects](#route-guards-and-redirects)
7. [Deep Linking](#deep-linking)
8. [State Management Integration](#state-management-integration)
9. [Implementation Examples](#implementation-examples)
10. [Performance Optimization](#performance-optimization)
11. [Testing Routing](#testing-routing)
12. [Migration Guide](#migration-guide)
13. [Reusable Package Setup](#reusable-package-setup)

---

## 🎯 Overview

The PocketA Routing System provides a comprehensive navigation solution using GoRouter, offering declarative routing, deep linking support, and seamless integration with state management. It supports complex navigation patterns while maintaining excellent performance and developer experience.

### Key Features
- **Declarative Routing**: Type-safe route definitions with clear structure
- **Deep Linking**: Full support for web URLs and app links
- **Route Guards**: Authentication and authorization checks
- **State Management Integration**: Seamless integration with Riverpod
- **Nested Navigation**: Support for complex navigation hierarchies
- **Performance Optimized**: Lazy loading and efficient route management
- **Testing Support**: Comprehensive testing utilities and patterns

---

## 🏗️ System Architecture

### Core Components

```dart
// lib/core/routing/router.dart
GoRouter buildRouter() => GoRouter(
  redirect: (context, state) {
    // Global redirect logic
    final prefs = Hive.box<dynamic>(HiveBoxes.prefs);
    final onboarded = prefs.get('onboarding_done') == true;
    final atOnboarding = state.uri.path == '/onboarding';
    
    if (!onboarded && !atOnboarding) return '/onboarding';
    if (onboarded && atOnboarding) return '/';
    return null;
  },
  routes: [
    // Route definitions
  ],
);
```

### Router Provider

```dart
// lib/core/routing/router_provider.dart
final routerProvider = Provider<GoRouter>((ref) {
  return buildRouter();
});

// Usage in main app
class PocketaApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    
    return MaterialApp.router(
      routerConfig: router,
      // ... other configuration
    );
  }
}
```

---

## 🛣️ GoRouter Configuration

### Basic Router Setup

```dart
// lib/core/routing/router.dart
GoRouter buildRouter() => GoRouter(
  // Global configuration
  initialLocation: '/',
  debugLogDiagnostics: kDebugMode,
  
  // Global redirect logic
  redirect: (context, state) {
    return _handleGlobalRedirect(context, state);
  },
  
  // Error handling
  errorBuilder: (context, state) => ErrorScreen(error: state.error),
  
  // Route definitions
  routes: [
    // Main routes
    _buildMainRoutes(),
    _buildOnboardingRoutes(),
    _buildTransactionRoutes(),
    _buildSettingsRoutes(),
  ],
);
```

### Advanced Router Configuration

```dart
// lib/core/routing/advanced_router.dart
GoRouter buildAdvancedRouter() => GoRouter(
  // Configuration
  initialLocation: '/',
  debugLogDiagnostics: kDebugMode,
  
  // Global redirects
  redirect: (context, state) => _handleGlobalRedirect(context, state),
  
  // Refresh listeners
  refreshListenable: GoRouterRefreshStream(
    Stream.periodic(const Duration(seconds: 1)),
  ),
  
  // Error handling
  errorBuilder: (context, state) => ErrorScreen(error: state.error),
  
  // Route information parser
  routeInformationParser: _CustomRouteInformationParser(),
  
  // Router delegate
  routerDelegate: _CustomRouterDelegate(),
  
  // Routes
  routes: _buildAllRoutes(),
);
```

---

## 🗺️ Route Definitions

### Main Routes

```dart
// lib/core/routing/routes/main_routes.dart
List<RouteBase> _buildMainRoutes() => [
  GoRoute(
    path: '/',
    name: 'dashboard',
    builder: (context, state) => const DashboardScreen(),
    routes: [
      GoRoute(
        path: 'profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: 'settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
        routes: [
          GoRoute(
            path: 'theme',
            name: 'theme_settings',
            builder: (context, state) => const ThemeSettingsScreen(),
          ),
          GoRoute(
            path: 'language',
            name: 'language_settings',
            builder: (context, state) => const LanguageSettingsScreen(),
          ),
        ],
      ),
    ],
  ),
];
```

### Onboarding Routes

```dart
// lib/core/routing/routes/onboarding_routes.dart
List<RouteBase> _buildOnboardingRoutes() => [
  GoRoute(
    path: '/onboarding',
    name: 'onboarding',
    builder: (context, state) => const OnboardingScreen(),
    routes: [
      GoRoute(
        path: 'welcome',
        name: 'onboarding_welcome',
        builder: (context, state) => const OnboardingWelcomeScreen(),
      ),
      GoRoute(
        path: 'persona',
        name: 'onboarding_persona',
        builder: (context, state) => const OnboardingPersonaScreen(),
      ),
      GoRoute(
        path: 'demo',
        name: 'onboarding_demo',
        builder: (context, state) => const OnboardingDemoScreen(),
      ),
      GoRoute(
        path: 'habit',
        name: 'onboarding_habit',
        builder: (context, state) => const OnboardingHabitScreen(),
      ),
    ],
  ),
];
```

### Transaction Routes

```dart
// lib/core/routing/routes/transaction_routes.dart
List<RouteBase> _buildTransactionRoutes() => [
  GoRoute(
    path: '/transactions',
    name: 'transactions',
    builder: (context, state) => const TransactionListScreen(),
    routes: [
      GoRoute(
        path: 'add',
        name: 'add_transaction',
        builder: (context, state) => const AddTransactionScreen(),
      ),
      GoRoute(
        path: 'edit/:id',
        name: 'edit_transaction',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return EditTransactionScreen(transactionId: id);
        },
      ),
      GoRoute(
        path: 'details/:id',
        name: 'transaction_details',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return TransactionDetailsScreen(transactionId: id);
        },
      ),
    ],
  ),
];
```

### Settings Routes

```dart
// lib/core/routing/routes/settings_routes.dart
List<RouteBase> _buildSettingsRoutes() => [
  GoRoute(
    path: '/settings',
    name: 'settings',
    builder: (context, state) => const SettingsScreen(),
    routes: [
      GoRoute(
        path: 'profile',
        name: 'profile_settings',
        builder: (context, state) => const ProfileSettingsScreen(),
      ),
      GoRoute(
        path: 'security',
        name: 'security_settings',
        builder: (context, state) => const SecuritySettingsScreen(),
      ),
      GoRoute(
        path: 'backup',
        name: 'backup_settings',
        builder: (context, state) => const BackupSettingsScreen(),
      ),
      GoRoute(
        path: 'about',
        name: 'about_settings',
        builder: (context, state) => const AboutScreen(),
      ),
    ],
  ),
];
```

---

## 🧭 Navigation Patterns

### Basic Navigation

```dart
// Using GoRouter context extension
class NavigationExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => context.go('/transactions'),
          child: Text('Go to Transactions'),
        ),
        ElevatedButton(
          onPressed: () => context.goNamed('add_transaction'),
          child: Text('Add Transaction'),
        ),
        ElevatedButton(
          onPressed: () => context.push('/transactions/add'),
          child: Text('Push Add Transaction'),
        ),
      ],
    );
  }
}
```

### Navigation with Parameters

```dart
// Navigation with path parameters
class TransactionNavigation extends StatelessWidget {
  final String transactionId;
  
  const TransactionNavigation({required this.transactionId});
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => context.go('/transactions/details/$transactionId'),
      child: Text('View Details'),
    );
  }
}

// Navigation with query parameters
class SearchNavigation extends StatelessWidget {
  final String query;
  
  const SearchNavigation({required this.query});
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => context.go('/transactions?search=$query'),
      child: Text('Search Transactions'),
    );
  }
}
```

### Navigation with State

```dart
// Navigation with extra data
class TransactionNavigation extends StatelessWidget {
  final TransactionEntity transaction;
  
  const TransactionNavigation({required this.transaction});
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => context.go(
        '/transactions/edit',
        extra: transaction,
      ),
      child: Text('Edit Transaction'),
    );
  }
}
```

### Nested Navigation

```dart
// Nested navigation example
class NestedNavigationExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () => context.go('/settings'),
            child: Text('Go to Settings'),
          ),
          ElevatedButton(
            onPressed: () => context.go('/settings/theme'),
            child: Text('Go to Theme Settings'),
          ),
          ElevatedButton(
            onPressed: () => context.go('/settings/language'),
            child: Text('Go to Language Settings'),
          ),
        ],
      ),
    );
  }
}
```

---

## 🛡️ Route Guards and Redirects

### Authentication Guard

```dart
// lib/core/routing/guards/auth_guard.dart
class AuthGuard {
  static String? checkAuth(BuildContext context, GoRouterState state) {
    final authService = context.read(authServiceProvider);
    
    if (!authService.isAuthenticated) {
      return '/login';
    }
    
    return null;
  }
}

// Usage in router
GoRouter buildRouter() => GoRouter(
  redirect: (context, state) {
    // Check authentication
    final authRedirect = AuthGuard.checkAuth(context, state);
    if (authRedirect != null) return authRedirect;
    
    // Other redirects
    return null;
  },
  routes: [
    // Routes
  ],
);
```

### Onboarding Guard

```dart
// lib/core/routing/guards/onboarding_guard.dart
class OnboardingGuard {
  static String? checkOnboarding(BuildContext context, GoRouterState state) {
    final prefs = Hive.box<dynamic>(HiveBoxes.prefs);
    final onboarded = prefs.get('onboarding_done') == true;
    final atOnboarding = state.uri.path.startsWith('/onboarding');
    
    if (!onboarded && !atOnboarding) {
      return '/onboarding';
    }
    
    if (onboarded && atOnboarding) {
      return '/';
    }
    
    return null;
  }
}
```

### Role-based Guard

```dart
// lib/core/routing/guards/role_guard.dart
class RoleGuard {
  static String? checkRole(BuildContext context, GoRouterState state) {
    final userService = context.read(userServiceProvider);
    final user = userService.currentUser;
    
    if (user == null) return '/login';
    
    // Check if user has required role for admin routes
    if (state.uri.path.startsWith('/admin') && !user.isAdmin) {
      return '/unauthorized';
    }
    
    return null;
  }
}
```

### Custom Redirect Logic

```dart
// lib/core/routing/redirects/custom_redirects.dart
class CustomRedirects {
  static String? handleRedirect(BuildContext context, GoRouterState state) {
    // Check onboarding
    final onboardingRedirect = OnboardingGuard.checkOnboarding(context, state);
    if (onboardingRedirect != null) return onboardingRedirect;
    
    // Check authentication
    final authRedirect = AuthGuard.checkAuth(context, state);
    if (authRedirect != null) return authRedirect;
    
    // Check role
    final roleRedirect = RoleGuard.checkRole(context, state);
    if (roleRedirect != null) return roleRedirect;
    
    // Check maintenance mode
    final maintenanceRedirect = MaintenanceGuard.checkMaintenance(context, state);
    if (maintenanceRedirect != null) return maintenanceRedirect;
    
    return null;
  }
}
```

---

## 🔗 Deep Linking

### Deep Link Configuration

```dart
// lib/core/routing/deep_links.dart
class DeepLinkHandler {
  static void handleDeepLink(String link) {
    final uri = Uri.parse(link);
    
    switch (uri.host) {
      case 'transaction':
        _handleTransactionDeepLink(uri);
        break;
      case 'budget':
        _handleBudgetDeepLink(uri);
        break;
      case 'wallet':
        _handleWalletDeepLink(uri);
        break;
      default:
        _handleDefaultDeepLink(uri);
    }
  }
  
  static void _handleTransactionDeepLink(Uri uri) {
    final id = uri.pathSegments.last;
    // Navigate to transaction details
    GoRouter.of(navigatorKey.currentContext!).go('/transactions/details/$id');
  }
  
  static void _handleBudgetDeepLink(Uri uri) {
    final category = uri.queryParameters['category'];
    // Navigate to budget for specific category
    GoRouter.of(navigatorKey.currentContext!).go('/budgets?category=$category');
  }
  
  static void _handleWalletDeepLink(Uri uri) {
    final walletId = uri.pathSegments.last;
    // Navigate to wallet details
    GoRouter.of(navigatorKey.currentContext!).go('/wallets/details/$walletId');
  }
}
```

### URL Configuration

```dart
// lib/core/routing/url_config.dart
class URLConfig {
  static const String baseUrl = 'https://pocketa.app';
  
  static String getTransactionUrl(String transactionId) {
    return '$baseUrl/transaction/$transactionId';
  }
  
  static String getBudgetUrl(String category) {
    return '$baseUrl/budget?category=$category';
  }
  
  static String getWalletUrl(String walletId) {
    return '$baseUrl/wallet/$walletId';
  }
  
  static String getShareUrl(String type, String id) {
    return '$baseUrl/share/$type/$id';
  }
}
```

### Deep Link Testing

```dart
// test/deep_link_test.dart
void main() {
  group('Deep Link Tests', () {
    testWidgets('handles transaction deep link', (tester) async {
      await tester.pumpWidget(MyApp());
      
      // Simulate deep link
      final deepLink = 'https://pocketa.app/transaction/123';
      DeepLinkHandler.handleDeepLink(deepLink);
      
      await tester.pumpAndSettle();
      
      // Verify navigation
      expect(find.byType(TransactionDetailsScreen), findsOneWidget);
    });
  });
}
```

---

## 🔄 State Management Integration

### Router State Provider

```dart
// lib/core/routing/router_state_provider.dart
final routerStateProvider = StreamProvider<GoRouterState>((ref) {
  final router = ref.watch(routerProvider);
  return router.routerDelegate.currentConfiguration;
});

// Usage in widgets
class RouteAwareWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routerState = ref.watch(routerStateProvider);
    
    return routerState.when(
      data: (state) => Text('Current route: ${state.uri.path}'),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}
```

### Navigation State Management

```dart
// lib/core/routing/navigation_state_provider.dart
class NavigationStateNotifier extends StateNotifier<NavigationState> {
  NavigationStateNotifier() : super(NavigationState.initial());
  
  void navigateTo(String path) {
    state = state.copyWith(
      currentPath: path,
      navigationHistory: [...state.navigationHistory, path],
    );
  }
  
  void goBack() {
    if (state.navigationHistory.length > 1) {
      final newHistory = List<String>.from(state.navigationHistory);
      newHistory.removeLast();
      state = state.copyWith(
        currentPath: newHistory.last,
        navigationHistory: newHistory,
      );
    }
  }
  
  void clearHistory() {
    state = NavigationState.initial();
  }
}

final navigationStateProvider = StateNotifierProvider<NavigationStateNotifier, NavigationState>((ref) {
  return NavigationStateNotifier();
});
```

### Route-based State Management

```dart
// lib/core/routing/route_state_provider.dart
final routeStateProvider = Provider<RouteState>((ref) {
  final router = ref.watch(routerProvider);
  final currentRoute = router.routerDelegate.currentConfiguration;
  
  return RouteState(
    currentPath: currentRoute.uri.path,
    pathParameters: currentRoute.pathParameters,
    queryParameters: currentRoute.queryParameters,
    extra: currentRoute.extra,
  );
});

// Usage
class RouteStateWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routeState = ref.watch(routeStateProvider);
    
    return Column(
      children: [
        Text('Current Path: ${routeState.currentPath}'),
        Text('Path Parameters: ${routeState.pathParameters}'),
        Text('Query Parameters: ${routeState.queryParameters}'),
      ],
    );
  }
}
```

---

## 🚀 Implementation Examples

### Complete Router Setup

```dart
// lib/core/routing/router.dart
GoRouter buildRouter() => GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: kDebugMode,
  
  redirect: (context, state) => CustomRedirects.handleRedirect(context, state),
  
  errorBuilder: (context, state) => ErrorScreen(error: state.error),
  
  routes: [
    // Main routes
    GoRoute(
      path: '/',
      name: 'dashboard',
      builder: (context, state) => const DashboardScreen(),
      routes: [
        GoRoute(
          path: 'profile',
          name: 'profile',
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: 'settings',
          name: 'settings',
          builder: (context, state) => const SettingsScreen(),
          routes: [
            GoRoute(
              path: 'theme',
              name: 'theme_settings',
              builder: (context, state) => const ThemeSettingsScreen(),
            ),
            GoRoute(
              path: 'language',
              name: 'language_settings',
              builder: (context, state) => const LanguageSettingsScreen(),
            ),
          ],
        ),
      ],
    ),
    
    // Onboarding routes
    GoRoute(
      path: '/onboarding',
      name: 'onboarding',
      builder: (context, state) => const OnboardingScreen(),
      routes: [
        GoRoute(
          path: 'welcome',
          name: 'onboarding_welcome',
          builder: (context, state) => const OnboardingWelcomeScreen(),
        ),
        GoRoute(
          path: 'persona',
          name: 'onboarding_persona',
          builder: (context, state) => const OnboardingPersonaScreen(),
        ),
        GoRoute(
          path: 'demo',
          name: 'onboarding_demo',
          builder: (context, state) => const OnboardingDemoScreen(),
        ),
        GoRoute(
          path: 'habit',
          name: 'onboarding_habit',
          builder: (context, state) => const OnboardingHabitScreen(),
        ),
      ],
    ),
    
    // Transaction routes
    GoRoute(
      path: '/transactions',
      name: 'transactions',
      builder: (context, state) => const TransactionListScreen(),
      routes: [
        GoRoute(
          path: 'add',
          name: 'add_transaction',
          builder: (context, state) => const AddTransactionScreen(),
        ),
        GoRoute(
          path: 'edit/:id',
          name: 'edit_transaction',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return EditTransactionScreen(transactionId: id);
          },
        ),
        GoRoute(
          path: 'details/:id',
          name: 'transaction_details',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return TransactionDetailsScreen(transactionId: id);
          },
        ),
      ],
    ),
    
    // Budget routes
    GoRoute(
      path: '/budgets',
      name: 'budgets',
      builder: (context, state) => const BudgetListScreen(),
      routes: [
        GoRoute(
          path: 'add',
          name: 'add_budget',
          builder: (context, state) => const AddBudgetScreen(),
        ),
        GoRoute(
          path: 'edit/:id',
          name: 'edit_budget',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return EditBudgetScreen(budgetId: id);
          },
        ),
      ],
    ),
    
    // Wallet routes
    GoRoute(
      path: '/wallets',
      name: 'wallets',
      builder: (context, state) => const WalletListScreen(),
      routes: [
        GoRoute(
          path: 'add',
          name: 'add_wallet',
          builder: (context, state) => const AddWalletScreen(),
        ),
        GoRoute(
          path: 'edit/:id',
          name: 'edit_wallet',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return EditWalletScreen(walletId: id);
          },
        ),
      ],
    ),
    
    // Error routes
    GoRoute(
      path: '/error',
      name: 'error',
      builder: (context, state) => ErrorScreen(error: state.error),
    ),
    
    GoRoute(
      path: '/unauthorized',
      name: 'unauthorized',
      builder: (context, state) => const UnauthorizedScreen(),
    ),
  ],
);
```

### Navigation Service

```dart
// lib/core/routing/navigation_service.dart
class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  
  static BuildContext get context => navigatorKey.currentContext!;
  
  static GoRouter get router => GoRouter.of(context);
  
  // Navigation methods
  static void go(String path) => router.go(path);
  static void goNamed(String name, {Map<String, String>? pathParameters, Map<String, String>? queryParameters, Object? extra}) {
    router.goNamed(name, pathParameters: pathParameters, queryParameters: queryParameters, extra: extra);
  }
  
  static void push(String path) => router.push(path);
  static void pushNamed(String name, {Map<String, String>? pathParameters, Map<String, String>? queryParameters, Object? extra}) {
    router.pushNamed(name, pathParameters: pathParameters, queryParameters: queryParameters, extra: extra);
  }
  
  static void pop([Object? result]) => router.pop(result);
  static void goBack() => router.pop();
  
  // Utility methods
  static bool canPop() => router.canPop();
  static String get currentPath => router.routerDelegate.currentConfiguration.uri.path;
  static Map<String, String> get pathParameters => router.routerDelegate.currentConfiguration.pathParameters;
  static Map<String, String> get queryParameters => router.routerDelegate.currentConfiguration.queryParameters;
}
```

### Route-aware Widget

```dart
// lib/core/routing/route_aware_widget.dart
class RouteAwareWidget extends ConsumerWidget {
  final Widget child;
  final String routeName;
  
  const RouteAwareWidget({
    super.key,
    required this.child,
    required this.routeName,
  });
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routerState = ref.watch(routerStateProvider);
    
    return routerState.when(
      data: (state) {
        final isCurrentRoute = state.name == routeName;
        
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: isCurrentRoute ? child : const SizedBox.shrink(),
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => ErrorWidget(error),
    );
  }
}
```

---

## ⚡ Performance Optimization

### Lazy Loading

```dart
// lib/core/routing/lazy_loading.dart
class LazyRouteBuilder {
  static Widget buildLazyRoute(String routeName, Widget Function() builder) {
    return LazyBuilder(
      builder: (context) => builder(),
    );
  }
}

// Usage in router
GoRoute(
  path: '/heavy-screen',
  name: 'heavy_screen',
  builder: (context, state) => LazyRouteBuilder.buildLazyRoute(
    'heavy_screen',
    () => HeavyScreen(),
  ),
);
```

### Route Caching

```dart
// lib/core/routing/route_cache.dart
class RouteCache {
  static final Map<String, Widget> _cache = {};
  
  static Widget getCachedRoute(String routeName, Widget Function() builder) {
    if (!_cache.containsKey(routeName)) {
      _cache[routeName] = builder();
    }
    return _cache[routeName]!;
  }
  
  static void clearCache() {
    _cache.clear();
  }
  
  static void removeFromCache(String routeName) {
    _cache.remove(routeName);
  }
}
```

### Memory Management

```dart
// lib/core/routing/memory_management.dart
class RouteMemoryManager {
  static final List<String> _routeHistory = [];
  static const int maxHistorySize = 10;
  
  static void addToHistory(String routeName) {
    _routeHistory.add(routeName);
    
    if (_routeHistory.length > maxHistorySize) {
      _routeHistory.removeAt(0);
    }
  }
  
  static void clearHistory() {
    _routeHistory.clear();
  }
  
  static List<String> get history => List.unmodifiable(_routeHistory);
}
```

---

## 🧪 Testing Routing

### Router Test Utilities

```dart
// test/routing_test_utils.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:pocketa/core/routing/router.dart';

class RouterTestUtils {
  static Widget createTestApp({String initialLocation = '/'}) {
    return MaterialApp.router(
      routerConfig: buildRouter(),
      initialLocation: initialLocation,
    );
  }
  
  static void expectCurrentRoute(WidgetTester tester, String expectedRoute) {
    final router = GoRouter.of(tester.element(find.byType(MaterialApp)));
    expect(router.routerDelegate.currentConfiguration.uri.path, expectedRoute);
  }
  
  static void expectCurrentRouteName(WidgetTester tester, String expectedName) {
    final router = GoRouter.of(tester.element(find.byType(MaterialApp)));
    expect(router.routerDelegate.currentConfiguration.name, expectedName);
  }
  
  static void navigateTo(WidgetTester tester, String path) {
    final router = GoRouter.of(tester.element(find.byType(MaterialApp)));
    router.go(path);
    tester.pumpAndSettle();
  }
}
```

### Router Unit Tests

```dart
// test/router_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:pocketa/core/routing/router.dart';

void main() {
  group('Router Tests', () {
    test('router is created successfully', () {
      final router = buildRouter();
      expect(router, isNotNull);
    });
    
    test('initial location is correct', () {
      final router = buildRouter();
      expect(router.initialLocation, '/');
    });
    
    test('routes are defined correctly', () {
      final router = buildRouter();
      expect(router.configuration.routes, isNotEmpty);
    });
  });
}
```

### Navigation Widget Tests

```dart
// test/navigation_widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pocketa/core/routing/router.dart';

void main() {
  group('Navigation Widget Tests', () {
    testWidgets('navigates to transactions screen', (tester) async {
      await tester.pumpWidget(RouterTestUtils.createTestApp());
      
      // Find and tap navigation button
      await tester.tap(find.text('Transactions'));
      await tester.pumpAndSettle();
      
      // Verify navigation
      RouterTestUtils.expectCurrentRoute(tester, '/transactions');
    });
    
    testWidgets('navigates to add transaction screen', (tester) async {
      await tester.pumpWidget(RouterTestUtils.createTestApp());
      
      // Navigate to transactions first
      RouterTestUtils.navigateTo(tester, '/transactions');
      
      // Tap add button
      await tester.tap(find.text('Add Transaction'));
      await tester.pumpAndSettle();
      
      // Verify navigation
      RouterTestUtils.expectCurrentRoute(tester, '/transactions/add');
    });
    
    testWidgets('handles back navigation', (tester) async {
      await tester.pumpWidget(RouterTestUtils.createTestApp());
      
      // Navigate to transactions
      RouterTestUtils.navigateTo(tester, '/transactions');
      
      // Navigate to add transaction
      RouterTestUtils.navigateTo(tester, '/transactions/add');
      
      // Go back
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      
      // Verify back navigation
      RouterTestUtils.expectCurrentRoute(tester, '/transactions');
    });
  });
}
```

### Deep Link Tests

```dart
// test/deep_link_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:pocketa/core/routing/deep_links.dart';

void main() {
  group('Deep Link Tests', () {
    test('handles transaction deep link', () {
      const deepLink = 'https://pocketa.app/transaction/123';
      
      expect(() => DeepLinkHandler.handleDeepLink(deepLink), returnsNormally);
    });
    
    test('handles budget deep link', () {
      const deepLink = 'https://pocketa.app/budget?category=food';
      
      expect(() => DeepLinkHandler.handleDeepLink(deepLink), returnsNormally);
    });
    
    test('handles wallet deep link', () {
      const deepLink = 'https://pocketa.app/wallet/456';
      
      expect(() => DeepLinkHandler.handleDeepLink(deepLink), returnsNormally);
    });
  });
}
```

---

## 🔄 Migration Guide

### From Navigator 1.0 to GoRouter

```dart
// Before - Navigator 1.0
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => TransactionDetailsScreen(transactionId: id),
  ),
);

// After - GoRouter
context.push('/transactions/details/$id');
```

### From Named Routes to GoRouter

```dart
// Before - Named routes
Navigator.pushNamed(context, '/transactions', arguments: {'id': id});

// After - GoRouter
context.goNamed('transactions', pathParameters: {'id': id});
```

### From Custom Router to GoRouter

```dart
// Before - Custom router
class CustomRouter {
  static void navigateTo(String route) {
    // Custom navigation logic
  }
}

// After - GoRouter
context.go(route);
```

---

## 📦 Reusable Package Setup

### Package Structure

```
pocketa_routing/
├── lib/
│   ├── routing.dart                # Main export
│   ├── router.dart                 # Router configuration
│   ├── routes/
│   │   ├── main_routes.dart
│   │   ├── onboarding_routes.dart
│   │   ├── transaction_routes.dart
│   │   └── settings_routes.dart
│   ├── guards/
│   │   ├── auth_guard.dart
│   │   ├── onboarding_guard.dart
│   │   └── role_guard.dart
│   ├── services/
│   │   ├── navigation_service.dart
│   │   └── deep_link_handler.dart
│   └── utils/
│       ├── route_cache.dart
│       └── memory_management.dart
├── test/
│   ├── router_test.dart
│   ├── navigation_test.dart
│   └── routing_test_utils.dart
├── example/
│   └── lib/
│       └── main.dart
├── pubspec.yaml
└── README.md
```

### Package pubspec.yaml

```yaml
name: pocketa_routing
description: Advanced routing system for Flutter applications
version: 1.0.0

environment:
  sdk: '>=3.0.0 <4.0.0'
  flutter: ">=3.10.0"

dependencies:
  flutter:
    sdk: flutter
  go_router: ^12.0.0
  flutter_riverpod: ^2.4.0
  hive: ^2.2.3

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0

flutter:
  uses-material-design: true
```

### Usage in Other Projects

```dart
// pubspec.yaml
dependencies:
  pocketa_routing:
    git:
      url: https://github.com/your-org/pocketa_routing.git
      ref: main

// In your app
import 'package:pocketa_routing/routing.dart';

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    
    return MaterialApp.router(
      routerConfig: router,
      home: MyHomePage(),
    );
  }
}

// In your widgets
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () => context.go('/transactions'),
      child: Text('Go to Transactions'),
    );
  }
}
```

---

This comprehensive routing system guide provides everything needed to implement, maintain, and extend navigation across multiple projects. The system is designed to be scalable, performant, and easy to use while providing powerful routing capabilities.
