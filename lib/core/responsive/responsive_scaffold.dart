import 'package:flutter/material.dart';
import 'responsive.dart';

/// AppBar + Body wrapper that adapts nav rail on wide screen if needed.
class ResponsiveScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? floatingActionButton;
  final Widget? bottomBar;
  final NavigationRailDestination Function(BuildContext)? navRailBuilder;
  final bool showRail;

  const ResponsiveScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.floatingActionButton,
    this.bottomBar,
    this.navRailBuilder,
    this.showRail = false,
  });

  @override
  Widget build(BuildContext context) {
    final isWide = context.sizeClass != DeviceSizeClass.phone && showRail;
    return Scaffold(
      appBar: appBar,
      body: Row(
        children: [
          if (isWide)
            NavigationRail(
              selectedIndex: 0,
              labelType: NavigationRailLabelType.all,
              destinations: [
                const NavigationRailDestination(
                  icon: Icon(Icons.list_alt_outlined),
                  label: Text('List'),
                ),
                const NavigationRailDestination(
                  icon: Icon(Icons.pie_chart_outline_rounded),
                  label: Text('Insights'),
                ),
              ],
            ),
          Expanded(child: body),
        ],
      ),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomBar,
    );
  }
}

/// Card-like section wrapper (shadow + border) — reuse everywhere.
class SectionCard extends StatelessWidget {
  final String? title;
  final List<Widget> children;
  final EdgeInsets padding;
  final EdgeInsets margin;

  const SectionCard({
    super.key,
    this.title,
    required this.children,
    this.padding = const EdgeInsets.all(12),
    this.margin = const EdgeInsets.symmetric(vertical: 8),
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveConstrained(
      child: Container(
        margin: margin,
        padding: padding,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(
            color: Theme.of(context).dividerColor.withOpacity(0.4),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null) ...[
              Text(title!, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              const Divider(height: 16),
            ],
            ...children,
          ],
        ),
      ),
    );
  }
}
