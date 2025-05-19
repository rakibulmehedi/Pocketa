import 'package:flutter/material.dart';
import 'package:pocketa/features/onboarding/view/income_source_selection_view.dart';
import 'package:pocketa/features/onboarding/view/onboarding_screen.dart';
import 'package:pocketa/features/onboarding/view/splash_screen.dart';
import 'package:pocketa/features/onboarding/view/welcome_screen.dart';

Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const SplashScreen(),
  '/welcome': (context) => const WelcomeScreen(),
  '/onboarding': (context) => const OnboardingScreen(),
  '/onboarding/income-source': (context) => const IncomeSourceSelectionScreen(),
  '/onboarding/income-range': (context) => const IncomeSourceSelectionScreen(),
};
