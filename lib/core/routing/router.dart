import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pocketa/core/db/hive_box.dart';
import 'package:pocketa/features/dashboard/presentation/pages/dashboard_screen.dart';
import 'package:pocketa/features/onboarding/presentation/pages/onboarding_screen.dart';
import 'package:pocketa/features/transaction/presentation/pages/pages.dart';

GoRouter buildRouter() => GoRouter(
  redirect: (context, state) {
    final prefs = Hive.box<dynamic>(HiveBoxes.prefs);
    final onboarded = prefs.get('onboarding_done') == true;
    final atOnboarding = state.uri.path == '/onboarding';
    if (!onboarded && !atOnboarding) return '/onboarding';
    if (onboarded && atOnboarding) return '/';
    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      name: 'dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      name: 'onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/transactions/add_edit',
      name: 'transactions',
      builder: (context, state) => TransactionListScreen(),
    ),
  ],
);
