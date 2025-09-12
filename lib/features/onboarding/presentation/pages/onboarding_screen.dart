import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pocketa/core/responsive/responsive.dart';
import 'package:pocketa/features/onboarding/domain/entities/onboarding_entity.dart';
import 'package:pocketa/features/onboarding/presentation/viewmodels/onboarding_providers.dart';
import 'package:pocketa/features/onboarding/presentation/widgets/onboarding_welcome_screen.dart';
import 'package:pocketa/features/onboarding/presentation/widgets/onboarding_personalization_screen.dart';
import 'package:pocketa/features/onboarding/presentation/widgets/onboarding_demo_screen.dart';
import 'package:pocketa/features/onboarding/presentation/widgets/onboarding_trust_screen.dart';
import 'package:pocketa/features/onboarding/presentation/widgets/onboarding_habit_screen.dart';
import 'package:pocketa/shared/ui/app_background_scaffold.dart';
import 'package:pocketa/shared/ui/footer_cta_bar.dart';
import 'package:pocketa/shared/ui/motion.dart';
import 'package:pocketa/l10n/app_localizations.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingStateProvider);
    final notifier = ref.read(onboardingStateProvider.notifier);
    final layout = context.layout;
    final l10n = AppLocalizations.of(context);

    // Show error if there's one
    if (state.error != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.error!),
            backgroundColor: Theme.of(context).colorScheme.error,
            action: SnackBarAction(
              label: l10n.retry,
              onPressed: () => notifier.saveProgress(),
            ),
          ),
        );
      });
    }

    return AppBackgroundScaffold(
      body: SafeArea(
        child: Responsive.builder(
          child: Column(
            children: [
              // Progress indicator
              if (state.data.currentStep != OnboardingStep.welcome)
                FadeSlide(
                    child: _buildProgressIndicator(
                        context, state.data.currentStep, layout, l10n)),

              // Current screen
              Expanded(
                child: state.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _buildCurrentScreen(
                        context, state.data.currentStep, notifier),
              ),

              // Dots indicator above footer
              FadeSlide(
                  delay: Motion.d060,
                  child: _buildDotsIndicator(
                      context, state.data.currentStep, layout)),
            ],
          ),
        ),
      ),
      footer: _buildCentralFooter(
          context, state.data.currentStep, notifier, layout),
    );
  }

  Widget _buildProgressIndicator(BuildContext context,
      OnboardingStep currentStep, AppSize layout, AppLocalizations l10n) {
    final totalSteps = OnboardingStep.values.length;
    final currentIndex = currentStep.index;
    final progress = (currentIndex + 1) / totalSteps;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: layout.pageGutter.horizontal,
        vertical: layout.spaceM,
      ),
      child: Column(
        children: [
          // Progress bar with enhanced styling
          Container(
            height: layout.responsiveSize(phone: 6, tablet: 8, desktop: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                  layout.responsiveSize(phone: 3, tablet: 4, desktop: 5)),
              color: Theme.of(context).brightness == Brightness.dark
                  ? Theme.of(context).colorScheme.surfaceContainerHighest
                  : Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                  layout.responsiveSize(phone: 3, tablet: 4, desktop: 5)),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).brightness == Brightness.dark
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),

          SizedBox(height: layout.spaceS),

          // Step indicator with enhanced styling
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.onb_progress_step(currentIndex + 1, totalSteps),
                style: layout.responsiveTextStyle(
                  phone: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.7),
                            fontWeight: FontWeight.w500,
                          ) ??
                      const TextStyle(),
                  tablet: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.7),
                            fontWeight: FontWeight.w500,
                          ) ??
                      const TextStyle(),
                  desktop: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.7),
                            fontWeight: FontWeight.w500,
                          ) ??
                      const TextStyle(),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal:
                      layout.responsiveSize(phone: 8, tablet: 12, desktop: 16),
                  vertical:
                      layout.responsiveSize(phone: 4, tablet: 6, desktop: 8),
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(layout.responsiveSize(
                      phone: 12, tablet: 16, desktop: 20)),
                ),
                child: Text(
                  l10n.onb_progress_percentage((progress * 100).round()),
                  style: layout.responsiveTextStyle(
                    phone: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ) ??
                        const TextStyle(),
                    tablet: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ) ??
                        const TextStyle(),
                    desktop: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ) ??
                        const TextStyle(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDotsIndicator(
      BuildContext context, OnboardingStep currentStep, AppSize layout) {
    final totalSteps = OnboardingStep.values.length;
    final currentIndex = currentStep.index;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: layout.pageGutter.horizontal,
        vertical: layout.spaceM,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(totalSteps, (index) {
          final isActive = index == currentIndex;
          final isCompleted = index < currentIndex;

          return Container(
            margin: EdgeInsets.symmetric(
              horizontal:
                  layout.responsiveSize(phone: 4, tablet: 6, desktop: 8),
            ),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: layout.responsiveSize(
                phone: isActive ? 12 : 8,
                tablet: isActive ? 14 : 10,
                desktop: isActive ? 16 : 12,
              ),
              height: layout.responsiveSize(
                phone: isActive ? 12 : 8,
                tablet: isActive ? 14 : 10,
                desktop: isActive ? 16 : 12,
              ),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive
                    ? Theme.of(context).colorScheme.primary
                    : isCompleted
                        ? Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.6)
                        : Theme.of(context)
                            .colorScheme
                            .outline
                            .withValues(alpha: 0.3),
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withValues(alpha: 0.3),
                          blurRadius: layout.responsiveSize(
                              phone: 4, tablet: 6, desktop: 8),
                          spreadRadius: layout.responsiveSize(
                              phone: 1, tablet: 2, desktop: 3),
                        ),
                      ]
                    : null,
              ),
            ),
          );
        }),
      ),
    );
  }

  Future<void> _completeOnboarding(BuildContext context,
      OnboardingNotifier notifier, AppLocalizations l10n) async {
    try {
      // Complete onboarding
      await notifier.completeOnboarding();

      // Navigate to dashboard
      if (context.mounted) {
        context.goNamed('dashboard');
      }
    } catch (e) {
      // Show error if onboarding completion fails
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.onb_error_completion(e.toString())),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Widget _buildCentralFooter(BuildContext context, OnboardingStep currentStep,
      OnboardingNotifier notifier, AppSize layout) {
    final l10n = AppLocalizations.of(context);

    // Get button text and actions based on current step
    String primaryButtonText;
    VoidCallback? onPrimaryPressed;
    bool showBack = false;
    VoidCallback? onBack;

    switch (currentStep) {
      case OnboardingStep.welcome:
        primaryButtonText = l10n.onb_continue;
        onPrimaryPressed = () => notifier.nextStep();
        break;
      case OnboardingStep.personalization:
        primaryButtonText = l10n.onb_continue;
        onPrimaryPressed = () => notifier.nextStep();
        showBack = true;
        onBack = () => notifier.previousStep();
        break;
      case OnboardingStep.demo:
        primaryButtonText = l10n.onb_continue;
        onPrimaryPressed = () => notifier.nextStep();
        showBack = true;
        onBack = () => notifier.previousStep();
        break;
      case OnboardingStep.trust:
        primaryButtonText = l10n.onb_trust_primary;
        onPrimaryPressed = () => notifier.nextStep();
        showBack = true;
        onBack = () => notifier.previousStep();
        break;
      case OnboardingStep.habit:
        primaryButtonText = l10n.onb_habit_cta;
        onPrimaryPressed = () {
          // For habit screen, we'll complete onboarding directly
          _completeOnboarding(context, notifier, l10n);
        };
        showBack = true;
        onBack = () => notifier.previousStep();
        break;
    }

    return FooterCtaBar(
      primaryLabel: primaryButtonText,
      onPrimary: onPrimaryPressed,
      secondaryLabel: showBack ? l10n.back : null,
      onSecondary: showBack ? onBack : null,
    );
  }

  Widget _buildCurrentScreen(
    BuildContext context,
    OnboardingStep step,
    OnboardingNotifier notifier,
  ) {
    switch (step) {
      case OnboardingStep.welcome:
        return const OnboardingWelcomeScreen();
      case OnboardingStep.personalization:
        return OnboardingPersonalizationScreen(notifier: notifier);
      case OnboardingStep.demo:
        return OnboardingDemoScreen(notifier: notifier);
      case OnboardingStep.trust:
        return OnboardingTrustScreen(notifier: notifier);
      case OnboardingStep.habit:
        return OnboardingHabitScreen(notifier: notifier);
    }
  }
}
