import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pocketa/shared/motion/confetti_v2.dart';
import 'package:pocketa/core/responsive/responsive.dart';

void main() {
  group('ConfettiOverlay', () {
    testWidgets('should show confetti overlay when created', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => Responsive.builder(child: child ?? const SizedBox()),
          home: Scaffold(
            body: ConfettiOverlay(
              style: ConfettiStyle.achievement,
            ),
          ),
        ),
      );

      expect(find.byType(ConfettiOverlay), findsOneWidget);
      expect(find.byType(CustomPaint), findsAtLeastNWidgets(1));
    });

    testWidgets('should respect reduced motion preference', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => Responsive.builder(child: child ?? const SizedBox()),
          home: MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: Scaffold(
              body: ConfettiOverlay(
                style: ConfettiStyle.achievement,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(ConfettiOverlay), findsOneWidget);
      // Should still show the overlay but with reduced particles
      expect(find.byType(CustomPaint), findsAtLeastNWidgets(1));
    });

    testWidgets('should call onComplete when animation finishes', (tester) async {
      bool completed = false;
      
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => Responsive.builder(child: child ?? const SizedBox()),
          home: Scaffold(
            body: ConfettiOverlay(
              style: ConfettiStyle.achievement,
              onComplete: () {
                completed = true;
              },
            ),
          ),
        ),
      );

      // Wait for animation to complete
      await tester.pumpAndSettle();
      
      expect(completed, true);
    });
  });

  group('ConfettiStyle', () {
    test('should have all required styles', () {
      expect(ConfettiStyle.values.length, 5);
      expect(ConfettiStyle.values, contains(ConfettiStyle.achievement));
      expect(ConfettiStyle.values, contains(ConfettiStyle.celebration));
      expect(ConfettiStyle.values, contains(ConfettiStyle.reward));
      expect(ConfettiStyle.values, contains(ConfettiStyle.milestone));
      expect(ConfettiStyle.values, contains(ConfettiStyle.victory));
    });
  });

  group('ConfettiShape', () {
    test('should have all required shapes', () {
      expect(ConfettiShape.values.length, 7);
      expect(ConfettiShape.values, contains(ConfettiShape.rectangle));
      expect(ConfettiShape.values, contains(ConfettiShape.circle));
      expect(ConfettiShape.values, contains(ConfettiShape.star));
      expect(ConfettiShape.values, contains(ConfettiShape.diamond));
      expect(ConfettiShape.values, contains(ConfettiShape.triangle));
      expect(ConfettiShape.values, contains(ConfettiShape.hexagon));
      expect(ConfettiShape.values, contains(ConfettiShape.heart));
    });
  });

  group('celebrate helper', () {
    testWidgets('should show confetti when celebrate is called', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => Responsive.builder(child: child ?? const SizedBox()),
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () async {
                    await celebrate(context, style: ConfettiStyle.achievement);
                  },
                  child: const Text('Celebrate'),
                );
              },
            ),
          ),
        ),
      );

      // Tap the button
      await tester.tap(find.text('Celebrate'));
      await tester.pump();

      // Should show confetti overlay
      expect(find.byType(ConfettiOverlay), findsOneWidget);
    });
  });
}