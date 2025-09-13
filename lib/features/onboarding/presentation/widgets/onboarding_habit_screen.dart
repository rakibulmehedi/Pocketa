import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pocketa/core/responsive/responsive.dart';
import 'package:pocketa/core/theme/app_colors.dart';
import 'package:pocketa/features/onboarding/presentation/viewmodels/onboarding_providers.dart';
import 'package:pocketa/l10n/app_localizations.dart';
import 'package:pocketa/shared/widgets/confetti_widget.dart';

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
  late AnimationController _confettiController;
  late AnimationController _streakController;
  late AnimationController _headerController;
  late AnimationController _progressController;
  late Animation<double> _streakAnimation;
  late Animation<double> _headerFadeAnimation;
  late Animation<Offset> _headerSlideAnimation;
  late Animation<double> _progressAnimation;
  late Animation<double> _badgeScaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    _confettiController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    _streakController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _headerController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _streakAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _streakController,
      curve: Curves.easeOut,
    ));

    _headerFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _headerController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeInOut),
      ),
    );
    _headerSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _headerController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
      ),
    );
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _progressController,
        curve: Curves.easeOutCubic,
      ),
    );
    _badgeScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _streakController,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _headerController.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    _streakController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    _progressController.forward();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _streakController.dispose();
    _headerController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  void startJourney() async {
    // Enhanced haptic feedback sequence
    HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    HapticFeedback.lightImpact();
    await Future.delayed(const Duration(milliseconds: 50));
    HapticFeedback.mediumImpact();
    
    // Start celebration animations
    _confettiController.forward();
    _streakController.forward();
    _progressController.forward();
    
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

    return ConfettiWidget(
      isActive: _confettiController.isAnimating,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: layout.pageGutter,
                child: Column(
                  children: [
                    // Enhanced Header with Animations
                    RepaintBoundary(
                      child: AnimatedBuilder(
                        animation: Listenable.merge([_headerFadeAnimation, _headerSlideAnimation]),
                        builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, _headerSlideAnimation.value.dy * 50),
                          child: Opacity(
                            opacity: _headerFadeAnimation.value,
                            child: Column(
                              children: [
                                // Enhanced Day 1 badge
                                AnimatedBuilder(
                                  animation: Listenable.merge([_badgeScaleAnimation, _streakAnimation]),
                                  builder: (context, child) {
                                    return Transform.scale(
                                      scale: _badgeScaleAnimation.value * (0.8 + (0.2 * _streakAnimation.value)),
                                      child: Container(
                                        width: layout.responsiveSize(phone: 120, tablet: 140, desktop: 160),
                                        height: layout.responsiveSize(phone: 120, tablet: 140, desktop: 160),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              Theme.of(context).primaryColor,
                                              Theme.of(context).primaryColor.withValues(alpha: 0.8),
                                              Theme.of(context).primaryColor.withValues(alpha: 0.6),
                                            ],
                                            stops: const [0.0, 0.6, 1.0],
                                          ),
                                          borderRadius: BorderRadius.circular(layout.responsiveSize(phone: 60, tablet: 70, desktop: 80)),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Theme.of(context).primaryColor.withValues(alpha: 0.4),
                                              blurRadius: 30,
                                              offset: const Offset(0, 12),
                                            ),
                                            BoxShadow(
                                              color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                                              blurRadius: 60,
                                              offset: const Offset(0, 24),
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
                                                  fontSize: 48,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.buttonTextPrimary(context),
                                                  letterSpacing: 1.0,
                                                ),
                                                tablet: TextStyle(
                                                  fontSize: 56,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.buttonTextPrimary(context),
                                                  letterSpacing: 1.0,
                                                ),
                                                desktop: TextStyle(
                                                  fontSize: 64,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.buttonTextPrimary(context),
                                                  letterSpacing: 1.0,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              'DAY',
                                              style: layout.responsiveTextStyle(
                                                phone: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.buttonTextPrimary(context).withValues(alpha:0.9),
                                                  letterSpacing: 2.0,
                                                ),
                                                tablet: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.buttonTextPrimary(context).withValues(alpha:0.9),
                                                  letterSpacing: 2.0,
                                                ),
                                                desktop: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.buttonTextPrimary(context).withValues(alpha:0.9),
                                                  letterSpacing: 2.0,
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
                                      letterSpacing: 0.5,
                                    ) ?? const TextStyle(),
                                    tablet: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.onSurface,
                                      letterSpacing: 0.5,
                                    ) ?? const TextStyle(),
                                    desktop: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.onSurface,
                                      letterSpacing: 0.5,
                                    ) ?? const TextStyle(),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                
                                SizedBox(height: layout.spaceL),
                                
                                Text(
                                  l10n.onb_habit_helper,
                                  style: layout.responsiveTextStyle(
                                    phone: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha:0.7),
                                      height: 1.4,
                                      letterSpacing: 0.2,
                                    ) ?? const TextStyle(),
                                    tablet: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha:0.7),
                                      height: 1.4,
                                      letterSpacing: 0.2,
                                    ) ?? const TextStyle(),
                                    desktop: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha:0.7),
                                      height: 1.4,
                                      letterSpacing: 0.2,
                                    ) ?? const TextStyle(),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    ),
                    
                    SizedBox(height: layout.space2xl),
                    
                    Column(
                      children: [
                        // Enhanced Streak visualization
                        RepaintBoundary(
                          child: AnimatedBuilder(
                            animation: Listenable.merge([_progressAnimation, _streakAnimation]),
                            builder: (context, child) {
                            return Container(
                              width: double.infinity,
                              height: 40.ic(context),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Theme.of(context).colorScheme.surface,
                                    Theme.of(context).colorScheme.surface.withValues(alpha:0.8),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(layout.radiusL),
                                border: Border.all(
                                  color: Theme.of(context).colorScheme.outline.withValues(alpha:0.2),
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(context).colorScheme.shadow.withValues(alpha:0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  // Background
                                  Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(layout.radiusL),
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Theme.of(context).colorScheme.surface,
                                          Theme.of(context).colorScheme.surface.withValues(alpha:0.8),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Enhanced Progress bar
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 1200),
                                    width: (context.vw * 0.2) * _progressAnimation.value,
                                    height: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(layout.radiusL),
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Theme.of(context).primaryColor,
                                          Theme.of(context).primaryColor.withValues(alpha:0.8),
                                          Theme.of(context).primaryColor.withValues(alpha:0.6),
                                        ],
                                        stops: const [0.0, 0.6, 1.0],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Theme.of(context).primaryColor.withValues(alpha:0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Enhanced Day 1 indicator
                                  Center(
                                    child: AnimatedBuilder(
                                      animation: _progressAnimation,
                                      builder: (context, child) {
                                        return Transform.scale(
                                          scale: 0.8 + (0.2 * _progressAnimation.value),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: layout.spaceL,
                                              vertical: layout.spaceS,
                                            ),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: [
                                                  AppColors.cardBackground(context),
                                                  AppColors.cardBackground(context).withValues(alpha:0.8),
                                                ],
                                              ),
                                              borderRadius: BorderRadius.circular(8.ic(context)),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: AppColors.shadowLight(context),
                                                  blurRadius: 6,
                                                  offset: const Offset(0, 3),
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.local_fire_department_rounded,
                                                  size: 16.ic(context),
                                                  color: Theme.of(context).primaryColor,
                                                ),
                                                SizedBox(width: layout.spaceS),
                                                Text(
                                                  l10n.onb_habit_day_label(1),
                                                  style: TextStyle(
                                                    fontSize: layout.tSm,
                                                    fontWeight: FontWeight.bold,
                                                    color: Theme.of(context).primaryColor,
                                                    letterSpacing: 0.5,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        ),
                        
                        SizedBox(height: layout.spaceXl),
                        
                        // Enhanced Daily reminder toggle
                        RepaintBoundary(
                          child: AnimatedBuilder(
                            animation: _progressAnimation,
                            builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(0, (1 - _progressAnimation.value) * 20),
                              child: Opacity(
                                opacity: 0.7 + (0.3 * _progressAnimation.value),
                                child: Container(
                                  padding: EdgeInsets.all(layout.space2xl),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Theme.of(context).colorScheme.surface,
                                        Theme.of(context).colorScheme.surface.withValues(alpha:0.8),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(layout.radiusL),
                                    border: Border.all(
                                      color: Theme.of(context).colorScheme.outline.withValues(alpha:0.2),
                                      width: 1.5,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Theme.of(context).colorScheme.shadow.withValues(alpha:0.1),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(layout.spaceM),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              Theme.of(context).colorScheme.primary.withValues(alpha:0.1),
                                              Theme.of(context).colorScheme.primary.withValues(alpha:0.05),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(layout.radiusM),
                                        ),
                                        child: Icon(
                                          Icons.notifications_active_rounded,
                                          size: layout.responsiveIconSize(phone: 28, tablet: 32, desktop: 36),
                                          color: Theme.of(context).colorScheme.primary,
                                        ),
                                      ),
                                      SizedBox(width: layout.spaceL),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              l10n.onb_habit_toggle_reminder,
                                              style: layout.responsiveTextStyle(
                                                phone: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 0.3,
                                                ) ?? const TextStyle(),
                                                tablet: Theme.of(context).textTheme.titleLarge?.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 0.3,
                                                ) ?? const TextStyle(),
                                                desktop: Theme.of(context).textTheme.titleLarge?.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 0.3,
                                                ) ?? const TextStyle(),
                                              ),
                                            ),
                                            SizedBox(height: layout.spaceS),
                                            Text(
                                              'Get daily reminders to track your expenses',
                                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha:0.6),
                                                letterSpacing: 0.1,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Switch(
                                        value: state.data.dailyReminder,
                                        onChanged: (value) {
                                          HapticFeedback.lightImpact();
                                          widget.notifier.updateDailyReminder(value);
                                        },
                                        activeColor: Theme.of(context).primaryColor,
                                        activeTrackColor: Theme.of(context).primaryColor.withValues(alpha:0.3),
                                        inactiveThumbColor: Theme.of(context).colorScheme.outline,
                                        inactiveTrackColor: Theme.of(context).colorScheme.outline.withValues(alpha:0.2),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
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
      ),
    );
  }
}
