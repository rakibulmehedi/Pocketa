import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/features/transaction/presentation/screens/transaction_screen.dart';
import 'package:pocketa/widgets/app_header.dart';

/// Global nav index state (survives across widgets)
final navIndexProvider = StateProvider<int>((ref) => 0);

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(navIndexProvider);

    // Destinations & Pages
    const destinations = [
      NavigationDestination(
        icon: Icon(Icons.home_outlined),
        label: 'Dashboard',
      ),
      NavigationDestination(
        icon: Icon(Icons.receipt_long_outlined),
        label: 'Transactions',
      ),
      NavigationDestination(
        icon: Icon(Icons.pie_chart_outline),
        label: 'Budget',
      ),
      NavigationDestination(
        icon: Icon(Icons.account_balance_wallet_outlined),
        label: 'Wallets',
      ),
    ];

    final pages = const <Widget>[
      _DashboardBody(),
      TransactionScreen(),
      Center(child: Text('Budget')),
      Center(child: Text('Wallets')),
    ];

    // Dynamic title based on index
    final String title = switch (index) {
      0 => 'Dashboard',
      1 => 'Transactions',
      2 => 'Budget',
      3 => 'Wallets',
      _ => 'Pocketa',
    };

    return Scaffold(
      drawer: const Drawer(child: SafeArea(child: Text('Drawer'))),

      bottomNavigationBar: NavigationBar(
        destinations: destinations,
        selectedIndex: index,
        onDestinationSelected: (i) {
          ref.read(navIndexProvider.notifier).state = i;
        },
      ),
      body: SafeArea(
        child: Builder(
          builder: (scaffoldCtx) => Column(
            children: [
              AppHeader(
                title: title,
                showBack: false,
                onMenuTap: () => Scaffold.of(scaffoldCtx).openDrawer(),
              ),
              const SizedBox(height: 8),
              // Body
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: IndexedStack(index: index, children: pages),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Split the dashboard content
class _DashboardBody extends StatelessWidget {
  const _DashboardBody();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [Text('Coming soon: overview cards & insights')],
    );
  }
}
