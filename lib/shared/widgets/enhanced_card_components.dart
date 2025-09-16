import 'package:flutter/material.dart';
import 'package:pocketa/core/responsive/responsive.dart';
import 'package:pocketa/core/theme/colors.dart';
import 'package:pocketa/core/theme/text_styles.dart';

/// Enhanced card components with consistent styling and responsive design
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final double? elevation;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;
  final bool showShadow;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.elevation,
    this.borderRadius,
    this.onTap,
    this.showShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    final layout = context.layout;
    final theme = Theme.of(context);

    return Container(
      margin: margin ?? layout.paddingM,
      child: Material(
        color: backgroundColor ?? theme.colorScheme.surface,
        elevation: elevation ?? (showShadow ? 2.0 : 0.0),
        borderRadius: borderRadius ?? layout.borderRadiusM,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius ?? layout.borderRadiusM,
          child: Padding(
            padding: padding ?? layout.paddingL,
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Section card with header and optional action
class SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? action;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool showDivider;

  const SectionCard({
    super.key,
    required this.title,
    required this.child,
    this.action,
    this.padding,
    this.margin,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final layout = context.layout;
    final theme = Theme.of(context);

    return AppCard(
      padding: padding ?? layout.paddingL,
      margin: margin ?? layout.paddingM,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppTextStyles.sectionTitle(context),
              ),
              if (action != null) action!,
            ],
          ),
          if (showDivider) ...[
            SizedBox(height: layout.spacingM),
            Divider(
              color: theme.colorScheme.outline.withOpacity(0.2),
              height: 1,
            ),
            SizedBox(height: layout.spacingM),
          ],
          child,
        ],
      ),
    );
  }
}

/// Info card with icon and description
class InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color? iconColor;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  const InfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.iconColor,
    this.backgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final layout = context.layout;
    final theme = Theme.of(context);

    return AppCard(
      onTap: onTap,
      backgroundColor: backgroundColor ?? theme.colorScheme.surfaceContainer,
      child: Row(
        children: [
          Container(
            padding: layout.paddingM,
            decoration: BoxDecoration(
              color: iconColor?.withOpacity(0.1) ?? 
                     theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: layout.borderRadiusM,
            ),
            child: Icon(
              icon,
              color: iconColor ?? theme.colorScheme.primary,
              size: layout.responsiveIconSize(phone: 24, tablet: 28, desktop: 32),
            ),
          ),
          SizedBox(width: layout.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.cardTitle(context),
                ),
                SizedBox(height: layout.spacingXS),
                Text(
                  description,
                  style: AppTextStyles.bodyMedium(context).copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Stat card for displaying metrics
class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String? subtitle;
  final IconData? icon;
  final Color? valueColor;
  final Color? iconColor;
  final VoidCallback? onTap;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    this.subtitle,
    this.icon,
    this.valueColor,
    this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final layout = context.layout;
    final theme = Theme.of(context);

    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: AppTextStyles.bodyMedium(context).copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              if (icon != null)
                Icon(
                  icon,
                  color: iconColor ?? theme.colorScheme.primary,
                  size: layout.responsiveIconSize(phone: 20, tablet: 24, desktop: 28),
                ),
            ],
          ),
          SizedBox(height: layout.spacingS),
          Text(
            value,
            style: AppTextStyles.headlineMedium(context).copyWith(
              color: valueColor ?? theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (subtitle != null) ...[
            SizedBox(height: layout.spacingXS),
            Text(
              subtitle!,
              style: AppTextStyles.bodySmall(context).copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Loading card with shimmer effect
class LoadingCard extends StatelessWidget {
  final double? height;
  final double? width;
  final BorderRadius? borderRadius;

  const LoadingCard({
    super.key,
    this.height,
    this.width,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final layout = context.layout;
    final theme = Theme.of(context);

    return Container(
      height: height ?? 120,
      width: width,
      margin: layout.paddingM,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: borderRadius ?? layout.borderRadiusM,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: CircularProgressIndicator(
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}
