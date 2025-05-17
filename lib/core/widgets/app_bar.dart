// lib/core/widgets/app_app_bar.dart
import 'package:flutter/material.dart';

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool centerTitle;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBack;

  const AppAppBar({
    Key? key,
    this.title = '',
    this.centerTitle = false,
    this.actions,
    this.showBackButton = true,
    this.onBack,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading:
          showBackButton
              ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new),
                onPressed: () {
                  if (onBack != null) {
                    onBack!();
                  } else {
                    Navigator.pop(context);
                  }
                },
                color: Theme.of(context).iconTheme.color,
              )
              : null,
      title: Text(title!, style: Theme.of(context).textTheme.titleMedium),
      centerTitle: centerTitle,
      elevation: 0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      actions: actions,
    );
  }
}
