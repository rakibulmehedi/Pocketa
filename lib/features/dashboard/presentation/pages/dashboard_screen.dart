import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/core/analytics/analytics_service.dart';
import 'package:pocketa/features/transaction/presentation/pages/pages.dart';
import 'package:pocketa/l10n/app_localizations.dart';

/// Global nav index state (survives across widgets)
final navIndexProvider = StateProvider<int>((ref) => 0);

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(navIndexProvider);

    // Destinations & Pages
    final l10n = AppLocalizations.of(context);
    final destinations = [
      NavigationDestination(
        icon: const Icon(Icons.home_outlined),
        label: l10n.dashboard,
      ),
      NavigationDestination(
        icon: const Icon(Icons.receipt_long_outlined),
        label: l10n.transactions,
      ),
      NavigationDestination(
        icon: const Icon(Icons.pie_chart_outline),
        label: l10n.budgets,
      ),
      NavigationDestination(
        icon: const Icon(Icons.account_balance_wallet_outlined),
        label: l10n.wallets,
      ),
    ];

    final pages = <Widget>[
      const _DashboardBody(),
      const TransactionListScreen(),
      Center(child: Text(l10n.budgets)),
      Center(child: Text(l10n.wallets)),
    ];

    if (index == 0) {
      ref.read(analyticsProvider).logEvent('dashboard_viewed');
    }

    return Scaffold(
      bottomNavigationBar: NavigationBar(
        destinations: destinations,
        selectedIndex: index,
        onDestinationSelected: (i) {
          ref.read(navIndexProvider.notifier).state = i;
        },
      ),
      body: IndexedStack(index: index, children: pages),
    );
  }
}

/// Split the dashboard content
class _DashboardBody extends ConsumerWidget {
  const _DashboardBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [Text(l10n.insights)],
    );
  }
}
