// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pocketa/core/responsive/responsive.dart';
import 'package:pocketa/features/transaction/presentation/viewmodels/month_args.dart';
import 'package:pocketa/features/transaction/presentation/viewmodels/transaction_computed_providers.dart';
import 'package:pocketa/features/transaction/presentation/viewmodels/viewmodels.dart';
import 'package:pocketa/features/transaction/presentation/widgets/transaction_tile.dart';
import 'package:pocketa/l10n/app_localizations.dart';
import 'package:pocketa/shared/widgets/widgets.dart';

class TransactionListScreen extends ConsumerWidget {
  const TransactionListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now().toUtc();

    // reactive list
    final txsAsync = ref.watch(allTransactionsProvider);

    final args = MonthArgs(y: now.year, m: now.month);
    // month summaries
    final income = ref.watch(monthIncomeRxProvider(args));
    final expense = ref.watch(monthExpenseRxProvider(args));
    final net = ref.watch(monthNetRxProvider(args));

    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          CustomSliverAppBar(
            pinned: true,
            title: l10n.transactions,
            showBack: false,
            actions: [
              IconButton(
                tooltip: l10n.accessibilityAddTransaction,
                icon: const Icon(Icons.add),
                onPressed: () => context.push('/add_edit_transaction'),
              ),
            ],
            // Adaptive expandedHeight for summary header
            // Use viewport-relative height with sane clamp to avoid
            // oversizing on desktop and tiny phones.
            expandedHeight: (0.22.h(context)).clamp(240.0, 280.0),
            flexibleBackground: SummaryRow(
              income: income,
              expense: expense,
              net: net,
            ),
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
                      return TransactionTile(
                        transaction: transactions[itemIndex],
                      );
                    }, childCount: transactions.length * 2 - 1),
                  ),
            error: (e, _) => SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: Text(l10n.errorGeneric)),
            ),
            loading: () => SliverFillRemaining(
              hasScrollBody: false,
              child: const Center(child: CircularProgressIndicator()),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 5.rem(context))),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.pushNamed('add_edit_tx'),
        icon: const Icon(Icons.add),
        label: Text(l10n.addTransaction),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.layout.space2xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long_outlined, size: 56.ic(context)),
            SizedBox(height: context.layout.spaceM),
            Text(l10n.noTransactions),
            SizedBox(height: context.layout.spaceS),
            Text(
              l10n.emptyTransactions,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
