import 'package:flutter/material.dart';
import 'package:pocketa/core/responsive/responsive.dart';
import 'package:pocketa/core/theme/colors.dart';
import 'package:pocketa/core/theme/text_styles.dart';

/// Enhanced button components with consistent styling and responsive design
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonStyle style;
  final AppButtonSize size;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;
  final EdgeInsetsGeometry? padding;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.style = AppButtonStyle.primary,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final layout = context.layout;
    final theme = Theme.of(context);

    final buttonStyle = _getButtonStyle(context, theme);
    final buttonSize = _getButtonSize(layout);

    Widget button = ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: buttonStyle,
      child: _buildButtonContent(context, layout),
    );

    if (isFullWidth) {
      button = SizedBox(
        width: double.infinity,
        child: button,
      );
    }

    return button;
  }

  ButtonStyle _getButtonStyle(BuildContext context, ThemeData theme) {
    switch (style) {
      case AppButtonStyle.primary:
        return ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          elevation: 2,
          shadowColor: theme.colorScheme.shadow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        );
      case AppButtonStyle.secondary:
        return ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.secondary,
          foregroundColor: theme.colorScheme.onSecondary,
          elevation: 1,
          shadowColor: theme.colorScheme.shadow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        );
      case AppButtonStyle.outline:
        return ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: theme.colorScheme.primary,
          elevation: 0,
          side: BorderSide(
            color: theme.colorScheme.primary,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        );
      case AppButtonStyle.text:
        return ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: theme.colorScheme.primary,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        );
    }
  }

  Size _getButtonSize(AppLayout layout) {
    switch (size) {
      case AppButtonSize.small:
        return Size(0, layout.responsiveSize(phone: 32, tablet: 36, desktop: 40));
      case AppButtonSize.medium:
        return Size(0, layout.responsiveSize(phone: 40, tablet: 44, desktop: 48));
      case AppButtonSize.large:
        return Size(0, layout.responsiveSize(phone: 48, tablet: 52, desktop: 56));
    }
  }

  Widget _buildButtonContent(BuildContext context, AppLayout layout) {
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
          SizedBox(width: layout.spacingS),
          Text(text),
        ],
      );
    }

    return Text(text);
  }
}

/// Floating action button with enhanced styling
class AppFloatingActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String? tooltip;
  final AppFloatingActionButtonSize size;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const AppFloatingActionButton({
    super.key,
    this.onPressed,
    required this.icon,
    this.tooltip,
    this.size = AppFloatingActionButtonSize.regular,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final layout = context.layout;

    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: tooltip,
      backgroundColor: backgroundColor ?? theme.colorScheme.primary,
      foregroundColor: foregroundColor ?? theme.colorScheme.onPrimary,
      elevation: 4,
      child: Icon(
        icon,
        size: layout.responsiveIconSize(phone: 24, tablet: 28, desktop: 32),
      ),
    );
  }
}

/// Icon button with enhanced styling
class AppIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String? tooltip;
  final Color? color;
  final double? size;
  final EdgeInsetsGeometry? padding;

  const AppIconButton({
    super.key,
    this.onPressed,
    required this.icon,
    this.tooltip,
    this.color,
    this.size,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final layout = context.layout;
    final theme = Theme.of(context);

    return IconButton(
      onPressed: onPressed,
      tooltip: tooltip,
      icon: Icon(
        icon,
        color: color ?? theme.colorScheme.onSurface,
        size: size ?? layout.responsiveIconSize(phone: 20, tablet: 24, desktop: 28),
      ),
      padding: padding ?? layout.paddingS,
    );
  }
}

/// Button styles enum
enum AppButtonStyle {
  primary,
  secondary,
  outline,
  text,
}

/// Button sizes enum
enum AppButtonSize {
  small,
  medium,
  large,
}

/// Floating action button sizes enum
enum AppFloatingActionButtonSize {
  small,
  regular,
  large,
}
