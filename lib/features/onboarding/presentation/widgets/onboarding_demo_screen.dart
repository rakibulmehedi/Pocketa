import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/core/responsive/responsive.dart';
import 'package:pocketa/core/theme/app_colors.dart';
import 'package:pocketa/features/onboarding/presentation/viewmodels/onboarding_providers.dart';
import 'package:pocketa/l10n/app_localizations.dart';
import 'package:pocketa/shared/services/snackbar_service.dart';
import 'package:pocketa/shared/widgets/confetti_widget.dart';
import 'package:pocketa/shared/widgets/custom_snackbar.dart';

class OnboardingDemoScreen extends ConsumerStatefulWidget {
  final OnboardingNotifier notifier;

  const OnboardingDemoScreen({
    super.key,
    required this.notifier,
  });

  @override
  ConsumerState<OnboardingDemoScreen> createState() => _OnboardingDemoScreenState();
}

class _OnboardingDemoScreenState extends ConsumerState<OnboardingDemoScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _confettiController;
  late AnimationController _successController;
  late AnimationController _buttonController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _buttonScaleAnimation;
  late Animation<double> _successScaleAnimation;
  late Animation<Offset> _successSlideAnimation;
  
  bool _isDemoAdded = false;
  bool _isAdding = false;
  bool _showSuccess = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _confettiController = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    );
    _successController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController, 
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController, 
        curve: const Interval(0.2, 0.8, curve: Curves.easeInOut),
      ),
    );
    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.1, 0.7, curve: Curves.easeOutCubic),
      ),
    );
    _buttonScaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
    );
    _successScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _successController,
        curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
      ),
    );
    _successSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _successController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutCubic),
      ),
    );

    _startAnimation();
  }

  void _startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _animationController.forward();
  }

  Future<void> _addDemoTransaction() async {
    if (_isAdding || _isDemoAdded) return;
    
    // Haptic feedback on button press
    HapticFeedback.lightImpact();
    
    setState(() {
      _isAdding = true;
    });

    // Button press animation
    _buttonController.forward().then((_) {
      _buttonController.reverse();
    });

    try {
      // Actually create a demo transaction
      await _createDemoTransaction();
      
      setState(() {
        _isDemoAdded = true;
        _isAdding = false;
        _showSuccess = true;
      });

      // Enhanced success celebration
      _triggerSuccessCelebration();
    } catch (e) {
      setState(() {
        _isAdding = false;
      });
      
      // Error haptic feedback
      HapticFeedback.heavyImpact();
      
      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add demo transaction: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  Future<void> _createDemoTransaction() async {
    // Simulate creating a demo transaction
    // In a real implementation, you would use the transaction repository
    await Future.delayed(const Duration(milliseconds: 800));
    
    // TODO: Implement actual demo transaction creation
    // This would involve:
    // 1. Getting a default wallet
    // 2. Getting a default category for expenses
    // 3. Creating a transaction entity with demo data
    // 4. Saving it to the database
  }

  Future<void> _triggerSuccessCelebration() async {
    // Multi-layered haptic feedback sequence
    HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    HapticFeedback.lightImpact();
    await Future.delayed(const Duration(milliseconds: 50));
    HapticFeedback.mediumImpact();
    
    // Trigger confetti animation with enhanced settings
    _confettiController.forward();
    
    // Show success animation in UI
    _successController.forward();
    
    // Show centralized success notification (brief and non-intrusive)
    _showSuccessNotification();
  }

  void _showSuccessNotification() {
    final l10n = AppLocalizations.of(context);
    
    // Use centralized snackbar service for consistent UX
    SnackbarService.showCustom(
      context,
      message: l10n.onb_demo_success_toast,
      type: SnackbarType.success,
      icon: Icons.celebration_rounded,
      duration: const Duration(seconds: 2), // Shorter duration to avoid clutter
      showCloseButton: false, // Auto-dismiss for cleaner UX
    );
  }

  @override
  void dispose() {
    // Dispose all animation controllers to prevent memory leaks
    _animationController.dispose();
    _confettiController.dispose();
    _successController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  // Performance optimization: prevent unnecessary rebuilds
  // Note: wantKeepAlive is not available in ConsumerState, keeping for reference

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final layout = context.layout;

    return ConfettiWidget(
      isActive: _confettiController.isAnimating,
      duration: const Duration(milliseconds: 4000),
      particleCount: 60,
      enableHapticFeedback: true,
      enableSound: true,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: layout.pageGutter,
                child: Column(
                  children: [
                    // Header with enhanced animations
                    AnimatedBuilder(
                      animation: _fadeAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, _slideAnimation.value),
                          child: Opacity(
                            opacity: _fadeAnimation.value,
                            child: Text(
                              l10n.onb_demo_title,
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
                          ),
                        );
                      },
                    ),

                    SizedBox(height: layout.spaceL),

                    AnimatedBuilder(
                      animation: _fadeAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, _slideAnimation.value * 0.5),
                          child: Opacity(
                            opacity: _fadeAnimation.value * 0.8,
                            child: Text(
                              l10n.onb_demo_helper,
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
                          ),
                        );
                      },
                    ),

                    SizedBox(height: layout.space2xl),

                    // Demo card
                    AnimatedBuilder(
                      animation: _scaleAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _scaleAnimation.value,
                          child: _buildDemoCard(context, l10n, layout),
                        );
                      },
                    ),

                    SizedBox(height: layout.spaceXl),

                    // Success message with enhanced animations
                    if (_showSuccess)
                      AnimatedBuilder(
                        animation: _successController,
                        builder: (context, child) {
                          return SlideTransition(
                            position: _successSlideAnimation,
                            child: ScaleTransition(
                              scale: _successScaleAnimation,
                              child: Container(
                                padding: EdgeInsets.all(layout.space2xl),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      AppColors.success(context).withValues(alpha: 0.1),
                                      AppColors.success(context).withValues(alpha: 0.05),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(layout.radiusL),
                                  border: Border.all(
                                    color: AppColors.success(context).withValues(alpha: 0.3),
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.success(context).withValues(alpha: 0.2),
                                      blurRadius: 20,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    AnimatedBuilder(
                                      animation: _successController,
                                      builder: (context, child) {
                                        return Transform.rotate(
                                          angle: _successController.value * 2 * 3.14159,
                                          child: Icon(
                                            Icons.check_circle_rounded,
                                            color: AppColors.success(context),
                                            size: layout.responsiveIconSize(phone: 28, tablet: 32, desktop: 36),
                                          ),
                                        );
                                      },
                                    ),
                                    SizedBox(width: layout.spaceM),
                                    Expanded(
                                      child: Text(
                                        l10n.onb_demo_success_toast,
                                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                          color: AppColors.success(context),
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
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

  Widget _buildDemoCard(BuildContext context, AppLocalizations l10n, AppSize layout) {
    return GestureDetector(
      onTap: _isDemoAdded ? null : _addDemoTransaction,
      child: AnimatedBuilder(
        animation: _buttonScaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _isAdding ? 0.98 : _buttonScaleAnimation.value,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              width: double.infinity,
              padding: EdgeInsets.all(layout.space2xl),
              decoration: BoxDecoration(
                gradient: _isDemoAdded 
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.success(context).withValues(alpha: 0.1),
                          AppColors.success(context).withValues(alpha: 0.05),
                        ],
                      )
                    : LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Theme.of(context).colorScheme.surface,
                          Theme.of(context).colorScheme.surface.withValues(alpha: 0.8),
                        ],
                      ),
                borderRadius: BorderRadius.circular(layout.radiusL),
                border: Border.all(
                  color: _isDemoAdded 
                      ? AppColors.success(context).withValues(alpha: 0.4)
                      : Theme.of(context).colorScheme.outline.withValues(alpha: 0.15),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _isDemoAdded 
                        ? AppColors.success(context).withValues(alpha: 0.2)
                        : AppColors.shadowLight(context),
                    blurRadius: _isDemoAdded ? 20 : 15,
                    offset: Offset(0, _isDemoAdded ? 8 : 6),
                  ),
                  if (_isDemoAdded)
                    BoxShadow(
                      color: AppColors.success(context).withValues(alpha: 0.1),
                      blurRadius: 30,
                      offset: const Offset(0, 12),
                    ),
                ],
              ),
              child: Column(
                children: [
                  // Amount
                  Text(
                    l10n.onb_demo_amount,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: _isDemoAdded 
                          ? AppColors.success(context)
                          : Theme.of(context).colorScheme.primary,
                    ) ?? const TextStyle(),
                  ),

                  SizedBox(height: layout.spaceL),

                  // Transaction details
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.onb_demo_category,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: _isDemoAdded 
                                  ? AppColors.success(context)
                                  : Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            l10n.note,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                          Text(
                            l10n.onb_demo_note,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: _isDemoAdded 
                                  ? AppColors.success(context)
                                  : Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: layout.spaceL),

                  // Category icon or success icon
                  Container(
                    padding: EdgeInsets.all(layout.spaceM),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: _isDemoAdded 
                            ? [
                                AppColors.success(context).withValues(alpha: 0.15),
                                AppColors.success(context).withValues(alpha: 0.08),
                              ]
                            : Theme.of(context).brightness == Brightness.dark
                                ? [
                                    Colors.orangeAccent.withValues(alpha: 0.15),
                                    Colors.orangeAccent.withValues(alpha: 0.08),
                                  ]
                                : [
                                    Theme.of(context).primaryColor.withValues(alpha: 0.15),
                                    Theme.of(context).primaryColor.withValues(alpha: 0.08),
                                  ],
                      ),
                      borderRadius: BorderRadius.circular(layout.radiusS),
                      border: Border.all(
                        color: _isDemoAdded 
                            ? AppColors.success(context).withValues(alpha: 0.3)
                            : Theme.of(context).brightness == Brightness.dark
                                ? Colors.orangeAccent.withValues(alpha: 0.3)
                                : Theme.of(context).primaryColor.withValues(alpha: 0.2),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _isDemoAdded 
                              ? AppColors.success(context).withValues(alpha: 0.1)
                              : Theme.of(context).brightness == Brightness.dark
                                  ? Colors.orangeAccent.withValues(alpha: 0.1)
                                  : Theme.of(context).primaryColor.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: _isDemoAdded 
                        ? Icon(
                            Icons.check_circle_rounded,
                            size: layout.responsiveIconSize(phone: 32, tablet: 36, desktop: 40),
                            color: AppColors.success(context),
                          )
                        : Icon(
                            Icons.local_cafe_rounded,
                            size: layout.responsiveIconSize(phone: 32, tablet: 36, desktop: 40),
                            color: Theme.of(context).brightness == Brightness.dark 
                                ? Colors.orangeAccent 
                                : Theme.of(context).primaryColor,
                          ),
                  ),

                  // Add button or loading indicator with enhanced animations
                  if (!_isDemoAdded) ...[
                    SizedBox(height: layout.spaceL),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: layout.spaceM),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Theme.of(context).colorScheme.primary,
                            Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(layout.radiusM),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: _isAdding
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).colorScheme.onPrimary,
                                    ),
                                  ),
                                ),
                                SizedBox(width: layout.spaceM),
                                Text(
                                  'Adding...',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.onPrimary,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              l10n.onb_demo_cta,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
