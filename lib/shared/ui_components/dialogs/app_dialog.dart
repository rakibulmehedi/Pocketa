import 'package:flutter/material.dart';
import 'package:pocketa/core/responsive/responsive.dart';
import '../performance/interactive_wrapper.dart';

/// Premium interactive dialog component
class AppDialog extends StatelessWidget {
  final String? title;
  final Widget content;
  final List<Widget>? actions;
  final bool showCloseButton;
  final double? maxWidth;
  final EdgeInsetsGeometry? contentPadding;
  final bool enableHaptic;

  const AppDialog({
    super.key,
    this.title,
    required this.content,
    this.actions,
    this.showCloseButton = true,
    this.maxWidth,
    this.contentPadding,
    this.enableHaptic = true,
  });

  @override
  Widget build(BuildContext context) {
    final layout = context.layout;
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(layout.radiusL)),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? layout.responsiveSize(
            phone: double.infinity,
            tablet: 400,
            desktop: 500,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null || showCloseButton) _buildHeader(context, layout, theme),
            Padding(
              padding: contentPadding ?? layout.insetsAll(2),
              child: content,
            ),
            if (actions != null) _buildActions(context, layout, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppSize layout, ThemeData theme) {
    return Container(
      padding: layout.insetsAll(2),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(layout.radiusL),
          topRight: Radius.circular(layout.radiusL),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (title != null)
            Expanded(
              child: Text(
                title!,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          if (showCloseButton)
            RepaintBoundary(
              child: InteractiveWrapper(
                onTap: () => Navigator.of(context).pop(),
                enableHaptic: enableHaptic,
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.close, color: theme.colorScheme.onSurface),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context, AppSize layout, ThemeData theme) {
    return Container(
      padding: layout.insetsAll(2),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(layout.radiusL),
          bottomRight: Radius.circular(layout.radiusL),
        ),
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.end, children: actions!),
    );
  }
}
