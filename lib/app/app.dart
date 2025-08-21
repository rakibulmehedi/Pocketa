import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/app/router.dart';
import 'package:pocketa/app/theme/app_theme.dart';
import 'package:pocketa/core/locale/local_notifier.dart';
import 'package:pocketa/l10n/app_localizations.dart';

class PocketaApp extends ConsumerWidget {
  const PocketaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = buildRouter();
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      title: 'Pocketa',
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,

      locale: locale,
      supportedLocales: const [Locale('en'), Locale('bn')],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
