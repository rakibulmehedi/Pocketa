import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../config/provider/theme_provider.dart';
import '../../../core/themes/app_colors.dart';

final selectedIncomeRangeProvider = StateProvider<String?>((ref) => null);

class IncomeRangeSelectionView extends ConsumerWidget {
  const IncomeRangeSelectionView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkModeProvider);
    return Scaffold(
      backgroundColor:
          isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: Column(children: []),
    );
  }
}
