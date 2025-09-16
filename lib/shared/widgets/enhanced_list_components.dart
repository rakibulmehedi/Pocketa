import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pocketa/core/responsive/responsive.dart';
import 'package:pocketa/core/theme/text_styles.dart';
import 'package:pocketa/shared/widgets/unified_animations.dart';

/// Generic item builder function type
typedef ItemBuilder<T> = Widget Function(BuildContext context, T item, int index);

/// Generic empty state builder function type
typedef EmptyStateBuilder = Widget Function(BuildContext context);

/// Enhanced list view with performance optimizations and responsive design
class EnhancedListView<T> extends StatelessWidget {
  final List<T> items;
  final ItemBuilder<T> itemBuilder;
  final EdgeInsetsGeometry? padding;
  final ScrollController? controller;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final String? cacheKey;
  final bool separated;
  final Widget Function(BuildContext, int)? separatorBuilder;
  final Widget? prototypeItem;
  final EmptyStateBuilder? emptyStateBuilder;
  final bool useMasonryGrid;
  final int? masonryCrossAxisCount;
  final double? masonryMainAxisSpacing;
  final double? masonryCrossAxisSpacing;

  const EnhancedListView({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.padding,
    this.controller,
    this.shrinkWrap = false,
    this.physics,
    this.cacheKey,
    this.separated = false,
    this.separatorBuilder,
    this.prototypeItem,
    this.emptyStateBuilder,
    this.useMasonryGrid = false,
    this.masonryCrossAxisCount,
    this.masonryMainAxisSpacing,
    this.masonryCrossAxisSpacing,
  });

  @override
  Widget build(BuildContext context) {
    final layout = context.layout;
    
    if (items.isEmpty) {
      return emptyStateBuilder?.call(context) ?? _buildDefaultEmptyState(context, layout);
    }

    if (useMasonryGrid) {
      return _buildMasonryGrid(context, layout);
    }

    return ListView.separated(
      controller: controller,
      padding: padding ?? layout.pageGutter,
      shrinkWrap: shrinkWrap,
      physics: physics,
      itemCount: items.length,
      separatorBuilder: separated 
          ? (separatorBuilder ?? (context, index) => const Divider(height: 1))
          : (context, index) => const SizedBox.shrink(),
      itemBuilder: (context, index) {
        return RepaintBoundary(
          key: cacheKey != null ? ValueKey('$cacheKey-$index') : null,
          child: itemBuilder(context, items[index], index),
        );
      },
    );
  }

  Widget _buildMasonryGrid(BuildContext context, AppSize layout) {
    return MasonryGridView.count(
      controller: controller,
      padding: padding ?? layout.pageGutter,
      crossAxisCount: masonryCrossAxisCount ?? layout.responsiveSize(
        phone: 1,
        tablet: 2,
        desktop: 3,
      ).toInt(),
      mainAxisSpacing: masonryMainAxisSpacing ?? layout.spaceM,
      crossAxisSpacing: masonryCrossAxisSpacing ?? layout.spaceM,
      itemCount: items.length,
      itemBuilder: (context, index) {
        return RepaintBoundary(
          key: cacheKey != null ? ValueKey('$cacheKey-$index') : null,
          child: itemBuilder(context, items[index], index),
        );
      },
    );
  }

  Widget _buildDefaultEmptyState(BuildContext context, AppSize layout) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(layout.spaceXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: layout.responsiveSize(phone: 48, tablet: 64, desktop: 80),
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            SizedBox(height: layout.spaceL),
            Text(
              'No items found',
              style: AppTextStyles.responsiveTitle(context),
            ),
            SizedBox(height: layout.spaceS),
            Text(
              'Add some items to get started',
              style: AppTextStyles.responsiveBody(context),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Sliver variant for use within CustomScrollView
class EnhancedSliverList<T> extends StatelessWidget {
  final List<T> items;
  final ItemBuilder<T> itemBuilder;
  final bool separated;
  final Widget Function(BuildContext, int)? separatorBuilder;
  final Widget? prototypeItem;
  final EmptyStateBuilder? emptyStateBuilder;
  final bool useMasonryGrid;
  final int? masonryCrossAxisCount;
  final double? masonryMainAxisSpacing;
  final double? masonryCrossAxisSpacing;

  const EnhancedSliverList({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.separated = true,
    this.separatorBuilder,
    this.prototypeItem,
    this.emptyStateBuilder,
    this.useMasonryGrid = false,
    this.masonryCrossAxisCount,
    this.masonryMainAxisSpacing,
    this.masonryCrossAxisSpacing,
  });

  @override
  Widget build(BuildContext context) {
    final layout = context.layout;
    
    if (items.isEmpty) {
      return SliverToBoxAdapter(
        child: emptyStateBuilder?.call(context) ?? _buildDefaultEmptyState(context, layout),
      );
    }

    if (useMasonryGrid) {
      return _buildMasonrySliverGrid(context, layout);
    }

    final builder = itemBuilder;

    // Uniform-height optimization path when prototypeItem provided
    if (!separated && prototypeItem != null) {
      return SliverPrototypeExtentList(
        prototypeItem: prototypeItem!,
        delegate: SliverChildBuilderDelegate(
          (ctx, i) => RepaintBoundary(
            child: builder(ctx, items[i], i),
          ),
          childCount: items.length,
          addAutomaticKeepAlives: true,
          addRepaintBoundaries: true,
          addSemanticIndexes: true,
        ),
      );
    }

    if (separated) {
      return SliverList.separated(
        itemBuilder: (ctx, i) => RepaintBoundary(
          child: builder(ctx, items[i], i),
        ),
        separatorBuilder: separatorBuilder ?? (context, index) => SizedBox(height: layout.spaceS),
        itemCount: items.length,
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (ctx, i) => RepaintBoundary(
          child: builder(ctx, items[i], i),
        ),
        childCount: items.length,
        addAutomaticKeepAlives: true,
        addRepaintBoundaries: true,
        addSemanticIndexes: true,
      ),
    );
  }

  Widget _buildMasonrySliverGrid(BuildContext context, AppSize layout) {
    return SliverMasonryGrid.count(
      crossAxisCount: masonryCrossAxisCount ?? layout.responsiveSize(
        phone: 1,
        tablet: 2,
        desktop: 3,
      ).toInt(),
      mainAxisSpacing: masonryMainAxisSpacing ?? layout.spaceM,
      crossAxisSpacing: masonryCrossAxisSpacing ?? layout.spaceM,
      itemBuilder: (context, index) {
        return RepaintBoundary(
          child: itemBuilder(context, items[index], index),
        );
      },
      childCount: items.length,
    );
  }

  Widget _buildDefaultEmptyState(BuildContext context, AppSize layout) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(layout.spaceXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: layout.responsiveSize(phone: 48, tablet: 64, desktop: 80),
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            SizedBox(height: layout.spaceL),
            Text(
              'No items found',
              style: AppTextStyles.responsiveTitle(context),
            ),
            SizedBox(height: layout.spaceS),
            Text(
              'Add some items to get started',
              style: AppTextStyles.responsiveBody(context),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Generic tile component for list items
class GenericTile extends StatelessWidget {
  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? contentPadding;
  final bool dense;
  final bool enabled;
  final Color? tileColor;
  final Color? selectedTileColor;

  const GenericTile({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.contentPadding,
    this.dense = false,
    this.enabled = true,
    this.tileColor,
    this.selectedTileColor,
  });

  @override
  Widget build(BuildContext context) {
    final layout = context.layout;
    
    return ListTile(
      leading: leading,
      title: title,
      subtitle: subtitle,
      trailing: trailing,
      onTap: onTap,
      contentPadding: contentPadding ?? layout.insetsSymmetric(
        h: layout.spaceL,
        v: layout.spaceS,
      ),
      dense: dense,
      enabled: enabled,
      tileColor: tileColor,
      selectedTileColor: selectedTileColor,
    );
  }
}

/// Animated list tile with entrance animations
class AnimatedListTile<T> extends StatelessWidget {
  final T item;
  final int index;
  final ItemBuilder<T> itemBuilder;
  final Duration delay;
  final Duration duration;
  final Curve curve;

  const AnimatedListTile({
    super.key,
    required this.item,
    required this.index,
    required this.itemBuilder,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeOut,
  });

  @override
  Widget build(BuildContext context) {
    return UnifiedAnimations.fadeSlideIn(
      child: itemBuilder(context, item, index),
      duration: duration,
      curve: curve,
      delay: Duration(milliseconds: delay.inMilliseconds + (index * 50)),
    );
  }
}
