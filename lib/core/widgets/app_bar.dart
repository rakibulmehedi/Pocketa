// lib/core/widgets/app_app_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool centerTitle;
  final List<Widget>? actions;
  final bool showBackButton;

  const AppAppBar({
    Key? key,
    this.title = '',
    this.centerTitle = false,
    this.actions,
    this.showBackButton = true,
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
                onPressed: () => Navigator.of(context).pop(),
                color: Theme.of(context).iconTheme.color,
              )
              : null,
      title: Text(
        title!,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      centerTitle: centerTitle,
      elevation: 0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      actions: actions,
    );
  }
}
