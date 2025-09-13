import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pocketa/core/responsive/responsive.dart';
import 'package:pocketa/core/design_system/design_system.dart';
import 'package:pocketa/features/onboarding/presentation/viewmodels/onboarding_providers.dart';
import 'package:pocketa/l10n/app_localizations.dart';
import 'package:pocketa/shared/services/celebration_service.dart';

class OnboardingHabitScreen extends ConsumerStatefulWidget {
  final OnboardingNotifier notifier;

  const OnboardingHabitScreen({
    super.key,
    required this.notifier,
  });

  @override
  ConsumerState<OnboardingHabitScreen> createState() => _OnboardingHabitScreenState();
}

class _OnboardingHabitScreenState extends ConsumerState<OnboardingHabitScreen>
    with TickerProviderStateMixin {
  late AnimationController _streakController;
  late Animation<double> _streakAnimation;

  @override
  void initState() {
    super.initState();
    _streakController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    
    _streakAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _streakController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _streakController.dispose();
    super.dispose();
  }

  void startJourney() async {
    // Start streak animation
    _streakController.forward();
    
    // Trigger celebration
    await CelebrationService.safeCelebrate(
      context,
      CelebrationEvent.onboardingComplete,
      ref: ref,
    );
    
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
              child: Padding(
                padding: layout.pageGutter,
                child: Column(
                  children: [
          // Header
          Column(
            children: [
              // Day 1 badge
              AnimatedBuilder(
                animation: _streakAnimation,
                builder: (context, child) {
                    return Transform.scale(
                      scale: 0.8 + (0.2 * _streakAnimation.value),
                      child: Container(
                        width: DesignTokens.getResponsiveSpacing(
                          context,
                          phone: 100,
                          tablet: 120,
                          desktop: 140,
                        ),
                        height: DesignTokens.getResponsiveSpacing(
                          context,
                          phone: 100,
                          tablet: 120,
                          desktop: 140,
                        ),
                        decoration: BoxDecoration(
                          gradient: ColorTokens.primaryGradient(context),
                          borderRadius: BorderRadius.circular(DesignTokens.getResponsiveSpacing(
                            context,
                            phone: 50,
                            tablet: 60,
                            desktop: 70,
                          )),
                          boxShadow: DesignTokens.getShadowPrimary(context),
                        ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '1',
                            style: TypographyTokens.responsive(
                              context,
                              phone: TypographyTokens.displayLarge(context).copyWith(
                                fontWeight: DesignTokens.fontWeightBold,
                                color: ColorTokens.buttonOnPrimary(context),
                              ),
                              tablet: TypographyTokens.displayLarge(context).copyWith(
                                fontSize: 48,
                                fontWeight: DesignTokens.fontWeightBold,
                                color: ColorTokens.buttonOnPrimary(context),
                              ),
                              desktop: TypographyTokens.displayLarge(context).copyWith(
                                fontSize: 56,
                                fontWeight: DesignTokens.fontWeightBold,
                                color: ColorTokens.buttonOnPrimary(context),
                              ),
                            ),
                          ),
                          Text(
                            'DAY',
                            style: layout.responsiveTextStyle(
                              phone: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: ColorTokens.buttonOnPrimary(context).withValues(alpha: 0.9),
                              ),
                              tablet: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: ColorTokens.buttonOnPrimary(context).withValues(alpha: 0.9),
                              ),
                              desktop: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: ColorTokens.buttonOnPrimary(context).withValues(alpha: 0.9),
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
          
          SizedBox(height: layout.space2xl),
          
          Column(
            children: [
                // Streak visualization
                AnimatedBuilder(
                  animation: _streakAnimation,
                  builder: (context, child) {
                    return Container(
                      width: double.infinity,
                      height: 32.ic(context),
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
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 800),
                            width: (context.vw * 0.2) * _streakAnimation.value,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(layout.radiusS),
                              gradient: LinearGradient(
                                colors: [
                                  Theme.of(context).primaryColor,
                                  Theme.of(context).primaryColor.withValues(alpha: 0.8),
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
                                color: ColorTokens.surface(context),
                                borderRadius: BorderRadius.circular(6.ic(context)),
                                boxShadow: [
                                  BoxShadow(
                                    color: ColorTokens.shadowLight(context),
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
                                  color: Theme.of(context).primaryColor,
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
                Container(
                  padding: EdgeInsets.all(layout.space2xl),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(layout.radiusM),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
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
                        activeColor: Theme.of(context).primaryColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          
                  ],
                ),
              ),
            ),
          ),
        ],
    );
  }
}
