// lib/core/components/app_chart_card.dart
import 'package:flutter/material.dart';

import '../themes/app_colors.dart';

class AppChartCard extends StatelessWidget {
  final String title;
  final Widget chart;
  final Color? background;

  const AppChartCard({
    super.key,
    required this.title,
    required this.chart,
    this.background,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: background ?? AppColors.accent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          SizedBox(height: 120, child: chart),
        ],
      ),
    );
  }
}
