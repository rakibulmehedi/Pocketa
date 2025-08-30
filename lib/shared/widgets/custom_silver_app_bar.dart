// Moved to shared/widgets
import 'package:flutter/material.dart';

class CustomSliverAppBar extends StatelessWidget {
  final String title;
  final bool showBack;
  final VoidCallback? onBackTap;
  final VoidCallback? onMenuTap;
  final List<Widget>? actions;
  final Widget? flexibleBackground;
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
    this.expandedHeight = 220,
    this.pinned = true,
    this.floating = false,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: pinned,
      floating: floating,
      automaticallyImplyLeading: false,
      expandedHeight: flexibleBackground == null
          ? kToolbarHeight
          : expandedHeight,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
      elevation: 0,
      leading: IconButton(
        onPressed: showBack
            ? (onBackTap ?? () => Navigator.of(context).maybePop())
            : (onMenuTap ?? () {}),
        icon: Icon(
          showBack ? Icons.arrow_back_ios_new_rounded : Icons.menu_rounded,
          size: 22,
        ),
        tooltip: showBack ? 'Back' : 'Menu',
      ),
      title: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
      ),
      actions: actions,
      flexibleSpace: flexibleBackground == null
          ? null
          : FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: flexibleBackground!,
            ),
    );
  }
}
