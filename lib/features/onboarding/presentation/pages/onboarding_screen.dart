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
import 'package:pocketa/features/onboarding/presentation/widgets/onboarding_bottom_footer.dart';
import 'package:pocketa/l10n/app_localizations.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingStateProvider);
    final notifier = ref.read(onboardingStateProvider.notifier);
    final layout = context.layout;

    // Show error if there's one
    if (state.error != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.error!),
            backgroundColor: Theme.of(context).colorScheme.error,
            action: SnackBarAction(
              label: 'Retry',
              onPressed: () => notifier.saveProgress(),
            ),
          ),
        );
      });
    }

    return Scaffold(
      body: SafeArea(
        child: Responsive.builder(
          child: Column(
            children: [
              // // Progress indicator
              // Dots indicator above footer
              if (state.data.currentStep != OnboardingStep.welcome)
                _buildDotsIndicator(context, state.data.currentStep, layout),
              // Linear progress indicator at the top
              if (state.data.currentStep != OnboardingStep.welcome)
                _buildProgressIndicator(
                    context, state.data.currentStep, layout),

              // Current screen
              Expanded(
                child: state.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _buildCurrentScreen(
                        context, state.data.currentStep, notifier),
              ),

              // Central footer
              _buildCentralFooter(
                  context, state.data.currentStep, notifier, layout),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(
      BuildContext context, OnboardingStep currentStep, AppSize layout) {
    final totalSteps = OnboardingStep.values.length ;
    final currentIndex = currentStep.index ;
    final progress = (currentIndex + 1) / totalSteps ;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: layout.pageGutter.horizontal,
        vertical: layout.spaceM,
      ),
      child: Column(
        children: [
          // Progress bar with enhanced styling
          

          SizedBox(height: layout.spaceS),

          // Step indicator with enhanced styling
          Container(
            padding: EdgeInsets.symmetric(
              horizontal:
                  layout.responsiveSize(phone: 8, tablet: 12, desktop: 16),
              vertical:
                  layout.responsiveSize(phone: 4, tablet: 6, desktop: 8),
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(layout.responsiveSize(
                  phone: 12, tablet: 16, desktop: 20)),
            ),
            child: Text(
              '${(progress * 100).round()}%',
              style: layout.responsiveTextStyle(
                phone: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w600,
                        ) ??
                    const TextStyle(),
                tablet: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w600,
                        ) ??
                    const TextStyle(),
                desktop: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w600,
                        ) ??
                    const TextStyle(),
              ),
            ),
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

  Future<void> _completeOnboarding(
      BuildContext context, OnboardingFormNotifier notifier) async {
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
            content: Text('Failed to complete onboarding: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Widget _buildCentralFooter(BuildContext context, OnboardingStep currentStep,
      OnboardingFormNotifier notifier, AppSize layout) {
    final l10n = AppLocalizations.of(context);

    // Get button text and actions based on current step
    String primaryButtonText;
    VoidCallback? onPrimaryPressed;
    String? secondaryButtonText;
    VoidCallback? onSecondaryPressed;
    final bool showBackButton = currentStep != OnboardingStep.welcome;

    switch (currentStep) {
      case OnboardingStep.welcome:
        primaryButtonText = l10n.onb_continue;
        onPrimaryPressed = () => notifier.nextStep();
        break;
      case OnboardingStep.personalization:
        primaryButtonText = l10n.onb_continue;
        onPrimaryPressed = () => notifier.nextStep();
        break;
      case OnboardingStep.demo:
        // For demo screen, we need to check if demo was added
        // This is a simplified version - in practice you'd need to watch the demo state
        primaryButtonText = l10n.onb_continue;
        onPrimaryPressed = () => notifier.nextStep();
        break;
      case OnboardingStep.trust:
        primaryButtonText = l10n.onb_trust_primary;
        onPrimaryPressed = () => notifier.nextStep();
        secondaryButtonText = l10n.onb_trust_learn_more;
        onSecondaryPressed = () {
          // TODO: Navigate to privacy policy
        };
        break;
      case OnboardingStep.habit:
        primaryButtonText = l10n.onb_habit_cta;
        onPrimaryPressed = () {
          // For habit screen, we'll complete onboarding directly
          _completeOnboarding(context, notifier);
        };
        break;
    }

    return OnboardingBottomFooter(
      primaryButtonText: primaryButtonText,
      onPrimaryPressed: onPrimaryPressed,
      secondaryButtonText: secondaryButtonText,
      onSecondaryPressed: onSecondaryPressed,
      showBackButton: showBackButton,
      onBackPressed: showBackButton ? () => notifier.previousStep() : null,
    );
  }

  Widget _buildCurrentScreen(
    BuildContext context,
    OnboardingStep step,
    OnboardingFormNotifier notifier,
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
