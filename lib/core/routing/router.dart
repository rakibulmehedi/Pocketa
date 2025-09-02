import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pocketa/core/db/hive_box.dart';
import 'package:pocketa/features/dashboard/presentation/pages/dashboard_screen.dart';
import 'package:pocketa/features/onboarding/presentation/pages/welcome_screen.dart';
import 'package:pocketa/features/transaction/domain/entities/transaction_entity.dart';
import 'package:pocketa/features/transaction/presentation/pages/pages.dart';

GoRouter buildRouter() => GoRouter(
  redirect: (context, state) {
    final prefs = Hive.box<dynamic>(HiveBoxes.prefs);
    final onboarded = prefs.get('onboarding_done') == true;
    final atWelcome = state.uri.path == '/welcome';
    if (!onboarded && !atWelcome) return '/welcome';
    if (onboarded && atWelcome) return '/';
    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      name: 'dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/welcome',
      name: 'welcome',
      builder: (context, state) => WelcomeScreen(),
    ),
    GoRoute(
      path: '/add_edit_transaction',
      name: 'add_edit_tx',
      builder: (context, state) {
        final tx = state.extra as TransactionEntity?;
        return AddEditTransactionScreen(initial: tx);
      },
    ),
    GoRoute(
      path: '/transactions/add_edit',
      name: 'transactions',
      builder: (context, state) => TransactionListScreen(),
    ),
  ],
);
