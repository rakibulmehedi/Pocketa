import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pocketa/features/dashboard/presentation/pages/dashboard_screen.dart';
import 'package:pocketa/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pocketa/core/responsive/responsive.dart';

void main() {
  group('Dashboard Screen Background', () {
    Widget buildDashboardWithTheme(ThemeData theme) {
      return ProviderScope(
        child: MaterialApp(
          builder: (context, child) => Responsive.builder(
            child: child ?? const SizedBox(),
          ),
          theme: theme,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''),
            Locale('bn', ''),
          ],
          home: const DashboardScreen(),
        ),
      );
    }

    testWidgets('should respect light theme colorScheme.surface background', (WidgetTester tester) async {
      const surfaceColor = Color(0xFFFAFAFA);
      
      final lightTheme = ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ).copyWith(surface: surfaceColor),
      );

      await tester.pumpWidget(buildDashboardWithTheme(lightTheme));
      await tester.pumpAndSettle();

      // Find the main Scaffold
      final scaffoldFinder = find.byType(Scaffold);
      expect(scaffoldFinder, findsOneWidget);

      // Get the scaffold widget and verify its background color
      final scaffold = tester.widget<Scaffold>(scaffoldFinder);
      
      // The scaffold should either use the theme's surface color or null (default)
      // If null, it uses the theme's colorScheme.surface by default
      expect(
        scaffold.backgroundColor == null || scaffold.backgroundColor == surfaceColor,
        isTrue,
        reason: 'Scaffold should use theme surface color or null (which defaults to theme surface)',
      );
    });

    testWidgets('should respect dark theme colorScheme.surface background', (WidgetTester tester) async {
      const darkSurfaceColor = Color(0xFF121212);
      
      final darkTheme = ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ).copyWith(surface: darkSurfaceColor),
      );

      await tester.pumpWidget(buildDashboardWithTheme(darkTheme));
      await tester.pumpAndSettle();

      // Find the main Scaffold
      final scaffoldFinder = find.byType(Scaffold);
      expect(scaffoldFinder, findsOneWidget);

      // Get the scaffold widget and verify its background color
      final scaffold = tester.widget<Scaffold>(scaffoldFinder);
      
      // The scaffold should either use the theme's surface color or null (default)
      expect(
        scaffold.backgroundColor == null || scaffold.backgroundColor == darkSurfaceColor,
        isTrue,
        reason: 'Scaffold should use theme surface color or null (which defaults to theme surface)',
      );
    });

    testWidgets('should not use hardcoded background colors', (WidgetTester tester) async {
      final customTheme = ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.light,
        ).copyWith(surface: Colors.yellow), // Unusual color to test theme usage
      );

      await tester.pumpWidget(buildDashboardWithTheme(customTheme));
      await tester.pumpAndSettle();

      // Find the main Scaffold
      final scaffoldFinder = find.byType(Scaffold);
      expect(scaffoldFinder, findsOneWidget);

      // Get the scaffold widget
      final scaffold = tester.widget<Scaffold>(scaffoldFinder);
      
      // Verify it doesn't use hardcoded colors (should be null or match theme)
      if (scaffold.backgroundColor != null) {
        expect(
          scaffold.backgroundColor,
          equals(Colors.yellow),
          reason: 'If background color is set, it should match the theme surface color',
        );
      }
    });

    testWidgets('should render navigation bar with proper styling', (WidgetTester tester) async {
      final theme = ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      );

      await tester.pumpWidget(buildDashboardWithTheme(theme));
      await tester.pumpAndSettle();

      // Verify NavigationBar exists
      expect(find.byType(NavigationBar), findsOneWidget);

      // Verify navigation destinations are present
      expect(find.byType(NavigationDestination), findsAtLeast(3));

      // Verify the dashboard has proper structure
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should maintain theme consistency across different brightness modes', (WidgetTester tester) async {
      // Test both light and dark themes
      final themes = [
        ThemeData(
          brightness: Brightness.light,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light,
          ),
        ),
        ThemeData(
          brightness: Brightness.dark,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.dark,
          ),
        ),
      ];

      for (final theme in themes) {
        await tester.pumpWidget(buildDashboardWithTheme(theme));
        await tester.pumpAndSettle();

        // Find the main Scaffold
        final scaffoldFinder = find.byType(Scaffold);
        expect(scaffoldFinder, findsOneWidget);

        // Verify scaffold respects theme
        final scaffold = tester.widget<Scaffold>(scaffoldFinder);
        
        // Should either be null (uses theme default) or match theme surface
        if (scaffold.backgroundColor != null) {
          expect(
            scaffold.backgroundColor,
            equals(theme.colorScheme.surface),
            reason: 'Scaffold background should match theme surface color for ${theme.brightness} theme',
          );
        }
      }
    });
  });
}
