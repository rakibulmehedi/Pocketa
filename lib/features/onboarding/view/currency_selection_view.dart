import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/core/utils/responsive_utils.dart';
import 'package:pocketa/core/widgets/currency_drop_down.dart';

class CurrencySelectionView extends ConsumerWidget {
  const CurrencySelectionView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Padding(
      padding: ResponsiveUtils.horizontalPadding(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CurrencyDropdown()
        ],
      ),
    );
  }
}
