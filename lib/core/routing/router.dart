import 'package:go_router/go_router.dart';
import 'package:pocketa/features/dashboard/presentation/pages/dashboard_screen.dart';
import 'package:pocketa/features/onboarding/presentation/pages/welcome_screen.dart';
import 'package:pocketa/features/transaction/domain/domain.dart';
import 'package:pocketa/features/transaction/presentation/pages/pages.dart';

GoRouter buildRouter() => GoRouter(
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
        return AddEditTransactionScreen(initial: tx,);
      },
    ),
    GoRoute(
      path: '/transactions/add_edit',
      name: 'transactions',
      builder: (context, state) => TransactionListScreen(),
    ),
  ],
);
