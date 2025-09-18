import 'package:flutter/material.dart';
import 'package:pocketa/core/responsive/responsive.dart';
import 'package:pocketa/core/utils/transaction_utils.dart';

/// Summary header with gradient background
class SummaryHeader extends StatelessWidget {
  final double income;
  final double expense;
  final double net;
  const SummaryHeader({
    super.key,
    required this.income,
    required this.expense,
    required this.net,
  });

  @override
  Widget build(BuildContext context) {
    final L = context.layout;
    final cs = Theme.of(context).colorScheme;

    final radius = BorderRadiusDirectional.only(
      bottomStart: Radius.circular(L.radiusL),
      bottomEnd: Radius.circular(L.radiusL),
    );

    return ClipRRect(
      borderRadius: radius,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              cs.primary,
              cs.primary.withValues(alpha: 0.8),
            ],
          ),
        ),
        child: Padding(
          padding: L.insetsAll(3),
          child: Column(
            children: [
              Text(
                'Summary',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: cs.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: L.spaceM),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSummaryItem(
                    context,
                    'Income',
                    income,
                    Icons.arrow_downward,
                    cs.onPrimary,
                  ),
                  _buildSummaryItem(
                    context,
                    'Expense',
                    expense,
                    Icons.arrow_upward,
                    cs.onPrimary,
                  ),
                  _buildSummaryItem(
                    context,
                    'Net',
                    net,
                    net >= 0 ? Icons.trending_up : Icons.trending_down,
                    cs.onPrimary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryItem(
    BuildContext context,
    String label,
    double amount,
    IconData icon,
    Color color,
  ) {
    final L = context.layout;
    
    return Column(
      children: [
        Icon(icon, color: color, size: L.iconL),
        SizedBox(height: L.spaceS),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: color.withValues(alpha: 0.8),
          ),
        ),
        SizedBox(height: L.spaceS),
        Text(
          formatAmount(amount),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
