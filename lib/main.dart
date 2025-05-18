import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/config/router/routes.dart';

import 'config/provider/language_provider.dart';
import 'config/provider/theme_provider.dart';
import 'core/themes/app_theme.dart';
import 'features/onboarding/view/income_source_selection_view.dart';
import 'features/onboarding/view/onboarding_screen.dart';
import 'features/onboarding/view/splash_screen.dart';
import 'features/onboarding/view/welcome_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'l10n/app_localization.dart';

void main() {
  runApp(
    ProviderScope(
      child: DevicePreview(
        enabled: true,
        builder: (context) => const PocketaApp(),
      ),
    ),
  );
}

class PocketaApp extends ConsumerWidget {
  const PocketaApp({super.key});

  // This widgets is the root of this application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkModeProvider);
    final lang = ref.watch(languageProvider);
    return MaterialApp(
      locale:
          lang == AppLanguage.bangla ? const Locale('bn') : const Locale('en'),
      supportedLocales: const [Locale('en'), Locale('bn')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      builder: DevicePreview.appBuilder,
      title: 'Pocketa',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(context, lang),
      darkTheme: AppTheme.darkTheme(context, lang),
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      initialRoute: '/',
      routes: appRoutes
    );
  }
}
