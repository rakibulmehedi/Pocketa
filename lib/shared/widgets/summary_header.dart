import 'package:flutter/material.dart';
import 'package:pocketa/core/responsive/responsive.dart';
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
            colors: [cs.primary, cs.primaryContainer],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: SizedBox.expand(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                L.rem(2),
                L.isDesktop ? L.rem(4) : (L.isTablet ? L.rem(3) : L.rem(2.5)),
                L.rem(2),
                L.rem(2),
              ),
              child: SummaryRow(income: income, expense: expense, net: net),
            ),
          ),
        ),
      ),
    );
  }
}
