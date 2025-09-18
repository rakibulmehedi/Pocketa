import 'package:flutter/material.dart';
import 'package:pocketa/core/responsive/responsive.dart';
import 'package:pocketa/core/utils/transaction_utils.dart';
import 'package:pocketa/l10n/app_localizations.dart';
import '../effects/effects.dart';

/// Summary row with income, expense, and net cards
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
    final t = AppLocalizations.of(context);
    final L = context.layout;

    final spacing = L.spaceS;

    return Padding(
      padding: L.insetsAll(2),
      child: Column(
        children: [
          // Income & Expense row
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  context,
                  t.income,
                  income,
                  Icons.arrow_downward,
                  Colors.green,
                ),
              ),
              SizedBox(width: spacing),
              Expanded(
                child: _buildSummaryCard(
                  context,
                  t.expense,
                  expense,
                  Icons.arrow_upward,
                  Colors.red,
                ),
              ),
            ],
          ),
          SizedBox(height: spacing),
          // Net card (full width)
          _buildSummaryCard(
            context,
            t.net,
            net,
            net >= 0 ? Icons.trending_up : Icons.trending_down,
            net >= 0 ? Colors.green : Colors.red,
            isFullWidth: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    String label,
    double amount,
    IconData icon,
    Color color, {
    bool isFullWidth = false,
  }) {
    final L = context.layout;
    final theme = Theme.of(context);

    return GlassContainer(
      padding: EdgeInsets.all(L.spaceM),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              Icon(
                icon,
                color: color,
                size: L.iconM,
              ),
            ],
          ),
          SizedBox(height: L.spaceS),
          Text(
            formatAmount(amount),
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
