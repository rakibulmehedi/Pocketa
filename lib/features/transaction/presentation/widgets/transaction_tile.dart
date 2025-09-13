import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:pocketa/core/constants/default_categories.dart';
import 'package:pocketa/core/responsive/responsive.dart';
import 'package:pocketa/core/design_system/design_system.dart';
import 'package:pocketa/core/utils/transaction_utils.dart';
import 'package:pocketa/features/categories/presentations/viewmodels/category_providers.dart';
import 'package:pocketa/features/transaction/data/models/transaction_model.dart';
import 'package:pocketa/features/transaction/domain/entities/transaction_entity.dart';
import 'package:pocketa/l10n/app_localizations.dart';

class TransactionTile extends ConsumerWidget {
  final TransactionEntity? transaction;
  const TransactionTile({super.key, required this.transaction});

  /// Prototype for SliverPrototypeExtentList (stable height)
  const TransactionTile.prototype({super.key}) : transaction = null;

  // Cache DateFormat per-locale to avoid re-allocations on every build
  static final Map<Locale, DateFormat> _fmtCache = {};
  static DateFormat _fmt(Locale locale) =>
      _fmtCache.putIfAbsent(locale, () => DateFormat.yMMMd(locale.toString()).add_jm());

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Handle prototype case
    if (transaction == null) {
      return _buildPrototype(context);
    }

    final t = AppLocalizations.of(context);
    final L = context.layout;

    // Select exactly what we need (narrow rebuilds)
    final persisted = ref.watch(
      categoryByIdProvider(transaction!.categoryId).select((c) => c),
    );

    // Fallback to default catalog if not found in storage
    final fallback = () {
      try {
        return defaultCategories.firstWhere(
          (c) => c.id == transaction!.categoryId,
        );
      } catch (_) {
        return null;
      }
    }();

    final category = persisted ?? fallback;

    final icon = category != null && category.iconCodePoint != 0
        ? IconData(category.iconCodePoint, fontFamily: category.iconFontFamily)
        : _defaultIcon(transaction!.type);

    final baseColor = category != null
        ? Color(category.colorHex)
        : _defaultColor(transaction!.type, context);

    final title = category?.name ?? t.uncategorized;
    final dateText = _fmt(Localizations.localeOf(context)).format(transaction!.date.toLocal());

    final signedAmount = transaction!.type == TransactionType.expense
        ? -transaction!.amount
        : transaction!.amount;
    final amountText = formatAmount(signedAmount);

    final isCompact = L.isMobile || L.isCompact;
    final isDesktop = L.isDesktop;
    
    // Consistent sizing for better alignment using design tokens
    final leadingSize = DesignTokens.getResponsiveSpacing(
      context,
      phone: 5.0,
      tablet: 6.0,
      desktop: 7.0,
    );
    final iconSize = DesignTokens.getResponsiveIconSize(
      context,
      phone: DesignTokens.iconM,
      tablet: DesignTokens.iconL,
      desktop: DesignTokens.iconL + 4,
    );
    final containerSize = DesignTokens.getResponsiveSpacing(
      context,
      phone: 4.5,
      tablet: 5.5,
      desktop: 6.5,
    );

    return ListTile(
      key: ValueKey(transaction!.id),
      dense: isCompact,
      contentPadding: DesignTokens.getResponsivePadding(
        context,
        horizontal: DesignTokens.getResponsiveSpacing(
          context,
          phone: 1.5,
          tablet: 2,
          desktop: 3,
        ),
        vertical: DesignTokens.getResponsiveSpacing(
          context,
          phone: 0.2,
          tablet: 0.3,
          desktop: 0.4,
        ),
      ),
      horizontalTitleGap: DesignTokens.getResponsiveSpacing(
        context,
        phone: 1.2,
        tablet: 1.8,
        desktop: 2.2,
      ),
      minLeadingWidth: leadingSize,
      minVerticalPadding: DesignTokens.getResponsiveSpacing(
        context,
        phone: 6,
        tablet: 8,
        desktop: 10,
      ),
      titleAlignment: ListTileTitleAlignment.top,
      leading: SizedBox.square(
        dimension: containerSize,
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: baseColor.withValues(alpha: 0.12),
          ),
          child: Center(
            child: Icon(
              icon,
              color: baseColor,
              size: iconSize,
            ),
          ),
        ),
      ),
      title: Text(
        title,
        maxLines: isDesktop ? 2 : 1,
        overflow: TextOverflow.ellipsis,
        style: TypographyTokens.responsive(
          context,
          phone: TypographyTokens.bodyLarge(context).copyWith(
            fontWeight: DesignTokens.fontWeightSemiBold,
            height: DesignTokens.lineHeightTight,
          ),
          tablet: TypographyTokens.bodyLarge(context).copyWith(
            fontWeight: DesignTokens.fontWeightSemiBold,
            height: DesignTokens.lineHeightTight,
          ),
          desktop: TypographyTokens.bodyLarge(context).copyWith(
            fontWeight: DesignTokens.fontWeightSemiBold,
            height: DesignTokens.lineHeightNormal,
          ),
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (transaction!.note?.isNotEmpty == true) ...[
            Text(
              transaction!.note!,
              maxLines: isDesktop ? 2 : 1,
              overflow: TextOverflow.ellipsis,
              style: TypographyTokens.responsive(
                context,
                phone: TypographyTokens.bodySmall(context).copyWith(
                  color: ColorTokens.textSecondary(context),
                  height: DesignTokens.lineHeightNormal,
                ),
                tablet: TypographyTokens.bodyMedium(context).copyWith(
                  color: ColorTokens.textSecondary(context),
                  height: DesignTokens.lineHeightNormal,
                ),
                desktop: TypographyTokens.bodyMedium(context).copyWith(
                  color: ColorTokens.textSecondary(context),
                  height: DesignTokens.lineHeightNormal,
                ),
              ),
            ),
            SizedBox(height: DesignTokens.getResponsiveSpacing(
              context,
              phone: 2,
              tablet: 4,
              desktop: 6,
            )),
          ],
          Text(
            dateText,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TypographyTokens.responsive(
              context,
              phone: TypographyTokens.labelSmall(context).copyWith(
                color: ColorTokens.textTertiary(context),
                height: DesignTokens.lineHeightTight,
              ),
              tablet: TypographyTokens.labelSmall(context).copyWith(
                color: ColorTokens.textTertiary(context),
                height: DesignTokens.lineHeightTight,
              ),
              desktop: TypographyTokens.labelSmall(context).copyWith(
                color: ColorTokens.textTertiary(context),
                height: DesignTokens.lineHeightTight,
              ),
            ),
          ),
        ],
      ),
      trailing: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: DesignTokens.getResponsiveSpacing(
            context,
            phone: 12,
            tablet: 14,
            desktop: 18,
          ),
        ),
        child: Align(
          alignment: Alignment.centerRight,
          child: Text(
            amountText,
            textAlign: TextAlign.end,
            style: TypographyTokens.responsive(
              context,
              phone: TypographyTokens.titleMedium(context).copyWith(
                fontWeight: DesignTokens.fontWeightBold,
                color: _amountColor(transaction!.type, context),
                height: DesignTokens.lineHeightTight,
                letterSpacing: DesignTokens.letterSpacingTight,
              ),
              tablet: TypographyTokens.titleLarge(context).copyWith(
                fontWeight: DesignTokens.fontWeightBold,
                color: _amountColor(transaction!.type, context),
                height: DesignTokens.lineHeightTight,
                letterSpacing: DesignTokens.letterSpacingTight,
              ),
              desktop: TypographyTokens.titleLarge(context).copyWith(
                fontWeight: DesignTokens.fontWeightBold,
                color: _amountColor(transaction!.type, context),
                height: DesignTokens.lineHeightTight,
                letterSpacing: DesignTokens.letterSpacingTight,
              ),
            ),
          ),
        ),
      ),
      onTap: () => context.pushNamed('add_edit_tx', extra: transaction),
    );
  }

  /// Builds a lightweight prototype tile for SliverPrototypeExtentList
  Widget _buildPrototype(BuildContext context) {
    final L = context.layout;
    final theme = Theme.of(context);
    final isCompact = L.isMobile || L.isCompact;
    
    // Match the actual tile sizing for consistency
    final leadingSize = L.responsiveSize(
      phone: 5.0,
      tablet: 6.0,
      desktop: 7.0,
    );
    final iconSize = L.responsiveIconSize(
      phone: 20,
      tablet: 24,
      desktop: 28,
    );
    final containerSize = L.responsiveSize(
      phone: 4.5,
      tablet: 5.5,
      desktop: 6.5,
    );

    // Use a more conservative height calculation to prevent overlapping
    final tileHeight = L.responsiveSize(phone: 5.5, tablet: 7, desktop: 7.5);

    return SizedBox(
      height: tileHeight,
      child: ListTile(
        dense: isCompact,
        contentPadding: L.insetsSymmetric(
          h: L.responsiveSize(phone: 1.5, tablet: 2, desktop: 3), 
          v: L.responsiveSize(phone: 0.2, tablet: 0.3, desktop: 0.4),
        ),
        horizontalTitleGap: L.responsiveSize(phone: 1.2, tablet: 1.8, desktop: 2.2),
        minLeadingWidth: leadingSize,
        minVerticalPadding: L.responsiveSize(phone: 6, tablet: 8, desktop: 10),
        titleAlignment: ListTileTitleAlignment.top,
        leading: SizedBox.square(
          dimension: containerSize,
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorScheme.outline.withValues(alpha: 0.12),
            ),
            child: Center(
              child: Icon(
                Icons.place,
                color: theme.colorScheme.outline,
                size: iconSize,
              ),
            ),
          ),
        ),
        title: Container(
          height: L.responsiveTextSize(phone: 16, tablet: 18, desktop: 20),
          decoration: BoxDecoration(
            color: theme.colorScheme.outline.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: L.responsiveSize(phone: 2, tablet: 4, desktop: 6)),
            Container(
              height: L.responsiveTextSize(phone: 11, tablet: 12, desktop: 13),
              width: 80,
              decoration: BoxDecoration(
                color: theme.colorScheme.outline.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
        trailing: Container(
          height: L.responsiveTextSize(phone: 15, tablet: 17, desktop: 19),
          width: 60,
          decoration: BoxDecoration(
            color: theme.colorScheme.outline.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  // — Helpers —
  static IconData _defaultIcon(TransactionType type) => switch (type) {
        TransactionType.income => Icons.arrow_downward_rounded,
        TransactionType.expense => Icons.arrow_upward_rounded,
        TransactionType.transfer => Icons.swap_horiz_rounded,
      };

  static Color _defaultColor(TransactionType type, BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return switch (type) {
      TransactionType.income => isDark ? Colors.greenAccent : Colors.green,
      TransactionType.expense => isDark ? Colors.redAccent : Colors.red,
      TransactionType.transfer => isDark ? Colors.blueAccent : Colors.blueGrey,
    };
  }

  static Color _amountColor(TransactionType type, BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return switch (type) {
      TransactionType.expense => isDark ? Colors.redAccent : Colors.red,
      TransactionType.income => isDark ? Colors.greenAccent : Colors.green,
      TransactionType.transfer => isDark ? Colors.blueAccent : Colors.blueGrey,
    };
  }
}
