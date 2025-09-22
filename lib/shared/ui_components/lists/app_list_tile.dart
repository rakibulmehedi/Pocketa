import 'package:flutter/material.dart';
import 'package:pocketa/core/responsive/responsive.dart';
import 'package:pocketa/shared/ui_components/performance/interactive_wrapper.dart';

/// Premium interactive list tile
class AppListTile extends StatelessWidget {
  final Widget? leading;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool enableHover;
  final Duration animationDuration;

  const AppListTile({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.enableHover = true,
    this.animationDuration = const Duration(milliseconds: 150),
  });

  @override
  Widget build(BuildContext context) {
    final layout = context.layout;

    return RepaintBoundary(
      child: InteractiveWrapper(
        onTap: onTap,
        enableHaptic: true,
        child: ListTile(
          leading: leading,
          title: title,
          subtitle: subtitle,
          trailing: trailing,
          onTap: onTap,
          contentPadding: EdgeInsets.symmetric(
            horizontal: layout.spaceL,
            vertical: layout.spaceS,
          ),
        ),
      ),
    );
  }
}
