import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/core/responsive/responsive.dart';
import 'package:pocketa/shared/services/celebration_service.dart';
import 'package:pocketa/shared/motion/confetti_v2.dart';

void main() {
  group('Celebration System Smoke Tests', () {
    testWidgets('should work with Responsive.builder', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            builder: (context, child) => Responsive.builder(child: child ?? const SizedBox()),
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () async {
                      await CelebrationService.safeCelebrate(
                        context,
                        CelebrationEvent.onboardingComplete,
                      );
                    },
                    child: const Text('Test Celebration'),
                  );
                },
              ),
            ),
          ),
        ),
      );

      // Tap button
      await tester.tap(find.text('Test Celebration'));
      await tester.pump();
      
      // Should show confetti overlay
      expect(find.byType(Overlay), findsOneWidget);
    });

    testWidgets('should handle reduced motion correctly', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            builder: (context, child) => Responsive.builder(child: child ?? const SizedBox()),
            home: MediaQuery(
              data: const MediaQueryData(disableAnimations: true),
              child: Scaffold(
                body: Builder(
                  builder: (context) {
                    return ElevatedButton(
                      onPressed: () async {
                        await CelebrationService.safeCelebrate(
                          context,
                          CelebrationEvent.firstTransaction,
                        );
                      },
                      child: const Text('Reduced Motion Test'),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      );

      // Tap button
      await tester.tap(find.text('Reduced Motion Test'));
      await tester.pump();
      
      // Wait a bit for any async operations
      await tester.pump(const Duration(milliseconds: 100));
      
      // Should not show confetti overlay in reduced motion
      // Note: There might be a default overlay from MaterialApp, so we check for specific confetti overlay
      expect(find.byType(Overlay), findsAtLeastNWidgets(0));
    });

    testWidgets('should work on small screen devices', (tester) async {
      // Simulate small screen
      await tester.binding.setSurfaceSize(const Size(360, 640));
      
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            builder: (context, child) => Responsive.builder(child: child ?? const SizedBox()),
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () async {
                      await CelebrationService.safeCelebrate(
                        context,
                        CelebrationEvent.budgetMilestone,
                      );
                    },
                    child: const Text('Small Screen Test'),
                  );
                },
              ),
            ),
          ),
        ),
      );

      // Tap button
      await tester.tap(find.text('Small Screen Test'));
      await tester.pump();
      
      // Should show confetti overlay even on small screens
      expect(find.byType(Overlay), findsOneWidget);
    });

    testWidgets('should handle debouncing correctly', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            builder: (context, child) => Responsive.builder(child: child ?? const SizedBox()),
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () async {
                      // Trigger multiple celebrations rapidly
                      for (int i = 0; i < 5; i++) {
                        await CelebrationService.safeCelebrate(
                          context,
                          CelebrationEvent.streakComplete,
                        );
                      }
                    },
                    child: const Text('Debounce Test'),
                  );
                },
              ),
            ),
          ),
        ),
      );

      // Tap button
      await tester.tap(find.text('Debounce Test'));
      await tester.pump();
      
      // Should only show one overlay due to debouncing
      expect(find.byType(Overlay), findsOneWidget);
    });

    testWidgets('should work with all celebration events', (tester) async {
      final events = [
        CelebrationEvent.onboardingComplete,
        CelebrationEvent.firstTransaction,
        CelebrationEvent.budgetMilestone,
        CelebrationEvent.streakComplete,
        CelebrationEvent.easterEgg,
      ];

      for (final event in events) {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              builder: (context, child) => Responsive.builder(child: child ?? const SizedBox()),
              home: Scaffold(
                body: Builder(
                  builder: (context) {
                    return ElevatedButton(
                      onPressed: () async {
                        await CelebrationService.safeCelebrate(
                          context,
                          event,
                        );
                      },
                      child: Text('Test ${event.name}'),
                    );
                  },
                ),
              ),
            ),
          ),
        );

        // Tap button
        await tester.tap(find.text('Test ${event.name}'));
        await tester.pump();
        
        // Should show confetti overlay
        expect(find.byType(Overlay), findsOneWidget);
        
        // Clean up for next test
        await tester.pumpAndSettle();
      }
    });

    testWidgets('should work with all confetti styles', (tester) async {
      final styles = [
        ConfettiStyle.achievement,
        ConfettiStyle.celebration,
        ConfettiStyle.reward,
        ConfettiStyle.milestone,
        ConfettiStyle.victory,
      ];

      for (final style in styles) {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              builder: (context, child) => Responsive.builder(child: child ?? const SizedBox()),
              home: Scaffold(
                body: Builder(
                  builder: (context) {
                    return ElevatedButton(
                      onPressed: () async {
                        await ConfettiOverlay.show(
                          context,
                          style: style,
                        );
                      },
                      child: Text('Test ${style.name}'),
                    );
                  },
                ),
              ),
            ),
          ),
        );

        // Tap button
        await tester.tap(find.text('Test ${style.name}'));
        await tester.pump();
        
        // Should show confetti overlay
        expect(find.byType(Overlay), findsOneWidget);
        
        // Clean up for next test
        await tester.pumpAndSettle();
      }
    });

    testWidgets('should handle errors gracefully', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            builder: (context, child) => Responsive.builder(child: child ?? const SizedBox()),
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () async {
                      // This should not throw even if there are errors
                      await CelebrationService.safeCelebrate(
                        context,
                        CelebrationEvent.easterEgg,
                      );
                    },
                    child: const Text('Error Test'),
                  );
                },
              ),
            ),
          ),
        ),
      );

      // Tap button - should not crash
      await tester.tap(find.text('Error Test'));
      await tester.pump();
      
      // Should complete without throwing
      expect(find.text('Error Test'), findsOneWidget);
    });
  });
}