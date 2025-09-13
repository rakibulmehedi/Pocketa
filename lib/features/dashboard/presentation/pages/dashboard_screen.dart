import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/core/analytics/analytics_service.dart';
import 'package:pocketa/core/responsive/responsive.dart';
import 'package:pocketa/core/design_system/design_system.dart';
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
    
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: DesignTokens.getResponsiveSpacing(
            context,
            phone: 120,
            tablet: 140,
            desktop: 160,
          ),
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              l10n.dashboard,
              style: TypographyTokens.responsive(
                context,
                phone: TypographyTokens.headlineLarge(context).copyWith(
                  fontWeight: DesignTokens.fontWeightBold,
                ),
                tablet: TypographyTokens.displaySmall(context).copyWith(
                  fontWeight: DesignTokens.fontWeightBold,
                ),
                desktop: TypographyTokens.displayMedium(context).copyWith(
                  fontWeight: DesignTokens.fontWeightBold,
                ),
              ),
            ),
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    ColorTokens.primaryLight(context),
                    ColorTokens.primarySubtle(context),
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
                padding: DesignTokens.getCardPadding(context),
                decoration: ComponentTokens.elevatedCardDecoration(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome to Pocketa!',
                      style: TypographyTokens.responsive(
                        context,
                        phone: TypographyTokens.headlineMedium(context).copyWith(
                          fontWeight: DesignTokens.fontWeightBold,
                          color: ColorTokens.textPrimary(context),
                        ),
                        tablet: TypographyTokens.headlineLarge(context).copyWith(
                          fontWeight: DesignTokens.fontWeightBold,
                          color: ColorTokens.textPrimary(context),
                        ),
                        desktop: TypographyTokens.displaySmall(context).copyWith(
                          fontWeight: DesignTokens.fontWeightBold,
                          color: ColorTokens.textPrimary(context),
                        ),
                      ),
                    ),
                    SizedBox(height: DesignTokens.spaceM),
                    Text(
                      'Track your expenses, manage your budget, and achieve your financial goals.',
                      style: TypographyTokens.responsive(
                        context,
                        phone: TypographyTokens.bodyLarge(context).copyWith(
                          color: ColorTokens.textSecondary(context),
                          height: DesignTokens.lineHeightRelaxed,
                        ),
                        tablet: TypographyTokens.bodyLarge(context).copyWith(
                          color: ColorTokens.textSecondary(context),
                          height: DesignTokens.lineHeightRelaxed,
                        ),
                        desktop: TypographyTokens.bodyLarge(context).copyWith(
                          color: ColorTokens.textSecondary(context),
                          height: DesignTokens.lineHeightRelaxed,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: DesignTokens.spaceXl),
              // Quick actions
              Text(
                'Quick Actions',
                style: TypographyTokens.responsive(
                  context,
                  phone: TypographyTokens.headlineSmall(context).copyWith(
                    fontWeight: DesignTokens.fontWeightSemiBold,
                    color: ColorTokens.textPrimary(context),
                  ),
                  tablet: TypographyTokens.headlineMedium(context).copyWith(
                    fontWeight: DesignTokens.fontWeightSemiBold,
                    color: ColorTokens.textPrimary(context),
                  ),
                  desktop: TypographyTokens.headlineMedium(context).copyWith(
                    fontWeight: DesignTokens.fontWeightSemiBold,
                    color: ColorTokens.textPrimary(context),
                  ),
                ),
              ),
              SizedBox(height: DesignTokens.spaceM),
              // Action buttons grid
              DesignTokens.isDesktop(context)
                ? Row(
                    children: [
                      Expanded(child: _buildActionCard(context, 'Add Transaction', Icons.add, () {})),
                      SizedBox(width: DesignTokens.spaceM),
                      Expanded(child: _buildActionCard(context, 'View Reports', Icons.analytics, () {})),
                      SizedBox(width: DesignTokens.spaceM),
                      Expanded(child: _buildActionCard(context, 'Manage Budget', Icons.account_balance_wallet, () {})),
                    ],
                  )
                : Wrap(
                    spacing: DesignTokens.spaceM,
                    runSpacing: DesignTokens.spaceM,
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: DesignTokens.isDesktop(context) ? null : DesignTokens.getResponsiveSpacing(
          context,
          phone: 150,
          tablet: 180,
          desktop: 200,
        ),
        padding: DesignTokens.getCardPadding(context),
        decoration: ComponentTokens.cardDecoration(context),
        child: Column(
          children: [
            Icon(
              icon,
              size: DesignTokens.getResponsiveIconSize(
                context,
                phone: DesignTokens.icon2xl,
                tablet: DesignTokens.icon2xl + 8,
                desktop: DesignTokens.icon2xl + 16,
              ),
              color: ColorTokens.primary(context),
            ),
            SizedBox(height: DesignTokens.spaceM),
            Text(
              title,
              style: TypographyTokens.responsive(
                context,
                phone: TypographyTokens.titleSmall(context).copyWith(
                  fontWeight: DesignTokens.fontWeightMedium,
                  color: ColorTokens.textPrimary(context),
                ),
                tablet: TypographyTokens.titleMedium(context).copyWith(
                  fontWeight: DesignTokens.fontWeightMedium,
                  color: ColorTokens.textPrimary(context),
                ),
                desktop: TypographyTokens.titleMedium(context).copyWith(
                  fontWeight: DesignTokens.fontWeightMedium,
                  color: ColorTokens.textPrimary(context),
                ),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
