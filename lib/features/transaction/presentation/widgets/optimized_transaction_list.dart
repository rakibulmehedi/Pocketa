import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/core/performance/performance_providers.dart';
import 'package:pocketa/features/transaction/domain/entities/transaction_entity.dart';
import 'package:pocketa/shared/widgets/ui_components.dart';

/// Performance-optimized transaction list with lazy loading and caching
class OptimizedTransactionList extends ConsumerStatefulWidget {
  final List<TransactionEntity> transactions;
  final VoidCallback? onLoadMore;
  final bool hasMore;
  final bool isLoading;
  final String? emptyMessage;
  final Widget? emptyWidget;

  const OptimizedTransactionList({
    super.key,
    required this.transactions,
    this.onLoadMore,
    this.hasMore = false,
    this.isLoading = false,
    this.emptyMessage,
    this.emptyWidget,
  });

  @override
  ConsumerState<OptimizedTransactionList> createState() => _OptimizedTransactionListState();
}

class _OptimizedTransactionListState extends ConsumerState<OptimizedTransactionList> {
  final ScrollController _scrollController = ScrollController();
  final Map<String, Widget> _cachedTiles = {};

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      widget.onLoadMore?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PerformanceMonitor(
      child: _buildList(),
    );
  }

  Widget _buildList() {
    if (widget.transactions.isEmpty) {
      return widget.emptyWidget ?? 
             EmptyState(
               icon: Icons.receipt_long_outlined,
               title: 'No transactions yet',
               subtitle: 'Start by adding your first transaction',
             );
    }

    return ListView.separated(
      controller: _scrollController,
      itemCount: widget.transactions.length + (widget.hasMore ? 1 : 0),
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        if (index >= widget.transactions.length) {
          return _buildLoadingIndicator();
        }

        return _buildTransactionTile(index);
      },
    );
  }

  Widget _buildTransactionTile(int index) {
    final transaction = widget.transactions[index];
    final cacheKey = 'transaction_${transaction.id}';

    // Check cache first
    if (_cachedTiles.containsKey(cacheKey)) {
      return _cachedTiles[cacheKey]!;
    }

    // Create and cache the tile
    final tile = OptimizedTransactionTile(
      transaction: transaction,
      onTap: () => _onTransactionTap(transaction),
    );

    _cachedTiles[cacheKey] = tile;
    return tile;
  }

  Widget _buildLoadingIndicator() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void _onTransactionTap(TransactionEntity transaction) {
    // Handle transaction tap
    // This could navigate to transaction details
  }
}

/// Performance-optimized transaction tile with memoization
class OptimizedTransactionTile extends StatelessWidget {
  final TransactionEntity transaction;
  final VoidCallback? onTap;

  const OptimizedTransactionTile({
    super.key,
    required this.transaction,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: OptimizedWidget(
        cacheKey: 'transaction_tile_${transaction.id}',
        child: _buildTile(context),
      ),
    );
  }

  Widget _buildTile(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: _buildTransactionIcon(),
        title: Text(
          transaction.note ?? 'Transaction',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(
          _formatDate(transaction.date),
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: Text(
          _formatAmount(transaction.amount),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: transaction.amount >= 0 ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildTransactionIcon() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: transaction.amount >= 0 ? Colors.green.shade100 : Colors.red.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        transaction.amount >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
        color: transaction.amount >= 0 ? Colors.green : Colors.red,
        size: 20,
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatAmount(double amount) {
    return '${amount >= 0 ? '+' : ''}${amount.toStringAsFixed(2)}';
  }
}

/// Performance-optimized transaction grid
class OptimizedTransactionGrid extends ConsumerStatefulWidget {
  final List<TransactionEntity> transactions;
  final int crossAxisCount;
  final double childAspectRatio;
  final VoidCallback? onLoadMore;
  final bool hasMore;

  const OptimizedTransactionGrid({
    super.key,
    required this.transactions,
    this.crossAxisCount = 2,
    this.childAspectRatio = 1.0,
    this.onLoadMore,
    this.hasMore = false,
  });

  @override
  ConsumerState<OptimizedTransactionGrid> createState() => _OptimizedTransactionGridState();
}

class _OptimizedTransactionGridState extends ConsumerState<OptimizedTransactionGrid> {
  final ScrollController _scrollController = ScrollController();
  final Map<String, Widget> _cachedCards = {};

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      widget.onLoadMore?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PerformanceMonitor(
      child: GridView.builder(
        controller: _scrollController,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: widget.crossAxisCount,
          childAspectRatio: widget.childAspectRatio,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: widget.transactions.length + (widget.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= widget.transactions.length) {
            return const Center(child: CircularProgressIndicator());
          }

          return _buildTransactionCard(index);
        },
      ),
    );
  }

  Widget _buildTransactionCard(int index) {
    final transaction = widget.transactions[index];
    final cacheKey = 'transaction_card_${transaction.id}';

    if (_cachedCards.containsKey(cacheKey)) {
      return _cachedCards[cacheKey]!;
    }

    final card = OptimizedWidget(
      cacheKey: cacheKey,
      child: _buildCard(transaction),
    );

    _cachedCards[cacheKey] = card;
    return card;
  }

  Widget _buildCard(TransactionEntity transaction) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              transaction.amount >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
              color: transaction.amount >= 0 ? Colors.green : Colors.red,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              _formatAmount(transaction.amount),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: transaction.amount >= 0 ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatDate(transaction.date),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatAmount(double amount) {
    return '${amount >= 0 ? '+' : ''}${amount.toStringAsFixed(2)}';
  }
}
