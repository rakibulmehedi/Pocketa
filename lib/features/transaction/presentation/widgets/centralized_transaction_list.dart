import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flow/core/core.dart';
import 'package:flow/features/transaction/domain/entities/transaction_entity.dart';
import 'package:flow/features/transaction/presentation/widgets/transaction_tile.dart';

/// Centralized transaction list widget using BaseListWidget
class CentralizedTransactionListView extends BaseListWidget<TransactionEntity> {
  const CentralizedTransactionListView({
    super.key,
    required super.items,
    super.itemBuilder,
    super.separatorBuilder,
    super.emptyWidget,
    super.emptyMessage,
    super.isLoading,
    super.hasMore,
    super.onLoadMore,
    super.padding,
    super.scrollController,
    super.shrinkWrap,
    super.physics,
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
    final isWide = layout.isTablet || layout.isDesktop;

    if (isWide) {
      return _buildMasonryGrid(context);
    }

    if (separatorBuilder != null) {
      return ListView.separated(
        padding: padding ?? EdgeInsets.symmetric(horizontal: layout.rem(1), vertical: layout.spaceS),
        controller: scrollController,
        physics: physics,
        shrinkWrap: shrinkWrap,
        itemCount: items.length,
        itemBuilder: (ctx, i) => (itemBuilder ?? _defaultItemBuilder)(ctx, items[i], i),
        separatorBuilder: separatorBuilder!,
      );
    }

    return ListView.builder(
      padding: padding ?? EdgeInsets.symmetric(horizontal: layout.rem(1), vertical: layout.spaceS),
      controller: scrollController,
      physics: physics,
      shrinkWrap: shrinkWrap,
      itemCount: items.length,
      itemBuilder: (ctx, i) => (itemBuilder ?? _defaultItemBuilder)(ctx, items[i], i),
    );
  }

  Widget _buildMasonryGrid(BuildContext context) {
    final layout = context.layout;
    final screenWidth = context.vw;
    int crossAxisCount;
    if (layout.isDesktop) {
      crossAxisCount = screenWidth > 1400 ? 4 : 3;
    } else {
      crossAxisCount = screenWidth > 1000 ? 3 : 2;
    }

    return MasonryGridView.count(
      padding: padding ?? EdgeInsets.symmetric(horizontal: layout.rem(1), vertical: layout.spaceS),
      controller: scrollController,
      physics: physics,
      shrinkWrap: shrinkWrap,
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: layout.spaceM,
      crossAxisSpacing: layout.spaceM,
      itemCount: items.length,
      itemBuilder: (ctx, i) => (itemBuilder ?? _defaultItemBuilder)(ctx, items[i], i),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            emptyMessage ?? 'No transactions found',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }

  Widget _defaultItemBuilder(BuildContext context, TransactionEntity item, int index) {
    return RepaintBoundary(
      key: ValueKey(item.id),
      child: TransactionTile(transaction: item),
    );
  }
}

/// Centralized transaction sliver list widget using BaseSliverListWidget
class CentralizedTransactionSliverList extends BaseSliverListWidget<TransactionEntity> {
  const CentralizedTransactionSliverList({
    super.key,
    required super.items,
    super.itemBuilder,
    super.separatorBuilder,
    super.emptyWidget,
    super.emptyMessage,
    super.isLoading,
    super.hasMore,
    super.onLoadMore,
    super.padding,
    super.shrinkWrap,
    super.physics,
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
    final isWide = layout.isTablet || layout.isDesktop;

    if (isWide) {
      return _buildSliverMasonryGrid(context);
    }

    if (separatorBuilder != null) {
      final childCount = (items.length * 2) - 1;
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (ctx, index) {
            if (index.isOdd) return separatorBuilder!(ctx, index);
            final itemIndex = index ~/ 2;
            return (itemBuilder ?? _defaultItemBuilder)(ctx, items[itemIndex], itemIndex);
          },
          childCount: childCount,
          addAutomaticKeepAlives: true,
          addRepaintBoundaries: true,
          addSemanticIndexes: false,
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (ctx, i) => (itemBuilder ?? _defaultItemBuilder)(ctx, items[i], i),
        childCount: items.length,
        addAutomaticKeepAlives: true,
        addRepaintBoundaries: true,
        addSemanticIndexes: true,
      ),
    );
  }

  Widget _buildSliverMasonryGrid(BuildContext context) {
    final layout = context.layout;
    final screenWidth = context.vw;
    int crossAxisCount;
    if (layout.isDesktop) {
      crossAxisCount = screenWidth > 1400 ? 4 : 3;
    } else {
      crossAxisCount = screenWidth > 1000 ? 3 : 2;
    }

    return SliverMasonryGrid.count(
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: layout.spaceM,
      crossAxisSpacing: layout.spaceM,
      childCount: items.length,
      itemBuilder: (ctx, i) => RepaintBoundary(
        key: ValueKey(items[i].id),
        child: (itemBuilder ?? _defaultItemBuilder)(ctx, items[i], i),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            emptyMessage ?? 'No transactions found',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }

  Widget _defaultItemBuilder(BuildContext context, TransactionEntity item, int index) {
    return RepaintBoundary(
      key: ValueKey(item.id),
      child: TransactionTile(transaction: item),
    );
  }
}