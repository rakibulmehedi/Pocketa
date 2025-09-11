import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:pocketa/core/responsive/responsive.dart';
import 'package:pocketa/l10n/app_localizations.dart';

/// A modern, fintech-y app bar with:
/// - Smart back/menu handling
/// - Optional subtitle (small line under title)
/// - Optional trailing metric "pill" (e.g., balance/net)
/// - Subtle gradient accent strip under the app bar
/// - Gentle shadow on scroll (uses AppBar.scrolledUnderElevation)
/// - Clean spacing + typography tuned for finance apps
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  /// Optional subtitle under the title (smaller, muted)
  final String? subtitle;

  /// If true, shows a back chevron. Otherwise shows a menu icon (when onMenuTap is provided).
  final bool showBack;

  /// When tapping the back/menu. If null and [showBack] is true, it will try Navigator.maybePop().
  final VoidCallback? onBackTap;
  final VoidCallback? onMenuTap;

  /// Trailing actions (icons)
  final List<Widget>? actions;

  /// Optional “pill” at the far right: great for showing a contextual number
  /// like “৳ 12,450” or “+$342”.
  final String? trailingPillText;
  final IconData? trailingPillIcon;
  final Color? trailingPillColor;

  /// Accent color for the trailing pill
  final Color? accentColor;

  /// Optional custom height
  final double height;

  /// Optional bottom widget (e.g., TabBar). If provided, height should accommodate it.
  final PreferredSizeWidget? bottom;

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
    this.height = kToolbarHeight, // 56 by default
    this.bottom,
  });

  @override
  Size get preferredSize {
    return Size.fromHeight(height);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final muted = onSurface.withValues(alpha: 0.65);
    final accent = accentColor ?? theme.colorScheme.primary;
    final device = context.device;

    // Title + optional subtitle
    final titleColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleLarge?.copyWith(
            fontSize: device == DeviceSize.phone 
              ? 20.sp(context) 
              : device == DeviceSize.tablet 
                ? 24.sp(context) 
                : 28.sp(context),
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
                fontSize: device == DeviceSize.phone 
                  ? 12.sp(context) 
                  : device == DeviceSize.tablet 
                    ? 14.sp(context) 
                    : 16.sp(context),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );

    // Optional compact metric “pill” at the far right (before actions)
    final pill = (trailingPillText != null && trailingPillText!.isNotEmpty)
        ? Container(
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
          )
        : null;

    // Leading behavior
    final leadingIcon =
        showBack ? Icons.arrow_back_ios_new_rounded : Icons.menu_rounded;
    final leadingTap = showBack
        ? (onBackTap ?? () => Navigator.of(context).maybePop())
        : (onMenuTap ?? () {});

    // We wrap AppBar with a Column to render the accent strip and optional bottom
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Slight blur under status bar for a premium feel on translucent overlays
        ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 0.0,
              sigmaY: 0.0,
            ), // keep subtle/no blur; can increase if you like
            child: AppBar(
              elevation: 0,
              scrolledUnderElevation:
                  3, // gentle shadow when content scrolls beneath
              surfaceTintColor:
                  theme.colorScheme.surfaceTint, // Material 3 goodness
              centerTitle: false,
              titleSpacing: 8,
              leadingWidth: 56,
              leading: IconButton(
                onPressed: leadingTap,
                icon: Icon(leadingIcon, size: context.layout.iconM),
                tooltip: showBack
                    ? AppLocalizations.of(context).back
                    : AppLocalizations.of(context).menu,
              ),
              title: titleColumn,
              actions: [
                if (pill != null) ...[
                  Padding(
                    padding: EdgeInsets.only(right: 0.75.rem(context)),
                    child: pill,
                  ),
                ],
                ...(actions ?? const []),

                Column(
                  
                )
              ],
              bottom: bottom,
            ),
          ),
        ),
      ],
    );
  }
}
