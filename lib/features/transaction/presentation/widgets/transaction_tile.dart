import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:pocketa/core/constants/default_categories.dart';
import 'package:pocketa/core/utils/transaction_utils.dart';
import 'package:pocketa/features/categories/presentations/viewmodels/category_providers.dart';
import 'package:pocketa/features/transaction/data/models/transaction_model.dart';
import 'package:pocketa/features/transaction/domain/entities/transaction_entity.dart';

class TransactionTile extends ConsumerWidget {
  final TransactionEntity transaction;
  const TransactionTile({super.key, required this.transaction});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1) Try reading from your persisted categories (may be null)
    final persisted = ref.watch(categoryByIdProvider(transaction.categoryId));

    // 2) Fallback to in-memory defaults (same id as the chip picker uses)
    final fallback = () {
      try {
        return defaultCategories.firstWhere(
          (c) => c.id == transaction.categoryId,
        );
      } catch (_) {
        return null;
      }
    }();

    final category = persisted ?? fallback;

    final dateText = DateFormat(
      'EEE, MMM d, hh:mm a',
    ).format(transaction.date.toLocal());

    final signedAmount = transaction.type == TransactionType.expense
        ? -transaction.amount
        : transaction.amount;
    final amountText = formatAmount(signedAmount);

    IconData defaultIcon;
    Color defaultColor;
    switch (transaction.type) {
      case TransactionType.income:
        defaultIcon = Icons.arrow_downward_rounded;
        defaultColor = Colors.green;
        break;
      case TransactionType.expense:
        defaultIcon = Icons.arrow_upward_rounded;
        defaultColor = Colors.red;
        break;
      case TransactionType.transfer:
        defaultIcon = Icons.swap_horiz_rounded;
        defaultColor = Colors.blueGrey;
        break;
    }

    final icon = category != null
        ? IconData(category.iconCodePoint, fontFamily: category.iconFontFamily)
        : defaultIcon;
    final color = category != null ? Color(category.colorHex) : defaultColor;
    final title = category?.name ?? 'Uncategorized';

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: 0.12),
        child: Icon(icon, color: color),
      ),
      title: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (transaction.note?.isNotEmpty == true) Text(transaction.note!),
          Text(
            dateText,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
      trailing: Text(
        amountText,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: transaction.type == TransactionType.expense
              ? Colors.red.shade400
              : (transaction.type == TransactionType.income
                    ? Colors.green.shade600
                    : Colors.blueGrey),
        ),
      ),
      onTap: () => context.pushNamed('add_edit_tx', extra: transaction),
    );
  }
}
