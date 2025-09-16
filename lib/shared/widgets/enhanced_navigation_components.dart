import 'package:flutter/material.dart';
import 'package:pocketa/core/responsive/responsive.dart';
import 'package:pocketa/core/theme/text_styles.dart';
import 'package:pocketa/shared/widgets/unified_animations.dart';

/// Enhanced bottom navigation bar with responsive design
class EnhancedBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<NavigationDestination> destinations;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final double? elevation;
  final bool showLabels;

  const EnhancedBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.destinations,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.elevation,
    this.showLabels = true,
  });

  @override
  Widget build(BuildContext context) {
    final layout = context.layout;
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: onTap,
        destinations: destinations,
        backgroundColor: Colors.transparent,
        elevation: 0,
        height: layout.responsiveSize(phone: 60, tablet: 70, desktop: 80),
        labelBehavior: showLabels 
            ? NavigationDestinationLabelBehavior.alwaysShow
            : NavigationDestinationLabelBehavior.alwaysHide,
      ),
    );
  }
}

/// Enhanced app bar with consistent styling
class EnhancedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final bool centerTitle;
  final double? elevation;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? toolbarHeight;
  final PreferredSizeWidget? bottom;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const EnhancedAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.centerTitle = true,
    this.elevation,
    this.backgroundColor,
    this.foregroundColor,
    this.toolbarHeight,
    this.bottom,
    this.showBackButton = true,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    final layout = context.layout;
    final theme = Theme.of(context);

    return AppBar(
      title: titleWidget ?? (title != null ? Text(title!) : null),
      actions: actions,
      leading: leading ?? (showBackButton ? _buildBackButton(context) : null),
      automaticallyImplyLeading: automaticallyImplyLeading && showBackButton,
      centerTitle: centerTitle,
      elevation: elevation ?? 0,
      backgroundColor: backgroundColor ?? theme.colorScheme.surface,
      foregroundColor: foregroundColor ?? theme.colorScheme.onSurface,
      toolbarHeight: toolbarHeight ?? layout.responsiveSize(phone: 56, tablet: 64, desktop: 72),
      bottom: bottom,
      surfaceTintColor: Colors.transparent,
      shadowColor: theme.colorScheme.shadow.withValues(alpha: 0.1),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back_ios,
        size: context.layout.responsiveIconSize(phone: 20, tablet: 22, desktop: 24),
      ),
      onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight ?? 56);
}

/// Enhanced floating action button with responsive design
class EnhancedFloatingActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget? child;
  final IconData? icon;
  final String? tooltip;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final bool isLarge;
  final bool mini;

  const EnhancedFloatingActionButton({
    super.key,
    this.onPressed,
    this.child,
    this.icon,
    this.tooltip,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.isLarge = true,
    this.mini = false,
  });

  @override
  Widget build(BuildContext context) {
    final layout = context.layout;
    final theme = Theme.of(context);

    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: backgroundColor ?? theme.colorScheme.primary,
      foregroundColor: foregroundColor ?? theme.colorScheme.onPrimary,
      elevation: elevation ?? 6,
      tooltip: tooltip,
      child: child ?? (icon != null ? Icon(icon) : null),
    );
  }
}

/// Enhanced navigation drawer with consistent styling
class EnhancedNavigationDrawer extends StatelessWidget {
  final List<NavigationDrawerItem> items;
  final Widget? header;
  final Widget? footer;
  final int? selectedIndex;
  final ValueChanged<int>? onItemSelected;
  final Color? backgroundColor;
  final double? elevation;

  const EnhancedNavigationDrawer({
    super.key,
    required this.items,
    this.header,
    this.footer,
    this.selectedIndex,
    this.onItemSelected,
    this.backgroundColor,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    final layout = context.layout;
    final theme = Theme.of(context);

    return Drawer(
      backgroundColor: backgroundColor ?? theme.colorScheme.surface,
      elevation: elevation ?? 16,
      child: Column(
        children: [
          if (header != null) ...[
            header!,
            const Divider(height: 1),
          ],
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final isSelected = selectedIndex == index;
                
                return ListTile(
                  leading: item.icon,
                  title: Text(
                    item.title,
                    style: AppTextStyles.responsiveBody(context).copyWith(
                      color: isSelected 
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  subtitle: item.subtitle != null 
                      ? Text(
                          item.subtitle!,
                          style: AppTextStyles.responsiveCaption(context),
                        )
                      : null,
                  selected: isSelected,
                  selectedTileColor: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                  onTap: () {
                    Navigator.of(context).pop();
                    onItemSelected?.call(index);
                  },
                );
              },
            ),
          ),
          if (footer != null) ...[
            const Divider(height: 1),
            footer!,
          ],
        ],
      ),
    );
  }
}

/// Navigation drawer item model
class NavigationDrawerItem {
  final Widget? icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  const NavigationDrawerItem({
    this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
  });
}

/// Enhanced tab bar with consistent styling
class EnhancedTabBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Tab> tabs;
  final TabController? controller;
  final bool isScrollable;
  final TabAlignment tabAlignment;
  final Color? labelColor;
  final Color? unselectedLabelColor;
  final TextStyle? labelStyle;
  final TextStyle? unselectedLabelStyle;
  final Color? indicatorColor;
  final double? indicatorWeight;
  final EdgeInsetsGeometry? indicatorPadding;
  final Decoration? indicator;
  final TabBarIndicatorSize? indicatorSize;
  final ValueChanged<int>? onTap;

  const EnhancedTabBar({
    super.key,
    required this.tabs,
    this.controller,
    this.isScrollable = false,
    this.tabAlignment = TabAlignment.start,
    this.labelColor,
    this.unselectedLabelColor,
    this.labelStyle,
    this.unselectedLabelStyle,
    this.indicatorColor,
    this.indicatorWeight,
    this.indicatorPadding,
    this.indicator,
    this.indicatorSize,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final layout = context.layout;
    final theme = Theme.of(context);

    return TabBar(
      tabs: tabs,
      controller: controller,
      isScrollable: isScrollable,
      tabAlignment: tabAlignment,
      labelColor: labelColor ?? theme.colorScheme.primary,
      unselectedLabelColor: unselectedLabelColor ?? theme.colorScheme.onSurfaceVariant,
      labelStyle: labelStyle ?? AppTextStyles.responsiveLabel(context),
      unselectedLabelStyle: unselectedLabelStyle ?? AppTextStyles.responsiveLabel(context),
      indicatorColor: indicatorColor ?? theme.colorScheme.primary,
      indicatorWeight: indicatorWeight ?? 2,
      indicatorPadding: indicatorPadding ?? EdgeInsets.symmetric(horizontal: layout.spaceM),
      indicator: indicator,
      indicatorSize: indicatorSize ?? TabBarIndicatorSize.tab,
      onTap: onTap,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(48);
}

/// Enhanced page view with smooth transitions
class EnhancedPageView extends StatefulWidget {
  final List<Widget> children;
  final PageController? controller;
  final ValueChanged<int>? onPageChanged;
  final bool allowImplicitScrolling;
  final ScrollPhysics? physics;

  const EnhancedPageView({
    super.key,
    required this.children,
    this.controller,
    this.onPageChanged,
    this.allowImplicitScrolling = false,
    this.physics,
  });

  @override
  State<EnhancedPageView> createState() => _EnhancedPageViewState();
}

class _EnhancedPageViewState extends State<EnhancedPageView> {
  late PageController _controller;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? PageController();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _controller,
      onPageChanged: (index) {
        setState(() {
          _currentPage = index;
        });
        widget.onPageChanged?.call(index);
      },
      allowImplicitScrolling: widget.allowImplicitScrolling,
      physics: widget.physics,
      itemCount: widget.children.length,
      itemBuilder: (context, index) {
        return UnifiedAnimations.fadeSlideIn(
          child: widget.children[index],
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      },
    );
  }
}
