import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:pocketa/core/responsive/responsive.dart';
import 'package:pocketa/l10n/app_localizations.dart';
import 'package:pocketa/core/theme/app_colors.dart';
import 'package:pocketa/shared/widgets.dart';
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
    final onSurface = theme.colorScheme.onSurface;
    final muted = onSurface.withValues(alpha: 0.65);
    final accent = accentColor ?? AppColors.primary(context);

    return RepaintBoundary(
      child: SliverAppBar(
        pinned: pinned,
        floating: floating,
        snap: snap,
        expandedHeight: expandedHeight,
        collapsedHeight: collapsedHeight,
        elevation: 0,
        scrolledUnderElevation: 3,
        surfaceTintColor: theme.colorScheme.surfaceTint,
        centerTitle: false,
        titleSpacing: 8,
        leadingWidth: 56,
        leading: InteractiveWrapper(
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
        flexibleSpace: flexibleSpace ?? _buildFlexibleSpace(context, theme, layout, device, muted, accent),
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

  Widget _buildFlexibleSpace(BuildContext context, ThemeData theme, AppSize layout, DeviceSize device, Color muted, Color accent) {
    return FlexibleSpaceBar(
      title: Text(
        title,
        style: theme.textTheme.titleLarge?.copyWith(
          fontSize: _getResponsiveFontSize(device, layout),
          fontWeight: FontWeight.w800,
          letterSpacing: -0.2,
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
              accent.withValues(alpha: 0.1),
              accent.withValues(alpha: 0.05),
            ],
          ),
        ),
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
