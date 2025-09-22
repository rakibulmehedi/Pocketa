import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow/core/locale/local_notifier.dart';
import 'package:flow/core/providers/theme_provider.dart';
import 'package:flow/core/routing/router.dart';
import 'package:flow/core/theme/app_theme.dart';
import 'package:flow/core/responsive/responsive.dart';
import 'package:flow/l10n/app_localizations.dart';

// 1) Hoist router so it isn't rebuilt every frame
final _appRouter = buildRouter();

// 2) Smooth, platform-aware scroll (no glow on desktop/web)
class _FlowScrollBehavior extends MaterialScrollBehavior {
  const _FlowScrollBehavior();
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
      };
}

// Flow - Personal Finance OS
class FlowApp extends ConsumerWidget {
  const FlowApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeProvider);

    return MaterialApp.router(
      // 3) Localized app title
      onGenerateTitle: (ctx) => AppLocalizations.of(ctx).appTitle,

      routerConfig: _appRouter,
      debugShowCheckedModeBanner: false,

      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,

      // 4) Locale wiring
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // 5) Consistent scrolling across platforms
        scrollBehavior: const _FlowScrollBehavior(),

      // 6) Your responsive wrapper stays last in the builder chain
      builder: (context, child) =>
          Responsive.builder(child: child ?? const SizedBox()),
    );
  }
}
