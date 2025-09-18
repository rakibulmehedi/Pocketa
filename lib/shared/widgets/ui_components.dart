import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pocketa/core/responsive/responsive.dart';
import 'package:pocketa/l10n/app_localizations.dart';
import 'package:pocketa/core/theme/app_colors.dart';

// ============================================================================
// PERFORMANCE-OPTIMIZED PREMIUM UI COMPONENTS
// ============================================================================

/// Enhanced Custom App Bar with premium fintech design
/// Features:
/// - Smart back/menu handling with haptic feedback
/// - Optional subtitle and trailing metric pill
/// - Responsive typography and spacing
/// - Performance-optimized with RepaintBoundary
/// - Material 3 design with subtle animations
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final bool showBack;
  final VoidCallback? onBackTap;
  final VoidCallback? onMenuTap;
  final List<Widget>? actions;
  final String? trailingPillText;
  final IconData? trailingPillIcon;
  final Color? trailingPillColor;
  final Color? accentColor;
  final double height;
  final PreferredSizeWidget? bottom;
  final bool enableHaptic;
  final Duration animationDuration;

  const CustomAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.showBack = false,
    this.onBackTap,
    this.onMenuTap,
    this.actions,
    this.trailingPillText,
    this.trailingPillIcon,
    this.trailingPillColor,
    this.accentColor,
    this.height = kToolbarHeight,
    this.bottom,
    this.enableHaptic = true,
    this.animationDuration = const Duration(milliseconds: 200),
  });

  @override
  Size get preferredSize => Size.fromHeight(height + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final layout = context.layout;
    final device = context.device;
    final onSurface = theme.colorScheme.onSurface;
    final muted = onSurface.withValues(alpha: 0.65);
    final accent = accentColor ?? AppColors.primary(context);

    return RepaintBoundary(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
              child: AppBar(
                elevation: 0,
                scrolledUnderElevation: 3,
                surfaceTintColor: theme.colorScheme.surfaceTint,
                centerTitle: false,
                titleSpacing: 8,
                leadingWidth: 56,
                leading: _InteractiveWrapper(
                  onTap: _getLeadingAction(context),
                  enableHaptic: enableHaptic,
                  animationDuration: animationDuration,
                  child: IconButton(
                    onPressed: _getLeadingAction(context),
                    icon: Icon(
                      showBack ? Icons.arrow_back_ios_new_rounded : Icons.menu_rounded,
                      size: layout.iconM,
                    ),
                    tooltip: showBack
                        ? AppLocalizations.of(context).back
                        : AppLocalizations.of(context).menu,
                  ),
                ),
                title: _buildTitle(context, theme, layout, device, muted),
                actions: _buildActions(context, theme, layout, accent),
                bottom: bottom,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context, ThemeData theme, AppSize layout, DeviceSize device, Color muted) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleLarge?.copyWith(
            fontSize: _getResponsiveFontSize(device, layout),
            fontWeight: FontWeight.w800,
            letterSpacing: -0.2,
          ),
        ),
        if (subtitle != null && subtitle!.trim().isNotEmpty)
          Padding(
            padding: EdgeInsets.only(top: 0.25.rem(context)),
            child: Text(
              subtitle!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: muted,
                fontSize: _getResponsiveSubtitleSize(device, layout),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  List<Widget> _buildActions(BuildContext context, ThemeData theme, AppSize layout, Color accent) {
    final pill = _buildTrailingPill(context, theme, layout, accent);
    
    return [
      if (pill != null) ...[
        Padding(
          padding: EdgeInsets.only(right: 0.75.rem(context)),
          child: pill,
        ),
      ],
      ...(actions ?? const []),
    ];
  }

  Widget? _buildTrailingPill(BuildContext context, ThemeData theme, AppSize layout, Color accent) {
    if (trailingPillText == null || trailingPillText!.isEmpty) return null;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 1.25.rem(context),
        vertical: 0.75.rem(context),
      ),
      decoration: BoxDecoration(
        color: (trailingPillColor ?? accent).withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: (trailingPillColor ?? accent).withValues(alpha: 0.22),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingPillIcon != null) ...[
            Icon(
              trailingPillIcon,
              size: 16.ic(context),
              color: trailingPillColor ?? accent,
            ),
            SizedBox(width: 0.75.rem(context)),
          ],
          Text(
            trailingPillText!,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: trailingPillColor ?? accent,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }

  VoidCallback _getLeadingAction(BuildContext context) {
    return showBack
        ? (onBackTap ?? () => Navigator.of(context).maybePop())
        : (onMenuTap ?? () {});
  }

  double _getResponsiveFontSize(DeviceSize device, AppSize layout) {
    switch (device) {
      case DeviceSize.phone:
        return 20.0;
      case DeviceSize.tablet:
        return 24.0;
      case DeviceSize.desktop:
        return 28.0;
    }
  }

  double _getResponsiveSubtitleSize(DeviceSize device, AppSize layout) {
    switch (device) {
      case DeviceSize.phone:
        return 12.0;
      case DeviceSize.tablet:
        return 14.0;
      case DeviceSize.desktop:
        return 16.0;
    }
  }
}

/// Enhanced Custom Sliver App Bar with advanced features
/// Features:
/// - Collapsible design with smooth animations
/// - Flexible space with custom content
/// - Performance-optimized scrolling
/// - Responsive design for all screen sizes
class CustomSliverAppBar extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? flexibleSpace;
  final bool pinned;
  final bool floating;
  final bool snap;
  final double expandedHeight;
  final double collapsedHeight;
  final List<Widget>? actions;
  final String? trailingPillText;
  final IconData? trailingPillIcon;
  final Color? trailingPillColor;
  final Color? accentColor;
  final bool showBack;
  final VoidCallback? onBackTap;
  final VoidCallback? onMenuTap;
  final PreferredSizeWidget? bottom;
  final bool enableHaptic;
  final Duration animationDuration;

  const CustomSliverAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.flexibleSpace,
    this.pinned = true,
    this.floating = false,
    this.snap = false,
    this.expandedHeight = 200.0,
    this.collapsedHeight = kToolbarHeight,
    this.actions,
    this.trailingPillText,
    this.trailingPillIcon,
    this.trailingPillColor,
    this.accentColor,
    this.showBack = false,
    this.onBackTap,
    this.onMenuTap,
    this.bottom,
    this.enableHaptic = true,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final layout = context.layout;
    final device = context.device;

    return SliverAppBar(
      expandedHeight: expandedHeight,
      collapsedHeight: collapsedHeight,
      pinned: pinned,
      floating: floating,
      snap: snap,
      elevation: 0,
      scrolledUnderElevation: 3,
      surfaceTintColor: theme.colorScheme.surfaceTint,
      centerTitle: false,
      titleSpacing: 8,
      leadingWidth: 56,
      leading: _InteractiveWrapper(
        onTap: _getLeadingAction(context),
        enableHaptic: enableHaptic,
        animationDuration: animationDuration,
        child: IconButton(
          onPressed: _getLeadingAction(context),
          icon: Icon(
            showBack ? Icons.arrow_back_ios_new_rounded : Icons.menu_rounded,
            size: layout.iconM,
          ),
          tooltip: showBack
              ? AppLocalizations.of(context).back
              : AppLocalizations.of(context).menu,
        ),
      ),
      title: _buildCollapsedTitle(context, theme, layout, device),
      actions: _buildActions(context, theme, layout),
      bottom: bottom,
      flexibleSpace: flexibleSpace ?? _buildDefaultFlexibleSpace(context, theme, layout, device),
    );
  }

  Widget _buildCollapsedTitle(BuildContext context, ThemeData theme, AppSize layout, DeviceSize device) {
    return Text(
      title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: theme.textTheme.titleLarge?.copyWith(
        fontSize: _getResponsiveFontSize(device, layout),
        fontWeight: FontWeight.w800,
        letterSpacing: -0.2,
      ),
    );
  }

  List<Widget> _buildActions(BuildContext context, ThemeData theme, AppSize layout) {
    final pill = _buildTrailingPill(context, theme, layout);
    
    return [
      if (pill != null) ...[
        Padding(
          padding: EdgeInsets.only(right: 0.75.rem(context)),
          child: pill,
        ),
      ],
      ...(actions ?? const []),
    ];
  }

  Widget? _buildTrailingPill(BuildContext context, ThemeData theme, AppSize layout) {
    if (trailingPillText == null || trailingPillText!.isEmpty) return null;

    final accent = accentColor ?? AppColors.primary(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 1.25.rem(context),
        vertical: 0.75.rem(context),
      ),
      decoration: BoxDecoration(
        color: (trailingPillColor ?? accent).withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: (trailingPillColor ?? accent).withValues(alpha: 0.22),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingPillIcon != null) ...[
            Icon(
              trailingPillIcon,
              size: 16.ic(context),
              color: trailingPillColor ?? accent,
            ),
            SizedBox(width: 0.75.rem(context)),
          ],
          Text(
            trailingPillText!,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: trailingPillColor ?? accent,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultFlexibleSpace(BuildContext context, ThemeData theme, AppSize layout, DeviceSize device) {
    return FlexibleSpaceBar(
      title: Text(
        title,
        style: theme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w800,
          color: theme.colorScheme.onSurface,
        ),
      ),
      titlePadding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: 16,
      ),
      background: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary(context).withValues(alpha: 0.05),
              AppColors.primary(context).withValues(alpha: 0.02),
            ],
          ),
        ),
        child: subtitle != null && subtitle!.trim().isNotEmpty
            ? Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 100,
                ),
                child: Text(
                  subtitle!,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            : null,
      ),
    );
  }

  VoidCallback _getLeadingAction(BuildContext context) {
    return showBack
        ? (onBackTap ?? () => Navigator.of(context).maybePop())
        : (onMenuTap ?? () {});
  }

  double _getResponsiveFontSize(DeviceSize device, AppSize layout) {
    switch (device) {
      case DeviceSize.phone:
        return 20.0;
      case DeviceSize.tablet:
        return 24.0;
      case DeviceSize.desktop:
        return 28.0;
    }
  }
}

/// Performance-optimized button with minimal state management
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
      child: _InteractiveWrapper(
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

/// Premium interactive card with subtle hover effects
class AppCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final double? elevation;
  final bool enableHover;
  final Duration animationDuration;

  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.elevation,
    this.enableHover = true,
    this.animationDuration = const Duration(milliseconds: 200),
  });

  @override
  Widget build(BuildContext context) {
    final layout = context.layout;
    final theme = Theme.of(context);

    return RepaintBoundary(
      child: Card(
        elevation: elevation ?? 2.0,
        shadowColor: theme.colorScheme.shadow.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(layout.radiusL),
        ),
        child: _InteractiveWrapper(
          onTap: onTap,
          enableHaptic: true,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(layout.radiusL),
            child: Padding(
              padding: padding ?? layout.insetsAll(2),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

/// Quick action buttons for common actions
class QuickButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onPressed;
  final bool isPositive;
  final bool enableHaptic;

  const QuickButton({
    super.key,
    required this.label,
    this.icon,
    required this.onPressed,
    this.isPositive = true,
    this.enableHaptic = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final layout = context.layout;
    
    return RepaintBoundary(
      child: _InteractiveWrapper(
        onTap: onPressed,
        enableHaptic: enableHaptic,
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon ?? (isPositive ? Icons.arrow_forward : Icons.cancel)),
          label: Text(
            label,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(
              layout.responsiveSize(phone: 200, tablet: 220, desktop: 240),
              layout.responsiveSize(phone: 50, tablet: 55, desktop: 60),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(layout.radiusL),
            ),
            backgroundColor: isPositive ? theme.colorScheme.primary : theme.colorScheme.error,
            shadowColor: (isPositive ? theme.colorScheme.primary : theme.colorScheme.error)
                .withValues(alpha: 0.3),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// DIALOG COMPONENTS
// ============================================================================

/// Premium interactive dialog component
class AppDialog extends StatelessWidget {
  final String? title;
  final Widget content;
  final List<Widget>? actions;
  final bool showCloseButton;
  final double? maxWidth;
  final EdgeInsetsGeometry? contentPadding;
  final bool enableHaptic;

  const AppDialog({
    super.key,
    this.title,
    required this.content,
    this.actions,
    this.showCloseButton = true,
    this.maxWidth,
    this.contentPadding,
    this.enableHaptic = true,
  });

  @override
  Widget build(BuildContext context) {
    final layout = context.layout;
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(layout.radiusL)),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? layout.responsiveSize(
            phone: double.infinity,
            tablet: 400,
            desktop: 500,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null || showCloseButton) _buildHeader(context, layout, theme),
            Padding(
              padding: contentPadding ?? layout.insetsAll(2),
              child: content,
            ),
            if (actions != null) _buildActions(context, layout, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppSize layout, ThemeData theme) {
    return Container(
      padding: layout.insetsAll(2),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(layout.radiusL),
          topRight: Radius.circular(layout.radiusL),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (title != null)
            Expanded(
              child: Text(
                title!,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          if (showCloseButton)
            RepaintBoundary(
              child: _InteractiveWrapper(
                onTap: () => Navigator.of(context).pop(),
                enableHaptic: enableHaptic,
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.close, color: theme.colorScheme.onSurface),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context, AppSize layout, ThemeData theme) {
    return Container(
      padding: layout.insetsAll(2),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(layout.radiusL),
          bottomRight: Radius.circular(layout.radiusL),
        ),
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.end, children: actions!),
    );
  }
}

/// Confirmation dialog
class AppConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? confirmText;
  final String? cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  const AppConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText,
    this.cancelText,
    this.onConfirm,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final layout = context.layout;
    final l10n = AppLocalizations.of(context);

    return AppDialog(
      title: title,
      content: Text(message, style: Theme.of(context).textTheme.bodyLarge),
      actions: [
        TextButton(
          onPressed: onCancel ?? () => Navigator.of(context).pop(),
          child: Text(cancelText ?? l10n.btn_cancel),
        ),
        SizedBox(width: layout.spaceS),
        ElevatedButton(
          onPressed: onConfirm ?? () => Navigator.of(context).pop(),
          child: Text(confirmText ?? l10n.btn_confirm),
        ),
      ],
    );
  }
}

// ============================================================================
// SNACKBAR COMPONENTS
// ============================================================================

/// Premium interactive snackbar component
class AppSnackbar extends StatelessWidget {
  final String message;
  final AppSnackbarType type;
  final Duration duration;
  final VoidCallback? action;
  final String? actionLabel;
  final bool enableHaptic;

  const AppSnackbar({
    super.key,
    required this.message,
    this.type = AppSnackbarType.info,
    this.duration = const Duration(seconds: 3),
    this.action,
    this.actionLabel,
    this.enableHaptic = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final layout = context.layout;

    return SnackBar(
      content: Row(
        children: [
          Icon(
            _getIcon(),
            color: _getTextColor(theme),
            size: 20,
          ),
          SizedBox(width: layout.spaceS),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: _getTextColor(theme),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: _getBackgroundColor(context, theme),
      duration: duration,
      action: action != null && actionLabel != null
          ? SnackBarAction(
              label: actionLabel!,
              onPressed: action!,
              textColor: _getTextColor(theme),
            )
          : null,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(layout.radiusL),
      ),
      margin: EdgeInsets.all(layout.spaceM),
    );
  }

  IconData _getIcon() {
    switch (type) {
      case AppSnackbarType.success:
        return Icons.check_circle_outline;
      case AppSnackbarType.error:
        return Icons.error_outline;
      case AppSnackbarType.warning:
        return Icons.warning_outlined;
      case AppSnackbarType.info:
        return Icons.info_outline;
    }
  }

  Color _getBackgroundColor(BuildContext context, ThemeData theme) {
    switch (type) {
      case AppSnackbarType.success:
        return AppColors.success(context);
      case AppSnackbarType.error:
        return AppColors.error(context);
      case AppSnackbarType.warning:
        return AppColors.warning(context);
      case AppSnackbarType.info:
        return theme.colorScheme.primary;
    }
  }

  Color _getTextColor(ThemeData theme) => AppColors.white;
}

// ============================================================================
// LIST COMPONENTS
// ============================================================================

/// Premium interactive list tile with smooth animations
class AppListTile extends StatelessWidget {
  final Widget? leading;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool enableHover;
  final Duration animationDuration;

  const AppListTile({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.enableHover = true,
    this.animationDuration = const Duration(milliseconds: 150),
  });

  @override
  Widget build(BuildContext context) {
    final layout = context.layout;

    return RepaintBoundary(
      child: _InteractiveWrapper(
        onTap: onTap,
        enableHaptic: true,
        child: ListTile(
          leading: leading,
          title: title,
          subtitle: subtitle,
          trailing: trailing,
          onTap: onTap,
          contentPadding: EdgeInsets.symmetric(
            horizontal: layout.spaceL,
            vertical: layout.spaceS,
          ),
        ),
      ),
    );
  }
}

/// Optimized list view with performance enhancements
class OptimizedListView extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final ScrollController? controller;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final String? cacheKey;

  const OptimizedListView({
    super.key,
    required this.children,
    this.padding,
    this.controller,
    this.shrinkWrap = false,
    this.physics,
    this.cacheKey,
  });

  @override
  Widget build(BuildContext context) {
    final layout = context.layout;
    
    return ListView.builder(
      controller: controller,
      padding: padding ?? layout.pageGutter,
      shrinkWrap: shrinkWrap,
      physics: physics,
      cacheExtent: context.vh * 1.5,
      itemCount: children.length,
      itemBuilder: (context, index) {
        return RepaintBoundary(
          key: cacheKey != null ? ValueKey('$cacheKey-$index') : null,
          child: children[index],
        );
      },
    );
  }
}

/// Optimized grid view with performance enhancements
class OptimizedGridView extends StatelessWidget {
  final List<Widget> children;
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final EdgeInsetsGeometry? padding;
  final ScrollController? controller;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final String? cacheKey;

  const OptimizedGridView({
    super.key,
    required this.children,
    required this.crossAxisCount,
    this.mainAxisSpacing = 8.0,
    this.crossAxisSpacing = 8.0,
    this.padding,
    this.controller,
    this.shrinkWrap = false,
    this.physics,
    this.cacheKey,
  });

  @override
  Widget build(BuildContext context) {
    final layout = context.layout;
    
    return GridView.builder(
      controller: controller,
      padding: padding ?? layout.pageGutter,
      shrinkWrap: shrinkWrap,
      physics: physics,
      cacheExtent: context.vh * 1.5,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
        childAspectRatio: 1.0,
      ),
      itemCount: children.length,
      itemBuilder: (context, index) {
        return RepaintBoundary(
          key: cacheKey != null ? ValueKey('$cacheKey-$index') : null,
          child: children[index],
        );
      },
    );
  }
}

// ============================================================================
// PERFORMANCE UTILITIES
// ============================================================================

/// Performance-optimized widget that prevents unnecessary rebuilds
class OptimizedWidget extends StatelessWidget {
  final Widget child;
  final String? cacheKey;

  const OptimizedWidget({
    super.key,
    required this.child,
    this.cacheKey,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: cacheKey != null ? ValueKey(cacheKey) : null,
      child: child,
    );
  }
}

/// Memoized widget that caches expensive computations
class MemoizedWidget extends StatefulWidget {
  final Widget Function() builder;
  final List<dynamic> dependencies;

  const MemoizedWidget({
    super.key,
    required this.builder,
    required this.dependencies,
  });

  @override
  State<MemoizedWidget> createState() => _MemoizedWidgetState();
}

class _MemoizedWidgetState extends State<MemoizedWidget> {
  Widget? _cachedWidget;
  List<dynamic>? _lastDependencies;

  @override
  Widget build(BuildContext context) {
    if (_lastDependencies == null || !_listsEqual(_lastDependencies!, widget.dependencies)) {
      _cachedWidget = widget.builder();
      _lastDependencies = List.from(widget.dependencies);
    }
    return _cachedWidget!;
  }

  bool _listsEqual(List<dynamic> a, List<dynamic> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

// ============================================================================
// SHARED INTERACTIVE WRAPPER (Single StatefulWidget)
// ============================================================================

/// Single StatefulWidget for all interactive behaviors
class _InteractiveWrapper extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final bool enableHaptic;
  final Duration animationDuration;

  const _InteractiveWrapper({
    required this.child,
    this.onTap,
    this.enableHaptic = true,
    this.animationDuration = const Duration(milliseconds: 150),
  });

  @override
  State<_InteractiveWrapper> createState() => _InteractiveWrapperState();
}

class _InteractiveWrapperState extends State<_InteractiveWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onTap != null) {
      setState(() => _isPressed = true);
      _controller.forward();
      if (widget.enableHaptic) {
        HapticFeedback.lightImpact();
      }
    }
  }

  void _handleTapUp(TapUpDetails details) {
    _handleTapEnd();
  }

  void _handleTapCancel() {
    _handleTapEnd();
  }

  void _handleTapEnd() {
    if (_isPressed) {
      setState(() => _isPressed = false);
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: _handleTapDown,
            onTapUp: _handleTapUp,
            onTapCancel: _handleTapCancel,
            onTap: widget.onTap,
            child: widget.child,
          ),
        );
      },
    );
  }
}

// ============================================================================
// ENHANCED LAYOUT COMPONENTS
// ============================================================================

/// Premium section card with consistent styling and animations
class SectionCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final bool enableHover;
  final Duration animationDuration;

  const SectionCard({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    required this.children,
    this.padding,
    this.enableHover = true,
    this.animationDuration = const Duration(milliseconds: 200),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final layout = context.layout;

    return RepaintBoundary(
      child: Card(
        elevation: 2,
        shadowColor: AppColors.shadow(context).withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(layout.radiusL),
        ),
        child: _InteractiveWrapper(
          enableHaptic: false,
          animationDuration: animationDuration,
          child: Container(
            padding: padding ?? layout.insetsAll(2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, theme, layout),
                const SizedBox(height: 8),
                ...children,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme, AppSize layout) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary(context),
                ),
              ),
              if (subtitle != null && subtitle!.trim().isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    subtitle!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary(context),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

/// Enhanced responsive grid with performance optimizations
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final int? crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final EdgeInsetsGeometry? padding;
  final ScrollController? controller;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final String? cacheKey;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.crossAxisCount,
    this.mainAxisSpacing = 8.0,
    this.crossAxisSpacing = 8.0,
    this.padding,
    this.controller,
    this.shrinkWrap = false,
    this.physics,
    this.cacheKey,
  });

  @override
  Widget build(BuildContext context) {
    final layout = context.layout;
    final device = context.device;
    
    // Calculate responsive cross axis count
    final responsiveCrossAxisCount = crossAxisCount ?? _getResponsiveCrossAxisCount(device, layout);
    
    return GridView.builder(
      controller: controller,
      padding: padding ?? layout.pageGutter,
      shrinkWrap: shrinkWrap,
      physics: physics,
      cacheExtent: context.vh * 1.5,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: responsiveCrossAxisCount,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
        childAspectRatio: _getChildAspectRatio(device),
      ),
      itemCount: children.length,
      itemBuilder: (context, index) {
        return RepaintBoundary(
          key: cacheKey != null ? ValueKey('$cacheKey-$index') : null,
          child: children[index],
        );
      },
    );
  }

  int _getResponsiveCrossAxisCount(DeviceSize device, AppSize layout) {
    switch (device) {
      case DeviceSize.phone:
        return 1;
      case DeviceSize.tablet:
        return 2;
      case DeviceSize.desktop:
        return 3;
    }
  }

  double _getChildAspectRatio(DeviceSize device) {
    switch (device) {
      case DeviceSize.phone:
        return 1.2;
      case DeviceSize.tablet:
        return 1.0;
      case DeviceSize.desktop:
        return 0.9;
    }
  }
}

/// Premium loading indicator with customizable animations
class AppLoadingIndicator extends StatelessWidget {
  final double size;
  final Color? color;
  final double strokeWidth;
  final String? message;
  final bool showMessage;
  final Duration animationDuration;

  const AppLoadingIndicator({
    super.key,
    this.size = 24.0,
    this.color,
    this.strokeWidth = 2.0,
    this.message,
    this.showMessage = false,
    this.animationDuration = const Duration(milliseconds: 1200),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final layout = context.layout;
    final indicatorColor = color ?? AppColors.primary(context);

    return RepaintBoundary(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              strokeWidth: strokeWidth,
              valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
            ),
          ),
          if (showMessage && message != null) ...[
            SizedBox(height: layout.spaceM),
            Text(
              message!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary(context),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

/// Enhanced empty state with customizable content
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? action;
  final Color? iconColor;
  final double iconSize;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.action,
    this.iconColor,
    this.iconSize = 64.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final layout = context.layout;
    final iconColorValue = iconColor ?? AppColors.textSecondary(context);

    return RepaintBoundary(
      child: Center(
        child: Padding(
          padding: layout.insetsAll(4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: iconSize,
                color: iconColorValue.withValues(alpha: 0.6),
              ),
              SizedBox(height: layout.spaceL),
              Text(
                title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary(context),
                ),
                textAlign: TextAlign.center,
              ),
              if (subtitle != null && subtitle!.trim().isNotEmpty) ...[
                SizedBox(height: layout.spaceS),
                Text(
                  subtitle!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary(context),
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              if (action != null) ...[
                SizedBox(height: layout.spaceXL),
                action!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// ENUMS
// ============================================================================

enum AppButtonStyle { primary, secondary, outline, text }
enum AppButtonSize { small, medium, large }
enum AppSnackbarType { success, error, warning, info }
