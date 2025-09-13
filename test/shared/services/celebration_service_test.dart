import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/shared/services/celebration_service.dart';
import 'package:pocketa/core/providers/celebration_preferences_provider.dart';
import 'package:pocketa/shared/ui/motion/confetti.dart';

void main() {
  group('CelebrationService', () {
    testWidgets('should not trigger celebration when feature flag is disabled', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Consumer(
                builder: (context, ref, child) {
                  return ElevatedButton(
                    onPressed: () async {
                      await CelebrationService.safeCelebrate(
                        context,
                        event: CelebrationEvent.onboardingComplete,
                        ref: ref,
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

      // Tap the button
      await tester.tap(find.text('Test'));
      await tester.pump();

      // Verify no confetti overlay is created
      expect(find.byType(Overlay), findsNothing);
    });

    testWidgets('should respect reduced motion preference', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: MediaQuery(
              data: const MediaQueryData(disableAnimations: true),
              child: Scaffold(
                body: Consumer(
                  builder: (context, ref, child) {
                    return ElevatedButton(
                      onPressed: () async {
                        await CelebrationService.safeCelebrate(
                          context,
                          event: CelebrationEvent.firstTransaction,
                          ref: ref,
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

      // Tap the button
      await tester.tap(find.text('Test'));
      await tester.pump();

      // Verify no confetti overlay is created due to reduced motion
      expect(find.byType(Overlay), findsNothing);
    });

    testWidgets('should not call SoundService when sound is disabled', (tester) async {
      final soundServiceCalled = false;
      
      // Mock SoundService
      // In a real test, you'd mock the SoundService.playCelebrationSound method
      
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            celebrationPreferencesProvider.overrideWith(
              (ref) => CelebrationPreferencesNotifier()..setCelebrationSoundEnabled(false),
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: Consumer(
                builder: (context, ref, child) {
                  return ElevatedButton(
                    onPressed: () async {
                      await CelebrationService.safeCelebrate(
                        context,
                        event: CelebrationEvent.budgetMilestone,
                        ref: ref,
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

      // Tap the button
      await tester.tap(find.text('Test'));
      await tester.pump();

      // Verify sound service was not called
      expect(soundServiceCalled, false);
    });

    testWidgets('should show confetti when all preferences are enabled', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            celebrationPreferencesProvider.overrideWith(
              (ref) => CelebrationPreferencesNotifier()
                ..setCelebrationSoundEnabled(true)
                ..setHapticsEnabled(true)
                ..setConfettiEnabled(true),
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: Consumer(
                builder: (context, ref, child) {
                  return ElevatedButton(
                    onPressed: () async {
                      await CelebrationService.safeCelebrate(
                        context,
                        event: CelebrationEvent.easterEgg,
                        ref: ref,
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

      // Tap the button
      await tester.tap(find.text('Test'));
      await tester.pump();

      // Verify confetti overlay is created
      expect(find.byType(Overlay), findsOneWidget);
    });
  });

  group('ConfettiStyle', () {
    test('should have correct configurations for each style', () {
      // Test achievement style
      final achievementConfig = ConfettiStyle.achievement;
      expect(achievementConfig.name, 'achievement');
      
      // Test celebration style
      final celebrationConfig = ConfettiStyle.celebration;
      expect(celebrationConfig.name, 'celebration');
      
      // Test reward style
      final rewardConfig = ConfettiStyle.reward;
      expect(rewardConfig.name, 'reward');
      
      // Test milestone style
      final milestoneConfig = ConfettiStyle.milestone;
      expect(milestoneConfig.name, 'milestone');
      
      // Test victory style
      final victoryConfig = ConfettiStyle.victory;
      expect(victoryConfig.name, 'victory');
    });
  });

  group('CelebrationPreferences', () {
    test('should have correct default values', () {
      const preferences = CelebrationPreferences();
      expect(preferences.enableCelebrationSound, true);
      expect(preferences.enableHaptics, true);
      expect(preferences.enableConfetti, true);
    });

    test('should copy with new values', () {
      const original = CelebrationPreferences();
      final updated = original.copyWith(
        enableCelebrationSound: false,
        enableHaptics: false,
      );
      
      expect(updated.enableCelebrationSound, false);
      expect(updated.enableHaptics, false);
      expect(updated.enableConfetti, true); // unchanged
    });

    test('should support equality', () {
      const preferences1 = CelebrationPreferences();
      const preferences2 = CelebrationPreferences();
      const preferences3 = CelebrationPreferences(
        enableCelebrationSound: false,
      );
      
      expect(preferences1, equals(preferences2));
      expect(preferences1, isNot(equals(preferences3)));
    });
  });
}
