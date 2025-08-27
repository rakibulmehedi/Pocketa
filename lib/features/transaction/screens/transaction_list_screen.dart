import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pocketa/core/enums/transaction_enums.dart';
import 'package:pocketa/core/utils/transaction_utils.dart';
import 'package:pocketa/domain/entities/transaction_entity.dart';
import 'package:pocketa/features/transaction/providers/transaction_provider.dart';

import 'package:pocketa/core/responsive/responsive.dart';
import 'package:pocketa/core/responsive/responsive_scaffold.dart';

class TransactionListScreen extends ConsumerWidget {
  const TransactionListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final txsAsync = ref.watch(allTransactionsProvider);

    return ResponsiveScaffold(
      body: txsAsync.when(
        data: (transactions) {
          final income = transactions
              .where((t) => t.type == TransactionType.income)
              .fold<double>(0, (s, t) => s + t.amount);

          final expense = transactions
              .where((t) => t.type == TransactionType.expense)
              .fold<double>(0, (s, t) => s + t.amount);

          final net = income - expense;

          return ResponsiveConstrained(
            child: Column(
              children: [
                _MonthSummaryRow(income: income, expense: expense, net: net),
                const Divider(height: 0),
                Expanded(
                  child: transactions.isEmpty
                      ? const _EmptyState()
                      : ListView.separated(
                          padding: const EdgeInsets.only(top: 8, bottom: 88),
                          itemBuilder: (_, index) => _TransactionTile(
                            transaction: transactions[index],
                          ),
                          separatorBuilder: (_, __) => const Divider(height: 0),
                          itemCount: transactions.length,
                        ),
                ),
              ],
            ),
          );
        },
        error: (e, _) => Center(child: Text('Error: $e')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/add_edit_transaction'),
        icon: const Icon(Icons.add),
        label: const Text("Add"),
      ),
    );
  }
}

class _MonthSummaryRow extends StatelessWidget {
  final double income, expense, net;

  const _MonthSummaryRow({
    required this.income,
    required this.expense,
    required this.net,
  });

  @override
  Widget build(BuildContext context) {
    // phone/tablet/desktop spacing
    final isDesktop = context.sizeClass == DeviceSizeClass.desktop;
    final pillStyle = Theme.of(context).textTheme.titleMedium;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: isDesktop ? 16 : 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _pill('Income', income, Colors.green, pillStyle),
          _pill('Expense', expense, Colors.red, pillStyle),
          _pill('Net', net, net >= 0 ? Colors.green : Colors.red, pillStyle),
        ],
      ),
    );
  }

  Widget _pill(String label, double value, Color color, TextStyle? style) {
    return Column(
      children: [
        Text(label, style: style?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text(
          formatAmount(value, currency: '৳'),
          style: (style ?? const TextStyle()).copyWith(color: color),
        ),
      ],
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
      currency: '৳',
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

    final dense = context.sizeClass == DeviceSizeClass.phone;

    return ListTile(
      dense: dense,
      contentPadding: EdgeInsets.symmetric(
        horizontal: dense ? 8 : 12,
        vertical: dense ? 0 : 4,
      ),
      leading: CircleAvatar(
        backgroundColor: leadingColor.withOpacity(0.12),
        child: Icon(leadingIcon, color: leadingColor),
      ),
      title: Text(
        prettyCategory(transaction.category),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        transaction.note?.isNotEmpty == true
            ? '${transaction.note}  •  $date'
            : date,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        amountText,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: transaction.type == TransactionType.expense
              ? Colors.red
              : Colors.green,
        ),
      ),
      onTap: () {
        // TODO: details/edit
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
        padding: context.screenPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.receipt_long_outlined, size: 56),
            Gaps.s12,
            const Text('No transactions yet'),
            Gaps.s8,
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
