import 'package:go_router/go_router.dart';
import 'package:pocketa/features/dashboard/presentation/dashboard_screen.dart';
import 'package:pocketa/features/onboarding/presentation/welcome_screen.dart';

GoRouter buildRouter() => GoRouter(
  routes: [
    GoRoute(
      path: 'dashboard',
      name: 'dashboard',
      builder: (ctx, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/',
      name: 'welcome',
      builder: (ctx, state) => WelcomeScreen(),
    ),
  ],
);
