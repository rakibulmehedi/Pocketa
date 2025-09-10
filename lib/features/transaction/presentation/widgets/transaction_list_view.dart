import 'package:flutter/material.dart';
import 'package:pocketa/core/responsive/responsive.dart';
import 'package:pocketa/features/transaction/domain/entities/transaction_entity.dart';
import 'package:pocketa/features/transaction/presentation/widgets/transaction_tile.dart';

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
      // When a prototype is provided, use ListView.builder so we can supply
      // `prototypeItem` and still render a separator inside each row. This
      // keeps rows uniform-height for smoother scroll.
      if (prototypeItem != null) {
        final proto = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            prototypeItem!,
            // Keep a consistent bottom divider for uniform height
            const Divider(height: 0, thickness: 0.6),
          ],
        );
        return ListView.builder(
          controller: controller,
          physics: physics,
          shrinkWrap: shrinkWrap,
          padding: resolvedPadding,
          itemCount: transactions.length,
          itemBuilder: (ctx, i) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              builder(ctx, transactions[i]),
              const Divider(height: 0, thickness: 0.6),
            ],
          ),
          prototypeItem: proto,
        );
      }

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
      // If a prototype is provided, render the separator as part of each row
      // and use SliverPrototypeExtentList for uniform row heights.
      if (prototypeItem != null) {
        final proto = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            prototypeItem!,
            const Divider(height: 0, thickness: 0.6),
          ],
        );
        return SliverPrototypeExtentList(
          prototypeItem: proto,
          delegate: SliverChildBuilderDelegate(
            (ctx, i) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                builder(ctx, transactions[i]),
                const Divider(height: 0, thickness: 0.6),
              ],
            ),
            childCount: transactions.length,
            addAutomaticKeepAlives: true,
            addRepaintBoundaries: true,
            addSemanticIndexes: false,
          ),
        );
      }
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
