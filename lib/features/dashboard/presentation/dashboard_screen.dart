import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Global nav index state (survives across widgets)
final navIndexProvider = StateProvider<int>((ref) => 0);

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1) Read current index from Riverpod
    final index = ref.watch(navIndexProvider);

    // 2) Destinations (icons + labels)
    final destinations = const [
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
      // You can add Profile later if you want
    ];

    // 3) Pages for each destination (keep them lightweight for now)
    final pages = <Widget>[
      const _DashboardBody(),
      const Center(child: Text('Transactions')),
      const Center(child: Text('Budget')),
      const Center(child: Text('Wallets')),
    ];

    return Scaffold(
      // 4) NavigationBar (Material 3). Theme comes from AppTheme.
      bottomNavigationBar: NavigationBar(
        destinations: destinations,
        selectedIndex: index,
        onDestinationSelected: (int i) {
          ref.read(navIndexProvider.notifier).state = i;
        },
      ),

      // 5) Persist page state across tabs with IndexedStack
      body: IndexedStack(index: index, children: pages),
    );
  }
}

/// Split the dashboard header into its own widget (clean & testable)
class _DashboardBody extends StatelessWidget {
  const _DashboardBody();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Header(),
            const SizedBox(height: 16),
            const Text('Coming soon: overview cards & insights'),
          ],
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Dashboard',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
        ),
        const Spacer(),
        const CircleAvatar(
          radius: 18,
          foregroundImage: NetworkImage(
            'https://avatars.githubusercontent.com/u/125388734?v=4',
          ),
        ),
      ],
    );
  }
}
