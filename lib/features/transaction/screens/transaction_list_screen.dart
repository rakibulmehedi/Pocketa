import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:pocketa/core/enums/transaction_enums.dart';
import 'package:pocketa/core/utils/transaction_utils.dart';
import 'package:pocketa/application/transaction/providers/transaction_provider.dart';
import 'package:pocketa/domain/entities/transaction_entity.dart';
import 'package:pocketa/widgets/custom_silver_app_bar.dart';
import 'package:pocketa/widgets/summary_header.dart';

class TransactionListScreen extends ConsumerWidget {
  const TransactionListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now().toUtc();

    // reactive list
    final txsAsync = ref.watch(allTransactionsProvider);

    // month summaries
    final income = ref.watch(
      monthIncomeProvider((y: now.year, m: now.month, walletId: null)),
    );
    final expense = ref.watch(
      monthExpenseProvider((y: now.year, m: now.month, walletId: null)),
    );
    final net = ref.watch(
      monthNetProvider((y: now.year, m: now.month, walletId: null)),
    );

    return Scaffold(
      body: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          CustomSliverAppBar(
            pinned: true,
            title: 'Transactions',
            showBack: false,
            actions: [
              IconButton(
                tooltip: 'Add',
                icon: const Icon(Icons.add),
                onPressed: () => context.go('/add_edit_transaction'),
              ),
            ],
            expandedHeight: 240, // give breathing room
            flexibleBackground: SummaryHeader(income: income, expense: expense, net: net),
          ),

          // list body
          txsAsync.when(
            data: (transactions) => transactions.isEmpty
                ? const SliverFillRemaining(
                    hasScrollBody: false,
                    child: _EmptyState(),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      // interleave Divider between tiles
                      final isDivider = index.isOdd;
                      if (isDivider) return const Divider(height: 0);
                      final itemIndex = index ~/ 2;
                      return _TransactionTile(
                        transaction: transactions[itemIndex],
                      );
                    }, childCount: transactions.length * 2 - 1),
                  ),
            error: (e, _) => SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: Text('Error: $e')),
            ),
            loading: () => const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/add_edit_transaction'),
        icon: const Icon(Icons.add),
        label: const Text('Add'),
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final TransactionEntity transaction;
  const _TransactionTile({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final date = DateFormat(
      'EEE, dd MMM yyyy • hh:mm a',
    ).format(transaction.date.toLocal());
    final amountText = formatAmount(
      transaction.type == TransactionType.expense
          ? -transaction.amount
          : transaction.amount,
    );

    IconData leadingIcon;
    Color leadingColor;
    switch (transaction.type) {
      case TransactionType.income:
        leadingIcon = Icons.arrow_downward_rounded;
        leadingColor = Colors.green;
        break;
      case TransactionType.expense:
        leadingIcon = Icons.arrow_upward_rounded;
        leadingColor = Colors.red;
        break;
      case TransactionType.transfer:
        leadingIcon = Icons.swap_horiz_rounded;
        leadingColor = Colors.blueGrey;
        break;
    }

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: leadingColor.withOpacity(0.12),
        child: Icon(leadingIcon, color: leadingColor),
      ),
      title: Text(prettyCategory(transaction.category), style: Theme.of(context).textTheme.bodyLarge,),
      subtitle: Text(
        transaction.note?.isNotEmpty == true
            ? '${transaction.note}  •  $date'
            : date,
      ),
      trailing: Text(
        amountText,
        style: Theme.of(context).textTheme.titleSmall!.copyWith(
          color: transaction.type == TransactionType.expense
              ? Colors.red
              : Colors.green,
        )
      ),
      onTap: () {
        // TODO: push detail/edit with selected tx
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.receipt_long_outlined, size: 56),
            const SizedBox(height: 12),
            const Text('No transactions yet'),
            const SizedBox(height: 8),
            Text(
              'Tap the + button to add your first transaction.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
