import 'package:flutter/material.dart';
import 'package:pocketa/core/responsive/responsive.dart';
import 'package:pocketa/core/theme/text_styles.dart';
import 'package:pocketa/shared/widgets/unified_animations.dart';

/// A standardized list view widget that provides consistent styling
/// and behavior across the application.
class AppListView<T> extends StatelessWidget {
  const AppListView({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.separatorBuilder,
    this.emptyWidget,
    this.loadingWidget,
    this.errorWidget,
    this.header,
    this.footer,
    this.padding,
    this.physics,
    this.shrinkWrap = false,
    this.primary = true,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.cacheExtent,
    this.itemExtent,
    this.prototypeItem,
  });

  final List<T> items;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final Widget Function(BuildContext context, int index)? separatorBuilder;
  final Widget? emptyWidget;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final Widget? header;
  final Widget? footer;
  final EdgeInsets? padding;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final bool primary;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final double? cacheExtent;
  final double? itemExtent;
  final Widget? prototypeItem;

  @override
  Widget build(BuildContext context) {
    final layout = context.layout;
    
    if (items.isEmpty) {
      return _buildEmptyState(context, layout);
    }

    return ListView.separated(
      padding: padding ?? EdgeInsets.all(layout.spaceM),
      physics: physics ?? const AlwaysScrollableScrollPhysics(),
      shrinkWrap: shrinkWrap,
      primary: primary,
      addAutomaticKeepAlives: addAutomaticKeepAlives,
      addRepaintBoundaries: addRepaintBoundaries,
      addSemanticIndexes: addSemanticIndexes,
      cacheExtent: cacheExtent,
      itemCount: items.length + (header != null ? 1 : 0) + (footer != null ? 1 : 0),
      separatorBuilder: separatorBuilder ?? (context, index) => SizedBox(height: layout.spaceM),
      itemBuilder: (context, index) {
        // Header
        if (header != null && index == 0) {
          return header!;
        }
        
        // Footer
        if (footer != null && index == items.length + (header != null ? 1 : 0)) {
          return footer!;
        }
        
        // Items
        final itemIndex = header != null ? index - 1 : index;
        return UnifiedAnimations.fadeSlideIn(
          child: itemBuilder(context, items[itemIndex], itemIndex),
          duration: UnifiedAnimations.fast,
          curve: UnifiedAnimations.easeOut,
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, AppSize layout) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(layout.spaceXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: layout.responsiveSize(phone: 48, tablet: 64, desktop: 80),
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            SizedBox(height: layout.spaceL),
            Text(
              'No items found',
              style: AppTextStyles.responsiveTitle(context),
            ),
            SizedBox(height: layout.spaceS),
            Text(
              'Try adding some items to get started',
              style: AppTextStyles.responsiveBody(context),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// A specialized list view for transactions
class TransactionListView extends StatelessWidget {
  const TransactionListView({
    super.key,
    required this.transactions,
    this.onTransactionTap,
    this.onTransactionEdit,
    this.onTransactionDelete,
    this.emptyWidget,
    this.header,
    this.footer,
  });

  final List<dynamic> transactions; // Replace with actual TransactionEntity type
  final Function(dynamic)? onTransactionTap;
  final Function(dynamic)? onTransactionEdit;
  final Function(dynamic)? onTransactionDelete;
  final Widget? emptyWidget;
  final Widget? header;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return AppListView(
      items: transactions,
      emptyWidget: emptyWidget,
      header: header,
      footer: footer,
      itemBuilder: (context, transaction, index) {
        return _buildTransactionTile(context, transaction, index);
      },
    );
  }

  Widget _buildTransactionTile(BuildContext context, dynamic transaction, int index) {
    // This would be replaced with actual TransactionTile widget
    return Card(
      child: ListTile(
        title: Text('Transaction ${index + 1}'),
        subtitle: Text('Amount: \$${transaction.amount ?? 0}'),
        onTap: () => onTransactionTap?.call(transaction),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'edit',
              child: const Text('Edit'),
            ),
            PopupMenuItem(
              value: 'delete',
              child: const Text('Delete'),
            ),
          ],
          onSelected: (value) {
            switch (value) {
              case 'edit':
                onTransactionEdit?.call(transaction);
                break;
              case 'delete':
                onTransactionDelete?.call(transaction);
                break;
            }
          },
        ),
      ),
    );
  }
}

/// A specialized list view for categories
class CategoryListView extends StatelessWidget {
  const CategoryListView({
    super.key,
    required this.categories,
    this.onCategoryTap,
    this.onCategoryEdit,
    this.onCategoryDelete,
    this.emptyWidget,
    this.header,
    this.footer,
  });

  final List<dynamic> categories; // Replace with actual CategoryEntity type
  final Function(dynamic)? onCategoryTap;
  final Function(dynamic)? onCategoryEdit;
  final Function(dynamic)? onCategoryDelete;
  final Widget? emptyWidget;
  final Widget? header;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return AppListView(
      items: categories,
      emptyWidget: emptyWidget,
      header: header,
      footer: footer,
      itemBuilder: (context, category, index) {
        return _buildCategoryTile(context, category, index);
      },
    );
  }

  Widget _buildCategoryTile(BuildContext context, dynamic category, int index) {
    // This would be replaced with actual CategoryTile widget
    return Card(
      child: ListTile(
        leading: Icon(
          Icons.category,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: Text(category.name ?? 'Category ${index + 1}'),
        subtitle: Text('Type: ${category.type ?? 'Unknown'}'),
        onTap: () => onCategoryTap?.call(category),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'edit',
              child: const Text('Edit'),
            ),
            PopupMenuItem(
              value: 'delete',
              child: const Text('Delete'),
            ),
          ],
          onSelected: (value) {
            switch (value) {
              case 'edit':
                onCategoryEdit?.call(category);
                break;
              case 'delete':
                onCategoryDelete?.call(category);
                break;
            }
          },
        ),
      ),
    );
  }
}

/// A specialized list view for wallets
class WalletListView extends StatelessWidget {
  const WalletListView({
    super.key,
    required this.wallets,
    this.onWalletTap,
    this.onWalletEdit,
    this.onWalletDelete,
    this.emptyWidget,
    this.header,
    this.footer,
  });

  final List<dynamic> wallets; // Replace with actual WalletEntity type
  final Function(dynamic)? onWalletTap;
  final Function(dynamic)? onWalletEdit;
  final Function(dynamic)? onWalletDelete;
  final Widget? emptyWidget;
  final Widget? header;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return AppListView(
      items: wallets,
      emptyWidget: emptyWidget,
      header: header,
      footer: footer,
      itemBuilder: (context, wallet, index) {
        return _buildWalletTile(context, wallet, index);
      },
    );
  }

  Widget _buildWalletTile(BuildContext context, dynamic wallet, int index) {
    // This would be replaced with actual WalletTile widget
    return Card(
      child: ListTile(
        leading: Icon(
          Icons.account_balance_wallet,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: Text(wallet.name ?? 'Wallet ${index + 1}'),
        subtitle: Text('Balance: \$${wallet.balance ?? 0}'),
        onTap: () => onWalletTap?.call(wallet),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'edit',
              child: const Text('Edit'),
            ),
            PopupMenuItem(
              value: 'delete',
              child: const Text('Delete'),
            ),
          ],
          onSelected: (value) {
            switch (value) {
              case 'edit':
                onWalletEdit?.call(wallet);
                break;
              case 'delete':
                onWalletDelete?.call(wallet);
                break;
            }
          },
        ),
      ),
    );
  }
}
