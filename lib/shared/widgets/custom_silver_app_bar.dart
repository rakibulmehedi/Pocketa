// lib/shared/widgets/custom_sliver_app_bar.dart
import 'package:flutter/material.dart';
import 'package:pocketa/core/responsive/responsive.dart';
import 'package:pocketa/l10n/app_localizations.dart';

/// Responsive SliverAppBar:
/// - Adaptive toolbar height, icon sizes, paddings
/// - One-liner drop-in replacement for previous CustomSliverAppBar
class CustomSliverAppBar extends StatelessWidget {
  final String title;
  final bool showBack;
  final VoidCallback? onBackTap;
  final VoidCallback? onMenuTap;
  final List<Widget>? actions;
  final Widget? flexibleBackground;

  /// If [flexibleBackground] is provided, this height will be clamped responsively.
  final double expandedHeight;
  final bool pinned;
  final bool floating;

  const CustomSliverAppBar({
    super.key,
    required this.title,
    this.showBack = false,
    this.onBackTap,
    this.onMenuTap,
    this.actions,
    this.flexibleBackground,
    this.expandedHeight = 240,
    this.pinned = true,
    this.floating = false,
  });

  @override
  Widget build(BuildContext context) {
    final L = context.layout;
    final t = AppLocalizations.of(context);

    // Toolbar/icon sizing tuned per device class
    final toolbarHeight = L.isDesktop
        ? L.rem(9) // ~72
        : (L.isTablet ? L.rem(8) : L.rem(7)); // ~64 / ~56

    final iconSize = L.iconM; // central token
    final leadingDiameter = L.isDesktop
        ? L.rem(6)
        : (L.isTablet ? L.rem(5.5) : L.rem(5)); // ~48/44/40
    final horizontalPad = L.isDesktop
        ? L.rem(2.5)
        : (L.isTablet ? L.rem(2) : L.rem(1.5));

    // If flexible header provided, clamp to sane bounds for any screen size
    final double effectiveExpandedHeight = flexibleBackground == null
        ? toolbarHeight
        : expandedHeight.clamp(L.rem(22), L.rem(34)); // ~176–272

    return SliverAppBar(
      pinned: pinned,
      floating: floating,
      automaticallyImplyLeading: false,
      expandedHeight: effectiveExpandedHeight,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 3,
      elevation: 0,
      toolbarHeight: toolbarHeight,
      leadingWidth: leadingDiameter + horizontalPad * 2,
      leading: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPad),
        child: SizedBox(
          width: leadingDiameter,
          height: leadingDiameter,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.surface.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: showBack
                  ? (onBackTap ?? () => Navigator.of(context).maybePop())
                  : (onMenuTap ?? () {}),
              icon: Icon(
                showBack
                    ? Icons.arrow_back_ios_new_rounded
                    : Icons.menu_rounded,
                size: iconSize,
              ),
              tooltip: showBack ? t.back : t.menu, // keep i18n
            ),
          ),
        ),
      ),
      titleSpacing: 0,
      title: Padding(
        padding: EdgeInsets.only(left: L.rem(0.5)),
        child: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      actions: actions
          ?.map(
            (w) => Padding(
              padding: EdgeInsets.symmetric(horizontal: L.rem(0.5)),
              child: w,
            ),
          )
          .toList(growable: false),
      flexibleSpace: flexibleBackground == null
          ? null
          : FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: SizedBox.expand(
                // Ensure the background always fits the flexible region
                child: Padding(
                  padding: EdgeInsets.only(top: toolbarHeight),
                  child: flexibleBackground,
                ),
              ),
            ),
    );
  }
}
