import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _dotsController;
  late AnimationController _screenController;
  late Animation<double> _progressAnimation;
  late Animation<double> _dotsAnimation;
  late Animation<double> _screenFadeAnimation;
  late Animation<Offset> _screenSlideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _dotsController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _screenController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _progressController,
        curve: Curves.easeOutCubic,
      ),
    );
    _dotsAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _dotsController,
        curve: Curves.easeOutCubic,
      ),
    );
    _screenFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _screenController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeInOut),
      ),
    );
    _screenSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _screenController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _startAnimations();
  }

  @override
  void didUpdateWidget(OnboardingScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Restart animations when step changes
    _restartAnimations();
  }

  void _restartAnimations() async {
    _screenController.reset();
    await Future.delayed(const Duration(milliseconds: 100));
    _screenController.forward();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _progressController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    _dotsController.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    _screenController.forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    _dotsController.dispose();
    _screenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              // Progress indicator
              if (state.data.currentStep != OnboardingStep.welcome)
                _buildProgressIndicator(context, state.data.currentStep, layout),
              
              // Enhanced Current screen with animations
              Expanded(
                child: state.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : AnimatedBuilder(
                        animation: Listenable.merge([_screenFadeAnimation, _screenSlideAnimation]),
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, _screenSlideAnimation.value.dy * 30),
                            child: Opacity(
                              opacity: _screenFadeAnimation.value,
                              child: _buildCurrentScreen(context, state.data.currentStep, notifier),
                            ),
                          );
                        },
                      ),
              ),
              
              // Dots indicator above footer
              _buildDotsIndicator(context, state.data.currentStep, layout),
              
              // Central footer
              _buildCentralFooter(context, state.data.currentStep, notifier, layout),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(BuildContext context, OnboardingStep currentStep, AppSize layout) {
    final totalSteps = OnboardingStep.values.length;
    final currentIndex = currentStep.index;
    final progress = (currentIndex + 1) / totalSteps;

    return AnimatedBuilder(
      animation: _progressAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, (1 - _progressAnimation.value) * 20),
          child: Opacity(
            opacity: _progressAnimation.value,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: layout.pageGutter.horizontal,
                vertical: layout.spaceL,
              ),
              child: Column(
                children: [
                  // Enhanced Progress bar with gradient and animation
                  Container(
                    height: layout.responsiveSize(phone: 8, tablet: 10, desktop: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(layout.responsiveSize(phone: 4, tablet: 5, desktop: 6)),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Theme.of(context).colorScheme.surfaceContainerHighest,
                          Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.8),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(layout.responsiveSize(phone: 4, tablet: 5, desktop: 6)),
                      child: Stack(
                        children: [
                          // Background
                          Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Theme.of(context).colorScheme.surfaceContainerHighest,
                                  Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.8),
                                ],
                              ),
                            ),
                          ),
                          // Animated Progress bar
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 800),
                            width: MediaQuery.of(context).size.width * progress * 0.8,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Theme.of(context).colorScheme.primary,
                                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
                                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.6),
                                ],
                                stops: const [0.0, 0.6, 1.0],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  SizedBox(height: layout.spaceM),
                  
                  // Enhanced Step indicator with animation
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle_outline_rounded,
                            size: layout.responsiveIconSize(phone: 16, tablet: 18, desktop: 20),
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          SizedBox(width: layout.spaceS),
                          Text(
                            'Step ${currentIndex + 1} of $totalSteps',
                            style: layout.responsiveTextStyle(
                              phone: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.3,
                              ) ?? const TextStyle(),
                              tablet: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.3,
                              ) ?? const TextStyle(),
                              desktop: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.3,
                              ) ?? const TextStyle(),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: layout.responsiveSize(phone: 12, tablet: 16, desktop: 20),
                          vertical: layout.responsiveSize(phone: 6, tablet: 8, desktop: 10),
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Theme.of(context).primaryColor.withValues(alpha: 0.15),
                              Theme.of(context).primaryColor.withValues(alpha: 0.08),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(layout.responsiveSize(phone: 16, tablet: 20, desktop: 24)),
                          border: Border.all(
                            color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          '${(progress * 100).round()}%',
                          style: layout.responsiveTextStyle(
                            phone: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ) ?? const TextStyle(),
                            tablet: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ) ?? const TextStyle(),
                            desktop: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ) ?? const TextStyle(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDotsIndicator(BuildContext context, OnboardingStep currentStep, AppSize layout) {
    final totalSteps = OnboardingStep.values.length;
    final currentIndex = currentStep.index;
    
    return AnimatedBuilder(
      animation: _dotsAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, (1 - _dotsAnimation.value) * 15),
          child: Opacity(
            opacity: _dotsAnimation.value,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: layout.pageGutter.horizontal,
                vertical: layout.spaceL,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(totalSteps, (index) {
                  final isActive = index == currentIndex;
                  final isCompleted = index < currentIndex;
                  
                  return TweenAnimationBuilder<double>(
                    duration: Duration(milliseconds: 400 + (index * 100)),
                    tween: Tween(begin: 0.0, end: 1.0),
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: 0.8 + (0.2 * value),
                        child: Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: layout.responsiveSize(phone: 6, tablet: 8, desktop: 10),
                          ),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 400),
                            width: layout.responsiveSize(
                              phone: isActive ? 16 : 10,
                              tablet: isActive ? 18 : 12,
                              desktop: isActive ? 20 : 14,
                            ),
                            height: layout.responsiveSize(
                              phone: isActive ? 16 : 10,
                              tablet: isActive ? 18 : 12,
                              desktop: isActive ? 20 : 14,
                            ),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: isActive
                                  ? LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Theme.of(context).colorScheme.primary,
                                        Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
                                      ],
                                    )
                                  : isCompleted
                                      ? LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
                                            Theme.of(context).colorScheme.primary.withValues(alpha: 0.6),
                                          ],
                                        )
                                      : LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                                            Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                                          ],
                                        ),
                              boxShadow: isActive ? [
                                BoxShadow(
                                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.4),
                                  blurRadius: layout.responsiveSize(phone: 6, tablet: 8, desktop: 10),
                                  spreadRadius: layout.responsiveSize(phone: 1, tablet: 2, desktop: 3),
                                ),
                                BoxShadow(
                                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                                  blurRadius: layout.responsiveSize(phone: 12, tablet: 16, desktop: 20),
                                  spreadRadius: layout.responsiveSize(phone: 2, tablet: 4, desktop: 6),
                                ),
                              ] : isCompleted ? [
                                BoxShadow(
                                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                                  blurRadius: layout.responsiveSize(phone: 4, tablet: 6, desktop: 8),
                                  spreadRadius: layout.responsiveSize(phone: 1, tablet: 2, desktop: 3),
                                ),
                              ] : null,
                            ),
                            child: isCompleted
                                ? Icon(
                                    Icons.check_rounded,
                                    size: layout.responsiveIconSize(phone: 8, tablet: 10, desktop: 12),
                                    color: Colors.white,
                                  )
                                : isActive
                                    ? Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white.withValues(alpha: 0.2),
                                        ),
                                        child: Center(
                                          child: Container(
                                            width: layout.responsiveSize(phone: 4, tablet: 5, desktop: 6),
                                            height: layout.responsiveSize(phone: 4, tablet: 5, desktop: 6),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      )
                                    : null,
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _completeOnboarding(BuildContext context, OnboardingNotifier notifier) async {
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

  Widget _buildCentralFooter(BuildContext context, OnboardingStep currentStep, OnboardingNotifier notifier, AppSize layout) {
    final l10n = AppLocalizations.of(context);
    
    // Get button text and actions based on current step
    String primaryButtonText;
    VoidCallback? onPrimaryPressed;
    String? secondaryButtonText;
    VoidCallback? onSecondaryPressed;
    bool showBackButton = currentStep != OnboardingStep.welcome;
    
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
