import 'package:flutter/material.dart';
import 'package:pocketa/core/theme/app_color_scheme.dart';
import 'package:pocketa/core/responsive/responsive.dart';

/// AppBackgroundScaffold - Single source of truth for app background
/// Features:
/// - Premium gradient background (light/dark mode)
/// - Central responsive padding for consistent layout
/// - Proper contrast for text readability
/// - No global blur overlays
/// - Consistent across all screens
class AppBackgroundScaffold extends StatelessWidget {
  final Widget body;
  final Widget? footer;
  final PreferredSizeWidget? appBar;
  final bool useGradient;
  final bool useCentralPadding;
  final EdgeInsets? customPadding;

  const AppBackgroundScaffold({
    super.key,
    required this.body,
    this.footer,
    this.appBar,
    this.useGradient = true,
    this.useCentralPadding = true,
    this.customPadding,
  });

  @override
  Widget build(BuildContext context) {
    final layout = context.layout;
    
    // Calculate central padding based on device type
    final centralPadding = customPadding ?? _getCentralPadding(layout);
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: appBar,
      body: useGradient 
        ? _GradientBackground(
            child: useCentralPadding 
              ? Padding(padding: centralPadding, child: body)
              : body
          ) 
        : useCentralPadding 
          ? Padding(padding: centralPadding, child: body)
          : body,
      bottomNavigationBar: footer,
    );
  }

  /// Get responsive central padding based on device type
  EdgeInsets _getCentralPadding(AppSize layout) {
    return EdgeInsets.symmetric(
      horizontal: layout.responsiveSize(
        phone: 16.0,
        tablet: 24.0,
        desktop: 32.0,
      ),
      vertical: layout.responsiveSize(
        phone: 8.0,
        tablet: 12.0,
        desktop: 16.0,
      ),
    );
  }
}

class _GradientBackground extends StatelessWidget {
  final Widget child;
  const _GradientBackground({required this.child});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: AppColorScheme.backgroundGradient(context),
      ),
      child: child,
    );
  }
}
