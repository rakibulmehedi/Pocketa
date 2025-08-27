import 'package:go_router/go_router.dart';
import 'package:pocketa/features/dashboard/presentation/dashboard_screen.dart';
import 'package:pocketa/features/onboarding/presentation/welcome_screen.dart';
import 'package:pocketa/features/transaction/screens/add_edit_transaction_screen.dart';
import 'package:pocketa/features/transaction/screens/transaction_list_screen.dart';

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
      name: 'add or edit transaction',
      builder: (context, state) => AddEditTransactionScreen(),
    ),
    GoRoute(
      path: '/transactions',
      name: 'transactions',
      builder: (context, state) => TransactionListScreen(),
    ),
  ],
);
