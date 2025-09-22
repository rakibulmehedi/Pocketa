import 'package:flutter/material.dart';
import 'package:flow/core/data/base_entity.dart';
import 'package:flow/core/responsive/responsive.dart';

/// Base list widget with common functionality
abstract class BaseListWidget<T extends BaseEntity> extends StatelessWidget {
  final List<T> items;
  final Widget Function(BuildContext context, T item, int index)? itemBuilder;
  final Widget Function(BuildContext context, int index)? separatorBuilder;
  final Widget? emptyWidget;
  final String? emptyMessage;
  final bool isLoading;
  final bool hasMore;
  final VoidCallback? onLoadMore;
  final EdgeInsetsGeometry? padding;
  final ScrollController? scrollController;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const BaseListWidget({
    super.key,
    required this.items,
    this.itemBuilder,
    this.separatorBuilder,
    this.emptyWidget,
    this.emptyMessage,
    this.isLoading = false,
    this.hasMore = false,
    this.onLoadMore,
    this.padding,
    this.scrollController,
    this.shrinkWrap = false,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading && items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (items.isEmpty) {
      return emptyWidget ?? _buildEmptyState(context);
    }

    return _buildList(context);
  }

  Widget _buildList(BuildContext context) {
    final layout = context.layout;
    
    if (layout.isTablet || layout.isDesktop) {
      return _buildGridList(context);
    } else {
      return _buildLinearList(context);
    }
  }

  Widget _buildLinearList(BuildContext context) {
    return ListView.separated(
      controller: scrollController,
      padding: padding ?? EdgeInsets.all(16.rem(context)),
      shrinkWrap: shrinkWrap,
      physics: physics,
      itemCount: items.length + (hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == items.length) {
          return _buildLoadMoreIndicator(context);
        }
        return itemBuilder?.call(context, items[index], index) ?? 
               _buildDefaultItem(context, items[index], index);
      },
      separatorBuilder: separatorBuilder ?? (context, index) => const SizedBox(height: 8),
    );
  }

  Widget _buildGridList(BuildContext context) {
    return GridView.builder(
      controller: scrollController,
      padding: padding ?? EdgeInsets.all(16.rem(context)),
      shrinkWrap: shrinkWrap,
      physics: physics,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: context.layout.isDesktop ? 3 : 2,
        crossAxisSpacing: 16.rem(context),
        mainAxisSpacing: 16.rem(context),
        childAspectRatio: 1.2,
      ),
      itemCount: items.length + (hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == items.length) {
          return _buildLoadMoreIndicator(context);
        }
        return itemBuilder?.call(context, items[index], index) ?? 
               _buildDefaultItem(context, items[index], index);
      },
    );
  }

  Widget _buildLoadMoreIndicator(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.rem(context)),
      child: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: onLoadMore,
                child: const Text('Load More'),
              ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 64.rem(context),
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
          ),
          SizedBox(height: 16.rem(context)),
          Text(
            emptyMessage ?? 'No items found',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  // Abstract method to be implemented by concrete list widgets
  Widget _buildDefaultItem(BuildContext context, T item, int index);
}

/// Base sliver list widget for CustomScrollView
abstract class BaseSliverListWidget<T extends BaseEntity> extends StatelessWidget {
  final List<T> items;
  final Widget Function(BuildContext context, T item, int index)? itemBuilder;
  final Widget Function(BuildContext context, int index)? separatorBuilder;
  final Widget? emptyWidget;
  final String? emptyMessage;
  final bool isLoading;
  final bool hasMore;
  final VoidCallback? onLoadMore;
  final EdgeInsetsGeometry? padding;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const BaseSliverListWidget({
    super.key,
    required this.items,
    this.itemBuilder,
    this.separatorBuilder,
    this.emptyWidget,
    this.emptyMessage,
    this.isLoading = false,
    this.hasMore = false,
    this.onLoadMore,
    this.padding,
    this.shrinkWrap = false,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading && items.isEmpty) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (items.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: emptyWidget ?? _buildEmptyState(context),
      );
    }

    return _buildSliverList(context);
  }

  Widget _buildSliverList(BuildContext context) {
    final layout = context.layout;
    
    if (layout.isTablet || layout.isDesktop) {
      return _buildSliverGrid(context);
    } else {
      return _buildSliverLinearList(context);
    }
  }

  Widget _buildSliverLinearList(BuildContext context) {
    return SliverList.separated(
      itemCount: items.length + (hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == items.length) {
          return _buildLoadMoreIndicator(context);
        }
        return itemBuilder?.call(context, items[index], index) ?? 
               _buildDefaultItem(context, items[index], index);
      },
      separatorBuilder: separatorBuilder ?? (context, index) => const SizedBox(height: 8),
    );
  }

  Widget _buildSliverGrid(BuildContext context) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: context.layout.isDesktop ? 3 : 2,
        crossAxisSpacing: 16.rem(context),
        mainAxisSpacing: 16.rem(context),
        childAspectRatio: 1.2,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index == items.length) {
            return _buildLoadMoreIndicator(context);
          }
          return itemBuilder?.call(context, items[index], index) ?? 
                 _buildDefaultItem(context, items[index], index);
        },
        childCount: items.length + (hasMore ? 1 : 0),
      ),
    );
  }

  Widget _buildLoadMoreIndicator(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.rem(context)),
      child: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: onLoadMore,
                child: const Text('Load More'),
              ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 64.rem(context),
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
          ),
          SizedBox(height: 16.rem(context)),
          Text(
            emptyMessage ?? 'No items found',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  // Abstract method to be implemented by concrete sliver list widgets
  Widget _buildDefaultItem(BuildContext context, T item, int index);
}
