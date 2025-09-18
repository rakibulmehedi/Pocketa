import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pocketa/core/responsive/responsive.dart';
import 'package:pocketa/features/transaction/presentation/viewmodels/viewmodels.dart';
import 'package:pocketa/features/transaction/presentation/widgets/transaction_list_view.dart';
import 'package:pocketa/features/transaction/presentation/widgets/transaction_tile.dart';
import 'package:pocketa/l10n/app_localizations.dart';
import 'package:pocketa/shared/widgets.dart';

class TransactionListScreen extends ConsumerWidget {
  const TransactionListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // reactive list
    final txsAsync = ref.watch(allTransactionsProvider);
    final device = context.device;

    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: CustomScrollView(
        key: const PageStorageKey('tx_list_scroll'),
        // Use default cacheExtent to avoid over-building offscreen widgets.
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          CustomSliverAppBar(
            pinned: true,
            title: l10n.transactions,
            showBack: false,
            actions: [
              IconButton(
                tooltip: l10n.accessibilityAddTransaction,
                icon: Icon(
                  Icons.add,
                  size: device == DeviceSize.phone ? 24.ic(context) : 28.ic(context),
                ),
                onPressed: () => context.push('/add_edit_transaction'),
              ),
            ],
          ),

          // list body
          txsAsync.when(
            data: (transactions) => transactions.isEmpty
                ? const SliverFillRemaining(
                    hasScrollBody: false,
                    child: _EmptyState(),
                  )
                : TransactionSliverList(
                    transactions: transactions,
                    separated: true,
                    prototypeItem: const TransactionTile.prototype(),
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
