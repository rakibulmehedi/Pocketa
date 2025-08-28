import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/features/transaction/screens/transaction_list_screen.dart';

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
      TransactionListScreen(),
      Center(child: Text('Budget')),
      Center(child: Text('Wallets')),
    ];

    return Scaffold(
      // drawer: const Drawer(child: SafeArea(child: Text('Drawer'))),
      // appBar: CustomAppBar(
      //   title: title,
      //   showBack: false,
      //   onMenuTap: () => Scaffold.of(context).openDrawer(),
      // ),
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
