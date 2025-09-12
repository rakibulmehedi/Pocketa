import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pocketa/core/responsive/responsive.dart';
import 'package:pocketa/features/onboarding/presentation/viewmodels/onboarding_providers.dart';
import 'package:pocketa/l10n/app_localizations.dart';
import 'package:pocketa/shared/ui/glass_card.dart';
import 'package:pocketa/shared/ui/motion.dart';

class OnboardingHabitScreen extends ConsumerStatefulWidget {
  final OnboardingNotifier notifier;

  const OnboardingHabitScreen({
    super.key,
    required this.notifier,
  });

  @override
  ConsumerState<OnboardingHabitScreen> createState() => _OnboardingHabitScreenState();
}

class _OnboardingHabitScreenState extends ConsumerState<OnboardingHabitScreen> {
  bool _streakStarted = false;

  void startJourney() async {
    // Haptic feedback for better UX
    HapticFeedback.mediumImpact();
    
    // Start streak animation
    setState(() {
      _streakStarted = true;
    });
    
    // Show confetti
    ConfettiOverlay.show(context);
    
    try {
      // Complete onboarding
      await widget.notifier.completeOnboarding();
      
      // Navigate to dashboard - use goNamed to ensure proper routing
      if (mounted) {
        context.goNamed('dashboard');
      }
    } catch (e) {
      // Show error if onboarding completion fails
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to complete onboarding: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final layout = context.layout;
    final state = ref.watch(onboardingStateProvider);

    return Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Header
                  FadeSlide(
                    child: Column(
                      children: [
                        // Day 1 badge
                        TweenAnimationBuilder<double>(
                          duration: Motion.d300,
                          tween: Tween(begin: 0.8, end: _streakStarted ? 1.0 : 0.8),
                          builder: (context, scale, child) {
                              return Transform.scale(
                                scale: scale,
                                child: Container(
                                  width: layout.responsiveSize(phone: 100, tablet: 120, desktop: 140),
                                  height: layout.responsiveSize(phone: 100, tablet: 120, desktop: 140),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Theme.of(context).colorScheme.primary,
                                      Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(layout.responsiveSize(phone: 50, tablet: 60, desktop: 70)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                                      blurRadius: 20,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '1',
                                      style: layout.responsiveTextStyle(
                                        phone: TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).colorScheme.onSurface,
                                        ),
                                        tablet: TextStyle(
                                          fontSize: 48,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).colorScheme.onSurface,
                                        ),
                                        desktop: TextStyle(
                                          fontSize: 56,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).colorScheme.onSurface,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'DAY',
                                      style: layout.responsiveTextStyle(
                                        phone: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.9),
                                        ),
                                        tablet: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.9),
                                        ),
                                        desktop: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.9),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        
                        SizedBox(height: layout.spaceXl),
                        
                        Text(
                          l10n.onb_habit_title,
                          style: layout.responsiveTextStyle(
                            phone: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ) ?? const TextStyle(),
                            tablet: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ) ?? const TextStyle(),
                            desktop: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ) ?? const TextStyle(),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        
                        SizedBox(height: layout.spaceL),
                        
                        Text(
                          l10n.onb_habit_helper,
                          style: layout.responsiveTextStyle(
                            phone: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                              height: 1.4,
                            ) ?? const TextStyle(),
                            tablet: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                              height: 1.4,
                            ) ?? const TextStyle(),
                            desktop: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                              height: 1.4,
                            ) ?? const TextStyle(),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: layout.space2xl),
                  
                  FadeSlide(
                    delay: Motion.d060,
                    child: Column(
                      children: [
                          // Streak visualization
                          TweenAnimationBuilder<double>(
                            duration: Motion.d300,
                            tween: Tween(begin: 0.0, end: _streakStarted ? 1.0 : 0.0),
                            builder: (context, progress, child) {
                              return Container(
                                width: double.infinity,
                                height: layout.space2xl,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  borderRadius: BorderRadius.circular(layout.radiusS),
                                  border: Border.all(
                                    color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                                    width: 1,
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    // Background
                                    Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(layout.radiusS),
                                        color: Theme.of(context).colorScheme.surface,
                                      ),
                                    ),
                                    // Progress bar
                                    Container(
                                      width: (context.vw * 0.2) * progress,
                                      height: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(layout.radiusS),
                                        gradient: LinearGradient(
                                          colors: [
                                            Theme.of(context).colorScheme.primary,
                                            Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // Day 1 indicator
                                    Center(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: layout.spaceM,
                                          vertical: layout.spaceXs,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).colorScheme.surface,
                                          borderRadius: BorderRadius.circular(layout.radiusS),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.08),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Text(
                                          l10n.onb_habit_day_label(1),
                                          style: TextStyle(
                                            fontSize: layout.tSm,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context).colorScheme.primary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          
                          SizedBox(height: layout.spaceXl),
                          
                          // Daily reminder toggle
                          GlassCard(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.notifications_outlined,
                                  size: layout.responsiveIconSize(phone: 24, tablet: 28, desktop: 32),
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                SizedBox(width: layout.spaceM),
                                Flexible(
                                  child: Text(
                                    l10n.onb_habit_toggle_reminder,
                                    style: layout.responsiveTextStyle(
                                      phone: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ) ?? const TextStyle(),
                                      tablet: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ) ?? const TextStyle(),
                                      desktop: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ) ?? const TextStyle(),
                                    ),
                                  ),
                                ),
                                Switch(
                                  value: state.data.dailyReminder,
                                  onChanged: (value) {
                                    widget.notifier.updateDailyReminder(value);
                                  },
                                  activeColor: Theme.of(context).colorScheme.primary,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
  }
}
