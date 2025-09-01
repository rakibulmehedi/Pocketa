import 'dart:ui';
import 'package:flutter/material.dart';

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

  /// Accent color for the thin gradient strip below the app bar
  final Color? accentColor;

  /// Show the thin gradient strip under the app bar
  final bool showAccentStrip;

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
    this.showAccentStrip = true,
    this.height = kToolbarHeight, // 56 by default
    this.bottom,
  });

  @override
  Size get preferredSize {
    final extra =
        (showAccentStrip ? 6.0 : 0.0) + (bottom?.preferredSize.height ?? 0.0);
    return Size.fromHeight(height + extra);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final muted = onSurface.withValues(alpha: 0.65);
    final accent = accentColor ?? theme.colorScheme.primary;

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
            fontWeight: FontWeight.w800,
            letterSpacing: -0.2,
          ),
        ),
        if (subtitle != null && subtitle!.trim().isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              subtitle!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: muted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );

    // Optional compact metric “pill” at the far right (before actions)
    final pill = (trailingPillText != null && trailingPillText!.isNotEmpty)
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
                    size: 16,
                    color: trailingPillColor ?? accent,
                  ),
                  const SizedBox(width: 6),
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
    final leadingIcon = showBack
        ? Icons.arrow_back_ios_new_rounded
        : Icons.menu_rounded;
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
                icon: Icon(leadingIcon, size: 22),
                tooltip: showBack ? 'Back' : 'Menu',
              ),
              title: titleColumn,
              actions: [
                if (pill != null) ...[
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: pill,
                  ),
                ],
                ...(actions ?? const []),
              ],
              bottom: bottom,
            ),
          ),
        ),

        // Accent gradient strip (thin)
        if (showAccentStrip)
          Container(
            height: 6,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  accent.withValues(alpha: 0.25),
                  accent.withValues(alpha: 0.10),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.35, 1.0],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
      ],
    );
  }
}
