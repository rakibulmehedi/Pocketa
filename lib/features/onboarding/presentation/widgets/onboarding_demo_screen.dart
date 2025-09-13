import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/core/responsive/responsive.dart';
import 'package:pocketa/core/design_system/design_system.dart';
import 'package:pocketa/features/onboarding/presentation/viewmodels/onboarding_providers.dart';
import 'package:pocketa/l10n/app_localizations.dart';
import 'package:pocketa/shared/services/celebration_service.dart';
import 'package:pocketa/shared/ui/app_ui_utils.dart';
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

      // Trigger celebration
      if (mounted) {
        await CelebrationService.safeCelebrate(
          context,
          CelebrationEvent.firstTransaction,
          ref: ref,
        );
        
        // Show success toast
        _showSuccessToast();
      }
    } catch (e) {
      setState(() {
        _isAdding = false;
      });
      
      // Show error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: CustomSnackbar(
              message: 'Failed to add demo transaction: $e',
              type: SnackbarType.error,
              duration: const Duration(seconds: 4),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
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
        content: CustomSnackbar(
          message: l10n.onb_demo_success_toast,
          type: SnackbarType.success,
          duration: const Duration(seconds: 2),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final layout = context.layout;

    return Column(
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
                      style: TypographyTokens.responsive(
                        context,
                        phone: TypographyTokens.headlineMedium(context).copyWith(
                          fontWeight: DesignTokens.fontWeightBold,
                          color: ColorTokens.textPrimary(context),
                        ),
                        tablet: TypographyTokens.headlineLarge(context).copyWith(
                          fontWeight: DesignTokens.fontWeightBold,
                          color: ColorTokens.textPrimary(context),
                        ),
                        desktop: TypographyTokens.headlineLarge(context).copyWith(
                          fontWeight: DesignTokens.fontWeightBold,
                          color: ColorTokens.textPrimary(context),
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: DesignTokens.spaceL),

                    Text(
                      l10n.onb_demo_helper,
                      style: TypographyTokens.responsive(
                        context,
                        phone: TypographyTokens.bodyLarge(context).copyWith(
                          color: ColorTokens.textSecondary(context),
                        ),
                        tablet: TypographyTokens.bodyLarge(context).copyWith(
                          color: ColorTokens.textSecondary(context),
                        ),
                        desktop: TypographyTokens.bodyLarge(context).copyWith(
                          color: ColorTokens.textSecondary(context),
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: DesignTokens.space2xl),

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
                              padding: DesignTokens.getCardPadding(context),
                              decoration: ComponentTokens.successCardDecoration(context),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color: ColorTokens.success(context),
                                    size: DesignTokens.getResponsiveIconSize(
                                      context,
                                      phone: DesignTokens.iconL,
                                      tablet: DesignTokens.iconL + 4,
                                      desktop: DesignTokens.iconL + 8,
                                    ),
                                  ),
                                  SizedBox(width: DesignTokens.spaceM),
                                  Expanded(
                                    child: Text(
                                      l10n.onb_demo_success_toast,
                                      style: TypographyTokens.bodyLarge(context).copyWith(
                                        color: ColorTokens.success(context),
                                        fontWeight: DesignTokens.fontWeightMedium,
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
    );
  }

  Widget _buildDemoCard(BuildContext context, AppLocalizations l10n, AppSize layout) {
    return GestureDetector(
      onTap: _isDemoAdded ? null : _addDemoTransaction,
      child: AnimatedContainer(
        duration: DesignTokens.animationNormal,
        width: double.infinity,
        padding: DesignTokens.getCardPadding(context),
        decoration: _isDemoAdded 
            ? ComponentTokens.successCardDecoration(context)
            : ComponentTokens.elevatedCardDecoration(context),
        child: Column(
          children: [
            // Amount
            Text(
              l10n.onb_demo_amount,
              style: TypographyTokens.headlineLarge(context).copyWith(
                fontWeight: DesignTokens.fontWeightBold,
                color: _isDemoAdded 
                    ? ColorTokens.success(context)
                    : ColorTokens.primary(context),
              ),
            ),

            SizedBox(height: DesignTokens.spaceL),

            // Transaction details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.onb_demo_category,
                      style: TypographyTokens.titleMedium(context).copyWith(
                        fontWeight: DesignTokens.fontWeightSemiBold,
                        color: _isDemoAdded 
                            ? ColorTokens.success(context)
                            : ColorTokens.textPrimary(context),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      l10n.note,
                      style: TypographyTokens.bodySmall(context).copyWith(
                        color: ColorTokens.textTertiary(context),
                      ),
                    ),
                    Text(
                      l10n.onb_demo_note,
                      style: TypographyTokens.titleMedium(context).copyWith(
                        fontWeight: DesignTokens.fontWeightMedium,
                        color: _isDemoAdded 
                            ? ColorTokens.success(context)
                            : ColorTokens.textPrimary(context),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: DesignTokens.spaceL),

            // Category icon or success icon
            Container(
              padding: EdgeInsets.all(DesignTokens.spaceM),
              decoration: BoxDecoration(
                gradient: _isDemoAdded 
                    ? ColorTokens.successGradient(context)
                    : ColorTokens.primaryGradient(context),
                borderRadius: BorderRadius.circular(DesignTokens.radiusS),
                border: Border.all(
                  color: _isDemoAdded 
                      ? ColorTokens.successStrong(context)
                      : ColorTokens.primaryMedium(context),
                  width: 1,
                ),
                boxShadow: DesignTokens.getShadowLight(context),
              ),
              child: _isDemoAdded 
                  ? Icon(
                      Icons.check_circle_rounded,
                      size: DesignTokens.getResponsiveIconSize(
                        context,
                        phone: DesignTokens.icon2xl,
                        tablet: DesignTokens.icon2xl + 4,
                        desktop: DesignTokens.icon2xl + 8,
                      ),
                      color: ColorTokens.success(context),
                    )
                  : Icon(
                      Icons.local_cafe_rounded,
                      size: DesignTokens.getResponsiveIconSize(
                        context,
                        phone: DesignTokens.icon2xl,
                        tablet: DesignTokens.icon2xl + 4,
                        desktop: DesignTokens.icon2xl + 8,
                      ),
                      color: ColorTokens.buttonOnPrimary(context),
                    ),
            ),

            // Add button or loading indicator
            if (!_isDemoAdded) ...[
              SizedBox(height: DesignTokens.spaceL),
              AppUIUtils.premiumButton(
                context: context,
                label: _isAdding ? 'Adding...' : l10n.onb_demo_cta,
                onPressed: _addDemoTransaction,
                isLoading: _isAdding,
                isPrimary: true,
                enabled: !_isAdding,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
