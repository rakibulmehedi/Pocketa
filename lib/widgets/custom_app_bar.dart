import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final VoidCallback? onBackTap; // optional override
  final VoidCallback? onMenuTap; // optional menu
  final List<Widget>? actions; // trailing actions
  final double height;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBack = false,
    this.onBackTap,
    this.onMenuTap,
    this.actions,
    this.height = kToolbarHeight, // 56 by default
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 2,
      centerTitle: false,
      titleSpacing: 8,
      leadingWidth: 56,
      leading: IconButton(
        onPressed: showBack
            ? (onBackTap ?? () => context.go('/transactions'))
            : (onMenuTap ?? () {}),
        icon: Icon(
          showBack ? Icons.arrow_back_ios_new_rounded : Icons.menu_rounded,
          size: 22,
        ),
        tooltip: showBack ? 'Back' : 'Menu',
      ),
      title: Text(
        title,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: actions,
    );
  }
}
