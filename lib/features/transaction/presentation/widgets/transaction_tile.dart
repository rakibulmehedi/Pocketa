import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:pocketa/core/constants/default_categories.dart';
import 'package:pocketa/core/responsive/responsive.dart';
import 'package:pocketa/core/utils/transaction_utils.dart';
import 'package:pocketa/features/categories/presentations/viewmodels/category_providers.dart';
import 'package:pocketa/features/transaction/data/models/transaction_model.dart';
import 'package:pocketa/features/transaction/domain/entities/transaction_entity.dart';
import 'package:pocketa/l10n/app_localizations.dart';

class TransactionTile extends ConsumerWidget {
  final TransactionEntity transaction;
  const TransactionTile({super.key, required this.transaction});

  /// Prototype for SliverPrototypeExtentList (stable height)
  TransactionTile.prototype({super.key})
      : transaction = TransactionEntity(
          id: 'prototype',
          amount: 0,
          date: DateTime(2024),
          type: TransactionType.expense,
          categoryId: '',
          walletId: '',
        );

  // Cache DateFormat per-locale to avoid re-allocations on every build
  static final Map<String, DateFormat> _fmtCache = {};
  static DateFormat _fmt(String locale) =>
      _fmtCache.putIfAbsent(locale, () => DateFormat.yMMMd(locale).add_jm());

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final L = context.layout;

    // Select exactly what we need (narrow rebuilds)
    final persisted = ref.watch(
      categoryByIdProvider(transaction.categoryId).select((c) => c),
    );

    // Fallback to default catalog if not found in storage
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

    final icon = category != null
        ? IconData(category.iconCodePoint, fontFamily: category.iconFontFamily)
        : _defaultIcon(transaction.type);

    final baseColor = category != null
        ? Color(category.colorHex)
        : _defaultColor(transaction.type);

    final title = category?.name ?? t.uncategorized;
    final dateText = _fmt(t.localeName).format(transaction.date.toLocal());

    final signedAmount = transaction.type == TransactionType.expense
        ? -transaction.amount
        : transaction.amount;
    final amountText = formatAmount(signedAmount);

    final isCompact = L.isMobile || L.isCompact;
    final leadingSize = isCompact ? L.rem(4.5) : L.rem(5);
    final iconSize = isCompact ? L.iconM : L.iconL;

    return ListTile(
      key: ValueKey(transaction.id),
      dense: isCompact,
      contentPadding: L.insetsSymmetric(h: isCompact ? 1.5 : 2, v: 0.25),
      horizontalTitleGap: L.rem(1),
      minLeadingWidth: leadingSize,
      minVerticalPadding: 0,
      titleAlignment: ListTileTitleAlignment.center,
      leading: SizedBox.square(
        dimension: leadingSize,
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: baseColor.withValues(alpha: 0.12),
          ),
          child: Center(
            child: Icon(icon, color: baseColor, size: iconSize),
          ),
        ),
      ),
      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (transaction.note?.isNotEmpty == true)
            Text(
              transaction.note!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          SizedBox(height: L.spaceXs),
          Text(
            dateText,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: cs.onSurfaceVariant,
            ),
          ),
        ],
      ),
      trailing: ConstrainedBox(
        constraints: BoxConstraints(minWidth: L.rem(10)),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerRight,
          child: Text(
            amountText,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: _amountColor(transaction.type),
            ),
          ),
        ),
      ),
      onTap: () => context.pushNamed('add_edit_tx', extra: transaction),
    );
  }

  // — Helpers —
  static IconData _defaultIcon(TransactionType type) => switch (type) {
        TransactionType.income => Icons.arrow_downward_rounded,
        TransactionType.expense => Icons.arrow_upward_rounded,
        TransactionType.transfer => Icons.swap_horiz_rounded,
      };

  static Color _defaultColor(TransactionType type) => switch (type) {
        TransactionType.income => Colors.green,
        TransactionType.expense => Colors.red,
        TransactionType.transfer => Colors.blueGrey,
      };

  static Color _amountColor(TransactionType type) => switch (type) {
        TransactionType.expense => Colors.redAccent,
        TransactionType.income => Colors.green,
        TransactionType.transfer => Colors.blueGrey,
      };
}
