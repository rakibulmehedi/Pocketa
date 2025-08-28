import 'package:flutter/material.dart';
import 'package:pocketa/core/responsive/responsive.dart';

/// A safe, flexible responsive shell:
/// - Phone: BottomNavigationBar
/// - Tablet/Desktop: NavigationRail (collapsed or extended)
/// - Centers page content with maxWidth + padding
class ResponsiveScaffold extends StatelessWidget {
  // Common scaffold slots
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? floatingActionButton;
  final Color? backgroundColor;

  // Nav: shared model
  final List<NavigationDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  // Phone-only bottom bar override (if you want a custom one)
  final Widget? bottomBarOverride;

  // Rail controls
  final bool? forceRail; // null => auto by breakpoint
  final bool extendRailOnWide; // true => extended rail on desktop
  final double railWidth; // collapsed rail width
  final double
  extendedRailMinWidth; // min width to extend rail (usually >= 1024)
  final Widget? railLeading;
  final Widget? railTrailing;
  final bool useRailIndicator;

  // Content constraints
  final double maxContentWidth; // centers page content on very wide screens
  final EdgeInsetsGeometry? contentPadding;

  const ResponsiveScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.floatingActionButton,
    this.backgroundColor,
    // nav
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.bottomBarOverride,
    // rail
    this.forceRail,
    this.extendRailOnWide = true,
    this.railWidth = 72,
    this.extendedRailMinWidth = 1024,
    this.railLeading,
    this.railTrailing,
    this.useRailIndicator = true,
    // content
    this.maxContentWidth = 1100,
    this.contentPadding,
  });

  bool _shouldShowRail(BuildContext context) {
    if (forceRail != null) return forceRail!;
    return context.sizeClass != DeviceSizeClass.phone;
  }

  bool _shouldExtendRail(BuildContext context) {
    if (!extendRailOnWide) return false;
    return MediaQuery.of(context).size.width >= extendedRailMinWidth;
  }

  @override
  Widget build(BuildContext context) {
    final showRail = _shouldShowRail(context);
    final extendRail = showRail && _shouldExtendRail(context);

    // Build destinations for rail/bottom bar
    final railDestinations = destinations
        .map(
          (d) => NavigationRailDestination(
            icon: d.icon,
            selectedIcon: d.selectedIcon,
            label: Text(d.label),
          ),
        )
        .toList();

    final bottomItems = destinations
        .map(
          (d) => BottomNavigationBarItem(
            icon: d.icon,
            activeIcon: d.selectedIcon,
            label: d.label,
          ),
        )
        .toList();

    // Body: center on big screens and apply safe padding
    final paddedBody = SafeArea(
      top: false, // AppBar already handles top insets
      child: Padding(
        padding: contentPadding ?? _defaultContentPadding(context),
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxContentWidth),
            child: body,
          ),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBar,
      floatingActionButton: floatingActionButton,

      // PHONE  → bottom bar
      // TABLET/DESKTOP → rail + Expanded(body)
      bottomNavigationBar: showRail
          ? null
          : (bottomBarOverride ??
                NavigationBar(
                  selectedIndex: selectedIndex,
                  onDestinationSelected: onDestinationSelected,
                  destinations: destinations,
                  labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                )),

      body: Row(
        children: [
          if (showRail)
            _RailShell(
              width: railWidth,
              extended: extendRail,
              destinations: railDestinations,
              selectedIndex: selectedIndex,
              onSelect: onDestinationSelected,
              leading: railLeading,
              trailing: railTrailing,
              useIndicator: useRailIndicator,
            ),
          // **IMPORTANT** Expanded is inside Row (valid)
          Expanded(child: paddedBody),
        ],
      ),
    );
  }

  EdgeInsets _defaultContentPadding(BuildContext context) {
    // Mildly adaptive gutters
    switch (context.sizeClass) {
      case DeviceSizeClass.phone:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
      case DeviceSizeClass.tablet:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 12);
      case DeviceSizeClass.desktop:
        return const EdgeInsets.symmetric(horizontal: 32, vertical: 16);
    }
  }
}

/// A thin wrapper around NavigationRail with common defaults and no surprises.
class _RailShell extends StatelessWidget {
  final double width;
  final bool extended;
  final List<NavigationRailDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final Widget? leading;
  final Widget? trailing;
  final bool useIndicator;

  const _RailShell({
    required this.width,
    required this.extended,
    required this.destinations,
    required this.selectedIndex,
    required this.onSelect,
    this.leading,
    this.trailing,
    required this.useIndicator,
  });

  @override
  Widget build(BuildContext context) {
    // Keep rail visually consistent with M3 defaults
    return NavigationRail(
      minWidth: width,
      extended: extended,
      groupAlignment: -1, // push items toward top
      labelType: extended ? null : NavigationRailLabelType.all,
      useIndicator: useIndicator,
      leading: leading,
      trailing: trailing,
      selectedIndex: selectedIndex,
      onDestinationSelected: onSelect,
      destinations: destinations,
    );
  }
}
