import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:pocketa/core/responsive/responsive.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final Widget? footer; // typically FooterCtas
  final PreferredSizeWidget? appBar;
  const AppScaffold({super.key, required this.body, this.footer, this.appBar});

  @override
  Widget build(BuildContext context) {
    return _ScaffoldBody(appBar: appBar, body: body, footer: footer);
  }
}

class _ScaffoldBody extends StatelessWidget {
  final Widget body;
  final Widget? footer;
  final PreferredSizeWidget? appBar;
  const _ScaffoldBody({required this.body, this.footer, this.appBar});
  @override
  Widget build(BuildContext context) {
    final L = context.layout;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: appBar,
      body: Padding(padding: L.pageGutter, child: body),
      bottomNavigationBar: footer == null
          ? null
          : _FrostedFooter(child: footer!),
    );
  }
}


class _FrostedFooter extends StatelessWidget {
  final Widget child;
  const _FrostedFooter({required this.child});
  
  @override
  Widget build(BuildContext context) {
    final L = context.layout;
    final device = context.device;
    
    return SafeArea(
      top: false,
      bottom: true,
      child: Padding(
        padding: EdgeInsets.fromLTRB(L.gutter, 0, L.gutter, L.gutterBottom),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: device == DeviceSize.desktop ? 840 : 640,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(L.radiusXl),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.10),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.06),
                  ),
                ),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}