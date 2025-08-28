import 'package:flutter/material.dart';
import 'package:pocketa/core/responsive/responsive.dart';
import 'package:pocketa/core/utils/transaction_utils.dart';
import 'package:pocketa/widgets/glass_container.dart';

class SummaryRow extends StatelessWidget {
  final double income, expense, net;
  const SummaryRow({
    super.key,
    required this.income,
    required this.expense,
    required this.net,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCompact = context.isCompact;

    Widget pill({
      required String label,
      required double value,
      required Color accent,
      IconData? icon,
    }) {
      return Flexible(
        fit: FlexFit.tight,
        child: GlassContainer(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          constraints: BoxConstraints(minHeight: isCompact ? 56 : 64),
          padding: EdgeInsets.symmetric(
            vertical: isCompact ? 10 : 12,
            horizontal: isCompact ? 12 : 14,
          ),
          blur: isCompact ? 12 : 16,
          opacity: isCompact ? 0.18 : 0.12,
          borderRadius: BorderRadius.circular(isCompact ? 12 : 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: isCompact ? 18 : 20,
                  color: accent.withOpacity(0.9),
                ),
                const SizedBox(width: 8),
              ],
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.onSurface.withOpacity(0.8),
                      fontSize: isCompact ? 12 : 13.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formatAmount(value, currency: '৳'),
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: isCompact ? 16 : 18,
                      color: accent,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    Widget netCard() {
      final isPositive = net >= 0;
      final accent = isPositive
          ? Colors.greenAccent.shade400
          : Colors.redAccent.shade400;
      final icon = isPositive
          ? Icons.trending_up_rounded
          : Icons.trending_down_rounded;

      return GlassContainer(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        constraints: BoxConstraints(minHeight: isCompact ? 64 : 72),
        padding: EdgeInsets.symmetric(
          vertical: isCompact ? 12 : 14,
          horizontal: isCompact ? 14 : 16,
        ),
        blur: isCompact ? 12 : 16,
        opacity: isCompact ? 0.18 : 0.12,
        borderRadius: BorderRadius.circular(isCompact ? 12 : 16),
        child: Row(
          children: [
            Container(
              height: isCompact ? 36 : 40,
              width: isCompact ? 36 : 40,
              decoration: BoxDecoration(
                color: accent.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: accent),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Net Balance',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.onSurface.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    formatAmount(net, currency: '৳'),
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: accent,
                    ),
                  ),
                ],
              ),
            ),
            // optional subtle badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: accent.withOpacity(0.12),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                isPositive ? 'Surplus' : 'Deficit',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: accent,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              pill(
                label: 'Income',
                value: income,
                accent: Colors.greenAccent.shade400,
                icon: Icons.south_west_rounded,
              ),
              const SizedBox(width: 8),
              pill(
                label: 'Expense',
                value: expense,
                accent: Colors.redAccent.shade400,
                icon: Icons.north_east_rounded,
              ),
            ],
          ),
          const SizedBox(height: 12),
          netCard(),
        ],
      ),
    );
  }
}
