import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/core/analytics/analytics_service.dart';
import 'package:pocketa/core/responsive/responsive.dart';
import 'package:pocketa/features/transaction/presentation/pages/pages.dart';
import 'package:pocketa/l10n/app_localizations.dart';

/// Global nav index state (survives across widgets)
final navIndexProvider = StateProvider<int>((ref) => 0);

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(navIndexProvider);
    final layout = context.layout;

    // Destinations & Pages
    final l10n = AppLocalizations.of(context);
    final iconSize = layout.responsiveIconSize(
      phone: 24,
      tablet: 28,
      desktop: 32,
    );
    
    final destinations = [
      NavigationDestination(
        icon: Icon(
          Icons.home_outlined,
          size: iconSize,
        ),
        label: l10n.dashboard,
      ),
      NavigationDestination(
        icon: Icon(
          Icons.receipt_long_outlined,
          size: iconSize,
        ),
        label: l10n.transactions,
      ),
      NavigationDestination(
        icon: Icon(
          Icons.pie_chart_outline,
          size: iconSize,
        ),
        label: l10n.budgets,
      ),
      NavigationDestination(
        icon: Icon(
          Icons.account_balance_wallet_outlined,
          size: iconSize,
        ),
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
      bottomNavigationBar: layout.isDesktop 
        ? null 
        : NavigationBar(
            destinations: destinations,
            selectedIndex: index,
            onDestinationSelected: (i) {
              ref.read(navIndexProvider.notifier).state = i;
            },
          ),
      body: layout.isDesktop 
        ? Row(
            children: [
              // Desktop sidebar navigation
              Container(
                width: layout.responsiveSize(
                  phone: 200,
                  tablet: 200,
                  desktop: 200,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  border: Border(
                    right: BorderSide(
                      color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                    ),
                  ),
                ),
                child: Column(
                  children: destinations.asMap().entries.map((entry) {
                    final i = entry.key;
                    final dest = entry.value;
                    return ListTile(
                      leading: dest.icon,
                      title: Text(dest.label),
                      selected: i == index,
                      onTap: () => ref.read(navIndexProvider.notifier).state = i,
                    );
                  }).toList(),
                ),
              ),
              // Main content
              Expanded(
                child: IndexedStack(index: index, children: pages),
              ),
            ],
          )
        : IndexedStack(index: index, children: pages),
    );
  }
}

/// Split the dashboard content
class _DashboardBody extends ConsumerWidget {
  const _DashboardBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final device = context.device;
    final layout = context.layout;
    
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: device == DeviceSize.phone ? 120.ic(context) : 150.ic(context),
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              l10n.dashboard,
              style: TextStyle(
                fontSize: device == DeviceSize.phone 
                  ? 24.sp(context) 
                  : device == DeviceSize.tablet 
                    ? 28.sp(context) 
                    : 32.sp(context),
                fontWeight: FontWeight.bold,
              ),
            ),
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).primaryColor.withValues(alpha: 0.1),
                    Theme.of(context).primaryColor.withValues(alpha: 0.05),
                  ],
                ),
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: context.layout.pageGutter,
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // Welcome message
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(device == DeviceSize.phone ? layout.spaceL : layout.spaceXL),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(layout.radiusL),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome to Pocketa!',
                      style: TextStyle(
                        fontSize: device == DeviceSize.phone 
                          ? 20.sp(context) 
                          : device == DeviceSize.tablet 
                            ? 24.sp(context) 
                            : 28.sp(context),
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: layout.spaceM),
                    Text(
                      'Track your expenses, manage your budget, and achieve your financial goals.',
                      style: TextStyle(
                        fontSize: device == DeviceSize.phone 
                          ? 16.sp(context) 
                          : 18.sp(context),
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: layout.spaceXL),
              // Quick actions
              Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: device == DeviceSize.phone 
                    ? 18.sp(context) 
                    : 20.sp(context),
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              SizedBox(height: layout.spaceM),
              // Action buttons grid
              device == DeviceSize.desktop 
                ? Row(
                    children: [
                      Expanded(child: _buildActionCard(context, 'Add Transaction', Icons.add, () {})),
                      SizedBox(width: layout.spaceM),
                      Expanded(child: _buildActionCard(context, 'View Reports', Icons.analytics, () {})),
                      SizedBox(width: layout.spaceM),
                      Expanded(child: _buildActionCard(context, 'Manage Budget', Icons.account_balance_wallet, () {})),
                    ],
                  )
                : Wrap(
                    spacing: layout.spaceM,
                    runSpacing: layout.spaceM,
                    children: [
                      _buildActionCard(context, 'Add Transaction', Icons.add, () {}),
                      _buildActionCard(context, 'View Reports', Icons.analytics, () {}),
                      _buildActionCard(context, 'Manage Budget', Icons.account_balance_wallet, () {}),
                    ],
                  ),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    final device = context.device;
    final layout = context.layout;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: device == DeviceSize.desktop ? null : 150.ic(context),
        padding: EdgeInsets.all(device == DeviceSize.phone ? layout.spaceL : layout.spaceXL),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(layout.radiusM),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: device == DeviceSize.phone ? 32.ic(context) : 40.ic(context),
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(height: layout.spaceM),
            Text(
              title,
              style: TextStyle(
                fontSize: device == DeviceSize.phone 
                  ? 14.sp(context) 
                  : 16.sp(context),
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
