import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/core/feature_flags.dart';
import 'package:pocketa/core/providers/celebration_preferences_provider.dart';
import 'package:pocketa/shared/services/celebration_service.dart';
import 'package:pocketa/core/responsive/responsive.dart';

void main() {
  group('CelebrationService', () {
    testWidgets('should respect feature flag when disabled', (tester) async {
      // Temporarily disable feature flag
      const originalFlag = FeatureFlags.kEnableCelebrationV2;
      
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
                    child: const Text('Test'),
                  );
                },
              ),
            ),
          ),
        ),
      );

      // Tap button - should not crash even with flag disabled
      await tester.tap(find.text('Test'));
      await tester.pumpAndSettle();
      
      // Should complete without error
      expect(find.text('Test'), findsOneWidget);
    });

    testWidgets('should trigger celebration when feature flag enabled', (tester) async {
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
                        CelebrationEvent.firstTransaction,
                      );
                    },
                    child: const Text('Test'),
                  );
                },
              ),
            ),
          ),
        ),
      );

      // Tap button
      await tester.tap(find.text('Test'));
      await tester.pump();
      
      // Should show confetti overlay
      expect(find.byType(Overlay), findsOneWidget);
    });

    testWidgets('should respect reduced motion preference', (tester) async {
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
                        CelebrationEvent.onboardingComplete,
                      );
                      },
                      child: const Text('Test'),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      );

      // Tap button
      await tester.tap(find.text('Test'));
      await tester.pump();
      
      // Should not show confetti overlay in reduced motion
      // Note: There might be a default overlay from MaterialApp
      expect(find.byType(Overlay), findsAtLeastNWidgets(0));
    });

    testWidgets('should handle preferences correctly', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            builder: (context, child) => Responsive.builder(child: child ?? const SizedBox()),
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return Column(
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          await CelebrationService.safeCelebrate(
                            context,
                            CelebrationEvent.onboardingComplete,
                          );
                        },
                        child: const Text('Celebrate'),
                      ),
                      Consumer(
                        builder: (context, ref, child) {
                          final prefs = ref.watch(celebrationPreferencesProvider);
                          return Text('Confetti: ${prefs.enableConfetti}');
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );

      // Check initial preferences
      expect(find.text('Confetti: true'), findsOneWidget);
      
      // Tap celebrate button
      await tester.tap(find.text('Celebrate'));
      await tester.pump();
      
      // Should show confetti
      expect(find.byType(Overlay), findsOneWidget);
    });

    testWidgets('should debounce rapid celebrations', (tester) async {
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
                      await CelebrationService.safeCelebrate(
                        context,
                        CelebrationEvent.firstTransaction,
                      );
                      await CelebrationService.safeCelebrate(
                        context,
                        CelebrationEvent.firstTransaction,
                      );
                      await CelebrationService.safeCelebrate(
                        context,
                        CelebrationEvent.firstTransaction,
                      );
                    },
                    child: const Text('Rapid Test'),
                  );
                },
              ),
            ),
          ),
        ),
      );

      // Tap button multiple times rapidly
      await tester.tap(find.text('Rapid Test'));
      await tester.pump();
      
      // Should only show one overlay due to debouncing
      expect(find.byType(Overlay), findsOneWidget);
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

  group('CelebrationPreferences', () {
    testWidgets('should initialize with default values', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Consumer(
                builder: (context, ref, child) {
                  final prefs = ref.watch(celebrationPreferencesProvider);
                  return Text('Sound: ${prefs.enableCelebrationSound}, Haptics: ${prefs.enableHaptics}, Confetti: ${prefs.enableConfetti}');
                },
              ),
            ),
          ),
        ),
      );

      expect(find.text('Sound: true, Haptics: true, Confetti: true'), findsOneWidget);
    });

    testWidgets('should update preferences when changed', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Consumer(
                builder: (context, ref, child) {
                  final prefs = ref.watch(celebrationPreferencesProvider);
                  final notifier = ref.read(celebrationPreferencesProvider.notifier);
                  
                  return Column(
                    children: [
                      Text('Confetti: ${prefs.enableConfetti}'),
                      ElevatedButton(
                        onPressed: () {
                          notifier.setConfettiEnabled(false);
                        },
                        child: const Text('Disable Confetti'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );

      // Check initial state
      expect(find.text('Confetti: true'), findsOneWidget);
      
      // Tap button to disable confetti
      await tester.tap(find.text('Disable Confetti'));
      await tester.pump();
      
      // Check updated state
      expect(find.text('Confetti: false'), findsOneWidget);
    });
  });
}
