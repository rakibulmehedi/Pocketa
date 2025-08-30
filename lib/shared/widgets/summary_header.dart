import 'package:flutter/material.dart';
import 'package:pocketa/shared/widgets/summary_row.dart';

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
    final cs = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadiusDirectional.only(
          bottomEnd: const Radius.circular(20),
          bottomStart: const Radius.circular(20),
        ),
        gradient: LinearGradient(
          colors: [cs.primary, cs.primaryContainer],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 56, 16, 16),
            child: SummaryRow(income: income, expense: expense, net: net),
          ),
        ),
      ),
    );
  }
}
