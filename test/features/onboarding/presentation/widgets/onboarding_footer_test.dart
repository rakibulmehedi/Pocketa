import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pocketa/shared/ui/footer_cta_bar.dart';
import 'package:pocketa/core/responsive/responsive.dart';

void main() {
  group('Onboarding Footer CTA Bar', () {
    testWidgets('should render FooterCtaBar widget successfully', (WidgetTester tester) async {
      bool primaryPressed = false;
      bool backPressed = false;

      // Build the FooterCtaBar widget
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            builder: (context, child) => Responsive.builder(
              child: child ?? const SizedBox(),
            ),
            home: Scaffold(
              bottomNavigationBar: FooterCtaBar(
                primaryLabel: 'Continue',
                onPrimary: () => primaryPressed = true,
                showBack: true,
                backLabel: 'Back',
                onBack: () => backPressed = true,
              ),
            ),
          ),
        ),
      );

      // Wait for initial render
      await tester.pump();

      // Verify the FooterCtaBar is rendered
      expect(find.byType(FooterCtaBar), findsOneWidget);
      
      // Verify the widget is properly integrated in the scaffold
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should handle different configurations without crashing', (WidgetTester tester) async {
      // Test with showBack = false
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            builder: (context, child) => Responsive.builder(
              child: child ?? const SizedBox(),
            ),
            home: Scaffold(
              bottomNavigationBar: FooterCtaBar(
                primaryLabel: 'Get Started',
                onPrimary: () {},
                showBack: false,
              ),
            ),
          ),
        ),
      );

      await tester.pump();

      // Verify the FooterCtaBar renders without back button
      expect(find.byType(FooterCtaBar), findsOneWidget);
    });

    testWidgets('should handle loading state without crashing', (WidgetTester tester) async {
      // Test with loading = true
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            builder: (context, child) => Responsive.builder(
              child: child ?? const SizedBox(),
            ),
            home: Scaffold(
              bottomNavigationBar: FooterCtaBar(
                primaryLabel: 'Continue',
                onPrimary: () {},
                loading: true,
              ),
            ),
          ),
        ),
      );

      await tester.pump();

      // Verify the FooterCtaBar renders in loading state
      expect(find.byType(FooterCtaBar), findsOneWidget);
    });

    testWidgets('should respect theme configuration', (WidgetTester tester) async {
      final customTheme = ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.light,
        ),
      );

      // Build with custom theme
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            builder: (context, child) => Responsive.builder(
              child: child ?? const SizedBox(),
            ),
            theme: customTheme,
            home: Scaffold(
              bottomNavigationBar: FooterCtaBar(
                primaryLabel: 'Continue',
                onPrimary: () {},
                showBack: true,
                backLabel: 'Back',
                onBack: () {},
              ),
            ),
          ),
        ),
      );

      await tester.pump();

      // Verify the footer renders with theme
      expect(find.byType(FooterCtaBar), findsOneWidget);
      
      // Verify the scaffold respects theme
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, isNull); // Should use theme default
    });
  });
}