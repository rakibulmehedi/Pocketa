import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pocketa/shared/ui/motion/confetti.dart';

void main() {
  group('ConfettiOverlay', () {
    testWidgets('should not show confetti when showConfetti is false', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ConfettiOverlay(
              showConfetti: false,
              child: const Text('Test'),
            ),
          ),
        ),
      );

      expect(find.text('Test'), findsOneWidget);
      expect(find.byType(CustomPaint), findsNothing);
    });

    testWidgets('should show confetti when showConfetti is true', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ConfettiOverlay(
              showConfetti: true,
              child: const Text('Test'),
            ),
          ),
        ),
      );

      expect(find.text('Test'), findsOneWidget);
      expect(find.byType(CustomPaint), findsOneWidget);
    });

    testWidgets('should respect reduced motion preference', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: Scaffold(
              body: ConfettiOverlay(
                showConfetti: true,
                child: const Text('Test'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Test'), findsOneWidget);
      expect(find.byType(CustomPaint), findsNothing);
    });
  });

  group('ConfettiBurst', () {
    testWidgets('should trigger confetti when trigger changes from false to true', (tester) async {
      bool trigger = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                body: ConfettiBurst(
                  trigger: trigger,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        trigger = true;
                      });
                    },
                    child: const Text('Trigger'),
                  ),
                ),
              );
            },
          ),
        ),
      );

      // Initially no confetti
      expect(find.byType(CustomPaint), findsNothing);

      // Tap to trigger
      await tester.tap(find.text('Trigger'));
      await tester.pump();

      // Should show confetti
      expect(find.byType(CustomPaint), findsOneWidget);
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

  group('ConfettiConfig', () {
    test('should create config with required properties', () {
      const config = ConfettiConfig(
        duration: Duration(milliseconds: 1000),
        particleCount: 50,
        colors: [Colors.red, Colors.blue],
      );

      expect(config.duration, const Duration(milliseconds: 1000));
      expect(config.particleCount, 50);
      expect(config.colors, [Colors.red, Colors.blue]);
    });
  });
}
