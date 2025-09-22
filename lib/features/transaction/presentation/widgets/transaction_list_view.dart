import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flow/core/responsive/responsive.dart';
import 'package:flow/features/transaction/domain/entities/transaction_entity.dart';
import 'package:flow/features/transaction/presentation/widgets/transaction_tile.dart';

typedef TxItemBuilder = Widget Function(
    BuildContext context, TransactionEntity tx);

/// Shared default builder: isolates paint, keeps elevation semantic & consistent.
TxItemBuilder _defaultTxBuilder(BuildContext context) => (ctx, tx) {
      return RepaintBoundary(
        key: ValueKey(tx.id),
        child: TransactionTile(transaction: tx),
      );
    };

/// Reusable, efficient **ListView** variant.
/// - Builder-based
/// - Optional `itemExtent`/`prototypeItem` for smoother FPS on uniform rows
/// - Stable keys via default builder
/// - Responsive default padding
class TransactionListView extends StatelessWidget {
  final List<TransactionEntity> transactions;
  final EdgeInsetsGeometry? padding;
  final ScrollController? controller;
  final ScrollPhysics? physics;
  final bool shrinkWrap;

  /// If true → uses separators between items.
  final bool separated;
  final Widget Function(BuildContext, int)? separatorBuilder;

  /// Custom row builder; defaults to [_defaultTxBuilder].
  final TxItemBuilder? itemBuilder;

  /// Prefer `itemExtent` when rows are perfectly uniform.
  final double? itemExtent;

  /// Prefer `prototypeItem` when rows are *mostly* uniform (recommended).
  final Widget? prototypeItem;

  const TransactionListView({
    super.key,
    required this.transactions,
    this.padding,
    this.controller,
    this.physics,
    this.shrinkWrap = false,
    this.separated = true,
    this.separatorBuilder,
    this.itemBuilder,
    this.itemExtent,
    this.prototypeItem,
  });

  @override
  Widget build(BuildContext context) {
    final L = context.layout;
    final EdgeInsetsGeometry resolvedPadding = padding ??
        EdgeInsets.symmetric(horizontal: L.rem(1), vertical: L.spaceS);

    final builder = itemBuilder ?? _defaultTxBuilder(context);
    final sep = separatorBuilder ??
        (ctx, index) => const Divider(height: 0, thickness: 0.6);

    if (separated) {
      // Use ListView.separated for proper separator handling
      // to avoid overlapping issues with prototype items
      return ListView.separated(
        controller: controller,
        physics: physics,
        shrinkWrap: shrinkWrap,
        padding: resolvedPadding,
        itemCount: transactions.length,
        itemBuilder: (ctx, i) => builder(ctx, transactions[i]),
        separatorBuilder: sep,
      );
    }

    return ListView.builder(
      controller: controller,
      physics: physics,
      shrinkWrap: shrinkWrap,
      padding: resolvedPadding,
      itemCount: transactions.length,
      itemBuilder: (ctx, i) => builder(ctx, transactions[i]),
      itemExtent: itemExtent,
      // Normalize prototype item usage across list variants
      prototypeItem: prototypeItem ?? TransactionTile.prototype(),
    );
  }
}

/// Sliver variant for use within CustomScrollView.
class TransactionSliverList extends StatelessWidget {
  final List<TransactionEntity> transactions;

  /// If true → interleave separators (Divider) between rows.
  final bool separated;
  final Widget Function(BuildContext, int)? separatorBuilder;

  /// Custom row builder; defaults to [_defaultTxBuilder].
  final TxItemBuilder? itemBuilder;

  /// When `separated == false`, and rows are uniform, supply a prototype item
  /// to enable `SliverPrototypeExtentList` for buttery scrolling.
  final Widget? prototypeItem;

  const TransactionSliverList({
    super.key,
    required this.transactions,
    this.separated = true,
    this.separatorBuilder,
    this.itemBuilder,
    this.prototypeItem,
  });

  @override
  Widget build(BuildContext context) {
    final L = context.layout;
    final isWide = L.isTablet || L.isDesktop;
    
    // Use masonry grid for wide layouts, regular list for compact/mobile
    if (isWide && !separated) {
      return TransactionSliverMasonryGrid(
        transactions: transactions,
        itemBuilder: itemBuilder,
        prototypeItem: prototypeItem,
      );
    }

    final builder = itemBuilder ?? _defaultTxBuilder(context);

    if (transactions.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    // Uniform-height optimization path when prototypeItem provided.
    if (!separated && prototypeItem != null) {
      return SliverPrototypeExtentList(
        prototypeItem: prototypeItem!,
        delegate: SliverChildBuilderDelegate(
          (ctx, i) => builder(ctx, transactions[i]),
          childCount: transactions.length,
          addAutomaticKeepAlives: true,
          addRepaintBoundaries: true,
          addSemanticIndexes: true,
        ),
      );
    }

    if (separated) {
      // For separated lists, use SliverList with proper separator handling
      // to avoid overlapping issues with SliverPrototypeExtentList
      final sep = separatorBuilder ??
          (ctx, index) => const Divider(height: 0, thickness: 0.6);
      final childCount = (transactions.length * 2) - 1;

      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (ctx, index) {
            if (index.isOdd) return sep(ctx, index);
            final itemIndex = index ~/ 2;
            return builder(ctx, transactions[itemIndex]);
          },
          childCount: childCount,
          addAutomaticKeepAlives: true,
          addRepaintBoundaries: true,
          // Avoid custom semantic indexing to prevent a11y index mismatches.
          addSemanticIndexes: false,
        ),
      );
    }

    // Non-separated, non-uniform rows path
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (ctx, i) => builder(ctx, transactions[i]),
        childCount: transactions.length,
        addAutomaticKeepAlives: true,
        addRepaintBoundaries: true,
        addSemanticIndexes: true,
      ),
    );
  }
}

/// SliverMasonryGrid variant for wide layouts (tablet/desktop).
/// Provides better space utilization and visual hierarchy for larger screens.
class TransactionSliverMasonryGrid extends StatelessWidget {
  final List<TransactionEntity> transactions;
  final TxItemBuilder? itemBuilder;
  final Widget? prototypeItem;

  const TransactionSliverMasonryGrid({
    super.key,
    required this.transactions,
    this.itemBuilder,
    this.prototypeItem,
  });

  @override
  Widget build(BuildContext context) {
    final L = context.layout;
    final builder = itemBuilder ?? _defaultTxBuilder(context);

    if (transactions.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    // Calculate responsive column count based on screen width
    final screenWidth = context.vw;
    int crossAxisCount;
    if (L.isDesktop) {
      crossAxisCount = screenWidth > 1400 ? 4 : 3;
    } else {
      crossAxisCount = screenWidth > 1000 ? 3 : 2;
    }

    return SliverMasonryGrid.count(
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: L.spaceM,
      crossAxisSpacing: L.spaceM,
      childCount: transactions.length,
      itemBuilder: (ctx, i) => RepaintBoundary(
        key: ValueKey(transactions[i].id),
        child: builder(ctx, transactions[i]),
      ),
    );
  }
}
