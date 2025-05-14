import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/core/constants/strings.dart';
import 'package:pocketa/core/themes/app_theme.dart';
import 'package:pocketa/features/onboarding/income_source_selection_screen.dart';
import 'package:pocketa/features/onboarding/splash_screen.dart';
import 'package:pocketa/features/onboarding/welcome_screen.dart';
import 'package:device_preview/device_preview.dart';

import 'core/provider/theme_provider.dart';

void main() {
  runApp(ProviderScope(child: DevicePreview(enabled: true, builder: (context) => const PocketaApp())));
}

class PocketaApp extends ConsumerWidget {
  const PocketaApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkModeProvider);
    return MaterialApp(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      title: AppString.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/welcome': (context) => const WelcomeScreen(),
        '/onboarding/income-source':
            (context) => const IncomeSourceSelectionScreen(),
        'onboarding/income-range':
            (context) => const IncomeSourceSelectionScreen(),
      },
    );
  }
}
