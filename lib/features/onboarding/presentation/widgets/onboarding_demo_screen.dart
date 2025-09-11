import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/core/responsive/responsive.dart';
import 'package:pocketa/core/theme/app_colors.dart';
import 'package:pocketa/features/onboarding/presentation/viewmodels/onboarding_providers.dart';
import 'package:pocketa/l10n/app_localizations.dart';
import 'package:pocketa/shared/widgets/confetti_widget.dart';

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
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  
  bool _isDemoAdded = false;
  bool _isAdding = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _confettiController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _startAnimation();
  }

  void _startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _animationController.forward();
  }

  Future<void> _addDemoTransaction() async {
    if (_isAdding || _isDemoAdded) return;
    
    setState(() {
      _isAdding = true;
    });

    try {
      // Actually create a demo transaction
      await _createDemoTransaction();
      
      setState(() {
        _isDemoAdded = true;
        _isAdding = false;
      });

      // Trigger confetti animation
      _confettiController.forward();
      
      // Show success toast
      _showSuccessToast();
    } catch (e) {
      setState(() {
        _isAdding = false;
      });
      
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

  void _showSuccessToast() {
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.onb_demo_success_toast),
        backgroundColor: AppColors.success(context),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final layout = context.layout;

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
                    // Header
                    Text(
                      l10n.onb_demo_title,
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
                      l10n.onb_demo_helper,
                      style: layout.responsiveTextStyle(
                        phone: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                        ) ?? const TextStyle(),
                        tablet: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                        ) ?? const TextStyle(),
                        desktop: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                        ) ?? const TextStyle(),
                      ),
                      textAlign: TextAlign.center,
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

                    // Success message (only show after demo is added)
                    if (_isDemoAdded)
                      AnimatedBuilder(
                        animation: _fadeAnimation,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _fadeAnimation.value,
                            child: Container(
                              padding: EdgeInsets.all(layout.space2xl),
                              decoration: BoxDecoration(
                                color: AppColors.successContainer(context),
                                borderRadius: BorderRadius.circular(layout.radiusM),
                                border: Border.all(
                                  color: AppColors.success(context).withValues(alpha: 0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color: AppColors.success(context),
                                    size: layout.responsiveIconSize(phone: 24, tablet: 28, desktop: 32),
                                  ),
                                  SizedBox(width: layout.spaceM),
                                  Expanded(
                                    child: Text(
                                      l10n.onb_demo_success_toast,
                                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                        color: AppColors.success(context),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        padding: EdgeInsets.all(layout.space2xl),
        decoration: BoxDecoration(
          color: _isDemoAdded 
              ? AppColors.successContainer(context)
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(layout.radiusL),
          border: Border.all(
            color: _isDemoAdded 
                ? AppColors.success(context).withValues(alpha: 0.3)
                : Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: _isDemoAdded 
                  ? AppColors.success(context).withValues(alpha: 0.1)
                  : AppColors.shadowLight(context),
              blurRadius: 10,
              offset: const Offset(0, 4),
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

            // Add button or loading indicator
            if (!_isDemoAdded) ...[
              SizedBox(height: layout.spaceL),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: layout.spaceM),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(layout.radiusM),
                ),
                child: _isAdding
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
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
                        ),
                      ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
