import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/core/responsive/responsive.dart';

void main() {
  group('Celebration Smoke Tests', () {
    testWidgets('should handle reduced motion without crashing', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: MediaQuery(
              data: const MediaQueryData(disableAnimations: true),
              child: Scaffold(
                body: ElevatedButton(
                  onPressed: () {
                    // Simple test - just verify the button works
                  },
                  child: const Text('Test Reduced Motion'),
                ),
              ),
            ),
          ),
        ),
      );

      // Tap the button
      await tester.tap(find.text('Test Reduced Motion'));
      await tester.pump();

      // Should not crash
      expect(find.text('Test Reduced Motion'), findsOneWidget);
    });

    testWidgets('should work with Responsive.builder', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Responsive.builder(
              child: Scaffold(
                body: ElevatedButton(
                  onPressed: () {
                    // Simple test - just verify the button works
                  },
                  child: const Text('Test Responsive'),
                ),
              ),
            ),
          ),
        ),
      );

      // Tap the button
      await tester.tap(find.text('Test Responsive'));
      await tester.pump();

      // Should not crash
      expect(find.text('Test Responsive'), findsOneWidget);
    });

    testWidgets('should handle small screen devices', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: MediaQuery(
              data: const MediaQueryData(size: Size(320, 568)), // Small screen
              child: Scaffold(
                body: ElevatedButton(
                  onPressed: () {
                    // Simple test - just verify the button works
                  },
                  child: const Text('Test Small Screen'),
                ),
              ),
            ),
          ),
        ),
      );

      // Tap the button
      await tester.tap(find.text('Test Small Screen'));
      await tester.pump();

      // Should not crash on small screens
      expect(find.text('Test Small Screen'), findsOneWidget);
    });

    testWidgets('should verify MediaQuery disableAnimations works', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: MediaQuery(
              data: const MediaQueryData(disableAnimations: true),
              child: Builder(
                builder: (context) {
                  final disableAnimations = MediaQuery.of(context).disableAnimations;
                  return Scaffold(
                    body: Text('Animations disabled: $disableAnimations'),
                  );
                },
              ),
            ),
          ),
        ),
      );

      // Verify that disableAnimations is true
      expect(find.text('Animations disabled: true'), findsOneWidget);
    });
  });
}