import 'package:flutter/material.dart';
import 'package:pocketa/core/responsive/responsive.dart';
import 'package:pocketa/core/theme/app_colors.dart';
import 'package:pocketa/shared/ui_components/performance/interactive_wrapper.dart';

/// Button styles for different use cases
enum AppButtonStyle { primary, secondary, outline, text }

/// Button sizes for different contexts
enum AppButtonSize { small, medium, large }

/// Performance-optimized button with multiple styles and states
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonStyle style;
  final AppButtonSize size;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;
  final bool enableHaptic;
  final Duration animationDuration;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.style = AppButtonStyle.primary,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.enableHaptic = true,
    this.animationDuration = const Duration(milliseconds: 150),
  });

  @override
  Widget build(BuildContext context) {
    final layout = context.layout;
    final theme = Theme.of(context);
    final buttonStyle = _getButtonStyle(context, theme, layout);

    Widget button = ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: buttonStyle,
      child: _buildButtonContent(context, layout),
    );

    if (isFullWidth) {
      button = SizedBox(width: double.infinity, child: button);
    }

    // Use RepaintBoundary for performance
    return RepaintBoundary(
      child: InteractiveWrapper(
        onTap: onPressed,
        enableHaptic: enableHaptic,
        child: button,
      ),
    );
  }

  ButtonStyle _getButtonStyle(BuildContext context, ThemeData theme, AppSize layout) {
    final borderRadius = BorderRadius.circular(layout.radiusL);
    final padding = _getPadding(layout);

    switch (style) {
      case AppButtonStyle.primary:
        return ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary(context),
          foregroundColor: AppColors.onPrimary(context),
          elevation: 2,
          shadowColor: AppColors.primary(context).withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          padding: padding,
        );
      case AppButtonStyle.secondary:
        return ElevatedButton.styleFrom(
          backgroundColor: AppColors.success(context),
          foregroundColor: AppColors.onSuccess(context),
          elevation: 1,
          shadowColor: AppColors.success(context).withValues(alpha: 0.2),
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          padding: padding,
        );
      case AppButtonStyle.outline:
        return ElevatedButton.styleFrom(
          backgroundColor: AppColors.transparent,
          foregroundColor: AppColors.primary(context),
          elevation: 0,
          side: BorderSide(
            color: AppColors.primary(context),
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          padding: padding,
        );
      case AppButtonStyle.text:
        return ElevatedButton.styleFrom(
          backgroundColor: AppColors.transparent,
          foregroundColor: AppColors.primary(context),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          padding: padding,
        );
    }
  }

  EdgeInsetsGeometry _getPadding(AppSize layout) {
    switch (size) {
      case AppButtonSize.small:
        return EdgeInsets.symmetric(
          horizontal: layout.spaceL,
          vertical: layout.spaceM,
        );
      case AppButtonSize.medium:
        return EdgeInsets.symmetric(
          horizontal: layout.spaceXL,
          vertical: layout.spaceL,
        );
      case AppButtonSize.large:
        return EdgeInsets.symmetric(
          horizontal: layout.space2XL,
          vertical: layout.spaceXL,
        );
    }
  }

  Widget _buildButtonContent(BuildContext context, AppSize layout) {
    if (isLoading) {
      return SizedBox(
        height: layout.responsiveSize(phone: 16, tablet: 18, desktop: 20),
        width: layout.responsiveSize(phone: 16, tablet: 18, desktop: 20),
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: layout.responsiveIconSize(phone: 16, tablet: 18, desktop: 20),
          ),
          SizedBox(width: layout.spaceS),
          Text(
            text,
            style: _getTextStyle(context, layout),
          ),
        ],
      );
    }

    return Text(
      text,
      style: _getTextStyle(context, layout),
    );
  }

  TextStyle _getTextStyle(BuildContext context, AppSize layout) {
    final theme = Theme.of(context);
    final fontSize = layout.responsiveSize(
      phone: 14,
      tablet: 16,
      desktop: 18,
    );

    return theme.textTheme.labelLarge?.copyWith(
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
    ) ?? TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
    );
  }
}