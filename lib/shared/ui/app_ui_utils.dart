import 'package:flutter/material.dart';
import 'package:pocketa/core/responsive/responsive.dart';

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
    final theme = Theme.of(context);
    final layout = context.layout;
    final isDark = theme.brightness == Brightness.dark;
    
    final card = Container(
      margin: margin ?? EdgeInsets.all(layout.spaceS),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.surface.withValues(alpha: isDark ? 0.85 : 0.95),
            theme.colorScheme.surface.withValues(alpha: isDark ? 0.75 : 0.90),
          ],
        ),
        borderRadius: BorderRadius.circular(borderRadius ?? layout.radiusL),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: isDark ? 0.20 : 0.12),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: isDark ? 0.30 : 0.20),
            blurRadius: layout.responsiveSize(phone: 16, tablet: 20, desktop: 24),
            offset: const Offset(0, 8),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Padding(
        padding: padding ?? EdgeInsets.all(layout.spaceL),
        child: child,
      ),
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius ?? layout.radiusL),
          child: card,
        ),
      );
    }

    return card;
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
    final theme = Theme.of(context);
    final layout = context.layout;
    
    final buttonHeight = layout.responsiveSize(phone: 48, tablet: 52, desktop: 56);
    final borderRadius = layout.responsiveSize(phone: 14, tablet: 16, desktop: 18);
    final horizontalPadding = layout.responsiveSize(phone: 20, tablet: 24, desktop: 28);
    final fontSize = layout.responsiveSize(phone: 15, tablet: 16, desktop: 18);

    return Container(
      height: buttonHeight,
      decoration: BoxDecoration(
        gradient: isPrimary && enabled
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.primary.withValues(alpha: 0.85),
                ],
              )
            : null,
        color: enabled ? null : theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(borderRadius),
        border: isPrimary && enabled
            ? Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.2),
                width: 1,
              )
            : Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.15),
                width: 1.5,
              ),
        boxShadow: isPrimary && enabled
            ? [
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(alpha: 0.4),
                  blurRadius: layout.responsiveSize(phone: 16, tablet: 20, desktop: 24),
                  offset: const Offset(0, 6),
                  spreadRadius: 2,
                ),
              ]
            : [
                BoxShadow(
                  color: theme.colorScheme.shadow.withValues(alpha: 0.08),
                  blurRadius: layout.responsiveSize(phone: 8, tablet: 10, desktop: 12),
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onPressed : null,
          borderRadius: BorderRadius.circular(borderRadius),
          splashColor: enabled 
              ? (isPrimary ? theme.colorScheme.onPrimary : theme.colorScheme.primary).withValues(alpha: 0.1)
              : theme.colorScheme.onSurface.withValues(alpha: 0.05),
          highlightColor: enabled 
              ? (isPrimary ? theme.colorScheme.onPrimary : theme.colorScheme.primary).withValues(alpha: 0.05)
              : theme.colorScheme.onSurface.withValues(alpha: 0.02),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading)
                  SizedBox(
                    width: layout.responsiveSize(phone: 18, tablet: 20, desktop: 22),
                    height: layout.responsiveSize(phone: 18, tablet: 20, desktop: 22),
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        enabled ? (isPrimary ? theme.colorScheme.onPrimary : theme.colorScheme.primary) : theme.colorScheme.onSurface,
                      ),
                    ),
                  )
                else if (icon != null)
                  Icon(
                    icon,
                    color: enabled ? (isPrimary ? theme.colorScheme.onPrimary : theme.colorScheme.primary) : theme.colorScheme.onSurface,
                    size: layout.responsiveSize(phone: 18, tablet: 20, desktop: 22),
                  ),
                
                if (isLoading || icon != null)
                  SizedBox(width: layout.spaceM),
                
                Text(
                  label,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w700,
                    color: enabled ? (isPrimary ? theme.colorScheme.onPrimary : theme.colorScheme.primary) : theme.colorScheme.onSurface,
                    letterSpacing: 0.3,
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
    final theme = Theme.of(context);
    final layout = context.layout;
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: layout.spaceL,
        vertical: layout.spaceM,
      ),
      decoration: BoxDecoration(
        color: isSelected 
            ? theme.colorScheme.primaryContainer
            : theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(layout.radiusS),
        border: Border.all(
          color: isSelected 
              ? theme.colorScheme.primary.withValues(alpha: 0.3)
              : theme.colorScheme.outline.withValues(alpha: 0.12),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: layout.iconM,
            color: isSelected 
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurfaceVariant,
          ),
          SizedBox(width: layout.spaceS),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: isSelected 
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
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
    final theme = Theme.of(context);
    final layout = context.layout;
    final progress = currentStep / (totalSteps - 1);
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: layout.spaceL,
        vertical: layout.spaceM,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Step $currentStep of $totalSteps',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                '${(progress * 100).round()}%',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: layout.spaceS),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
            borderRadius: BorderRadius.circular(layout.radiusS),
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
    final theme = Theme.of(context);
    final layout = context.layout;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        final isActive = index == currentStep;
        return Container(
          margin: EdgeInsets.symmetric(horizontal: layout.spaceS),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive 
                ? theme.colorScheme.primary
                : theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }

  /// Get responsive spacing based on context
  static EdgeInsetsGeometry responsivePadding(BuildContext context, {
    double? all,
    double? horizontal,
    double? vertical,
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) {
    return EdgeInsets.only(
      top: top ?? vertical ?? all ?? 0,
      bottom: bottom ?? vertical ?? all ?? 0,
      left: left ?? horizontal ?? all ?? 0,
      right: right ?? horizontal ?? all ?? 0,
    );
  }

  /// Get responsive text style based on context
  static TextStyle responsiveTextStyle(BuildContext context, {
    required TextStyle phone,
    TextStyle? tablet,
    TextStyle? desktop,
  }) {
    final layout = context.layout;
    
    if (layout.isDesktop && desktop != null) return desktop;
    if (layout.isTablet && tablet != null) return tablet;
    return phone;
  }
}
