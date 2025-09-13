import 'package:flutter/material.dart';
import 'package:pocketa/core/design_system/design_system.dart';
import 'package:pocketa/shared/widgets/glass_container.dart';

/// Consolidated UI utilities for consistent design implementation
/// Reduces code duplication and provides reusable components
class AppUIUtils {
  /// Create a premium glass card with consistent styling
  static Widget glassCard({
    required BuildContext context,
    required Widget child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    VoidCallback? onTap,
    double? borderRadius,
  }) {
    final glassCard = GlassContainer(
      padding: padding ?? DesignTokens.getCardPadding(context),
      margin: margin ?? EdgeInsets.all(DesignTokens.spaceS),
      borderRadius: BorderRadius.circular(
        borderRadius ?? DesignTokens.getResponsiveRadius(
          context,
          phone: DesignTokens.radiusL,
          tablet: DesignTokens.radiusL + 2,
          desktop: DesignTokens.radiusL + 4,
        ),
      ),
      child: child,
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(
            borderRadius ?? DesignTokens.getResponsiveRadius(
              context,
              phone: DesignTokens.radiusL,
              tablet: DesignTokens.radiusL + 2,
              desktop: DesignTokens.radiusL + 4,
            ),
          ),
          child: glassCard,
        ),
      );
    }

    return glassCard;
  }

  /// Create a premium button with consistent styling and micro-interactions
  static Widget premiumButton({
    required BuildContext context,
    required String label,
    required VoidCallback onPressed,
    bool isPrimary = true,
    bool isLoading = false,
    IconData? icon,
    bool enabled = true,
  }) {
    final buttonHeight = DesignTokens.getButtonHeight(context);
    final borderRadius = DesignTokens.getResponsiveRadius(
      context,
      phone: DesignTokens.radiusS,
      tablet: DesignTokens.radiusM,
      desktop: DesignTokens.radiusM,
    );
    final horizontalPadding = DesignTokens.getResponsiveSpacing(
      context,
      phone: DesignTokens.spaceL,
      tablet: DesignTokens.spaceXl,
      desktop: DesignTokens.space2xl,
    );
    final fontSize = DesignTokens.getResponsiveFontSize(
      context,
      phone: DesignTokens.fontSizeM,
      tablet: DesignTokens.fontSizeL,
      desktop: DesignTokens.fontSizeL,
    );

    return Container(
      height: buttonHeight,
      decoration: BoxDecoration(
        gradient: isPrimary && enabled
            ? ColorTokens.primaryGradient(context)
            : null,
        color: enabled ? null : ColorTokens.buttonDisabled(context),
        borderRadius: BorderRadius.circular(borderRadius),
        border: isPrimary && enabled
            ? Border.all(
                color: ColorTokens.primaryMedium(context),
                width: 1,
              )
            : Border.all(
                color: ColorTokens.borderSubtle(context),
                width: 1.5,
              ),
        boxShadow: isPrimary && enabled
            ? DesignTokens.getShadowPrimary(context)
            : DesignTokens.getShadowLight(context),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onPressed : null,
          borderRadius: BorderRadius.circular(borderRadius),
          splashColor: enabled 
              ? (isPrimary ? ColorTokens.buttonOnPrimary(context) : ColorTokens.primary(context)).withValues(alpha: 0.1)
              : ColorTokens.textDisabled(context).withValues(alpha: 0.05),
          highlightColor: enabled 
              ? (isPrimary ? ColorTokens.buttonOnPrimary(context) : ColorTokens.primary(context)).withValues(alpha: 0.05)
              : ColorTokens.textDisabled(context).withValues(alpha: 0.02),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading)
                  SizedBox(
                    width: DesignTokens.getResponsiveIconSize(
                      context,
                      phone: DesignTokens.iconS,
                      tablet: DesignTokens.iconM,
                      desktop: DesignTokens.iconM + 2,
                    ),
                    height: DesignTokens.getResponsiveIconSize(
                      context,
                      phone: DesignTokens.iconS,
                      tablet: DesignTokens.iconM,
                      desktop: DesignTokens.iconM + 2,
                    ),
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        enabled ? (isPrimary ? ColorTokens.buttonOnPrimary(context) : ColorTokens.primary(context)) : ColorTokens.textDisabled(context),
                      ),
                    ),
                  )
                else if (icon != null)
                  Icon(
                    icon,
                    color: enabled ? (isPrimary ? ColorTokens.buttonOnPrimary(context) : ColorTokens.primary(context)) : ColorTokens.textDisabled(context),
                    size: DesignTokens.getResponsiveIconSize(
                      context,
                      phone: DesignTokens.iconS,
                      tablet: DesignTokens.iconM,
                      desktop: DesignTokens.iconM + 2,
                    ),
                  ),
                
                if (isLoading || icon != null)
                  SizedBox(width: DesignTokens.spaceM),
                
                Text(
                  label,
                  style: TypographyTokens.buttonText(context).copyWith(
                    fontSize: fontSize,
                    color: enabled ? (isPrimary ? ColorTokens.buttonOnPrimary(context) : ColorTokens.primary(context)) : ColorTokens.textDisabled(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Create a feature chip with consistent styling
  static Widget featureChip({
    required BuildContext context,
    required String label,
    required IconData icon,
    bool isSelected = false,
    VoidCallback? onTap,
  }) {
    return Container(
      padding: DesignTokens.getResponsivePadding(
        context,
        horizontal: DesignTokens.spaceL,
        vertical: DesignTokens.spaceM,
      ),
      decoration: ComponentTokens.chipDecoration(context, isSelected: isSelected),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: DesignTokens.getResponsiveIconSize(
              context,
              phone: DesignTokens.iconM,
              tablet: DesignTokens.iconM + 2,
              desktop: DesignTokens.iconM + 4,
            ),
            color: isSelected 
                ? ColorTokens.primary(context)
                : ColorTokens.iconSecondary(context),
          ),
          SizedBox(width: DesignTokens.spaceS),
          Text(
            label,
            style: TypographyTokens.labelMedium(context).copyWith(
              color: isSelected 
                  ? ColorTokens.primary(context)
                  : ColorTokens.textSecondary(context),
              fontWeight: isSelected ? DesignTokens.fontWeightSemiBold : DesignTokens.fontWeightMedium,
            ),
          ),
        ],
      ),
    );
  }

  /// Create a progress indicator with consistent styling
  static Widget progressIndicator({
    required BuildContext context,
    required int currentStep,
    required int totalSteps,
  }) {
    final progress = currentStep / (totalSteps - 1);
    
    return Container(
      padding: DesignTokens.getResponsivePadding(
        context,
        horizontal: DesignTokens.spaceL,
        vertical: DesignTokens.spaceM,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Step $currentStep of $totalSteps',
                style: TypographyTokens.labelMedium(context).copyWith(
                  color: ColorTokens.textSecondary(context),
                ),
              ),
              Text(
                '${(progress * 100).round()}%',
                style: TypographyTokens.labelMedium(context).copyWith(
                  color: ColorTokens.primary(context),
                  fontWeight: DesignTokens.fontWeightSemiBold,
                ),
              ),
            ],
          ),
          SizedBox(height: DesignTokens.spaceS),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: ColorTokens.surfaceElevated(context),
            valueColor: AlwaysStoppedAnimation<Color>(ColorTokens.primary(context)),
            borderRadius: BorderRadius.circular(DesignTokens.radiusS),
            minHeight: 4,
          ),
        ],
      ),
    );
  }

  /// Create dots indicator with consistent styling
  static Widget dotsIndicator({
    required BuildContext context,
    required int currentStep,
    required int totalSteps,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        final isActive = index == currentStep;
        return Container(
          margin: EdgeInsets.symmetric(horizontal: DesignTokens.spaceS),
          width: isActive 
              ? DesignTokens.getResponsiveSpacing(
                  context,
                  phone: 24,
                  tablet: 28,
                  desktop: 32,
                )
              : DesignTokens.getResponsiveSpacing(
                  context,
                  phone: 8,
                  tablet: 10,
                  desktop: 12,
                ),
          height: DesignTokens.getResponsiveSpacing(
            context,
            phone: 8,
            tablet: 10,
            desktop: 12,
          ),
          decoration: BoxDecoration(
            color: isActive 
                ? ColorTokens.primary(context)
                : ColorTokens.surfaceElevated(context),
            borderRadius: BorderRadius.circular(DesignTokens.radiusXs),
          ),
        );
      }),
    );
  }

}
