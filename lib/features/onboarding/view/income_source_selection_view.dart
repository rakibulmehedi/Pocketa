// lib/features/onboarding/view/income_source_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/core/themes/app_colors.dart';
import 'package:pocketa/core/utils/responsive_utils.dart';
import 'package:pocketa/core/widgets/app_grid.dart';

import '../../../config/provider/onboarding_state.dart';
import '../../../config/provider/theme_provider.dart';
import '../data/income_source_data.dart';

class IncomeSourceSelectionScreen extends ConsumerWidget {
  const IncomeSourceSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isDark = ref.watch(isDarkModeProvider);

    final onboardingState = ref.watch(onboardingStateProvider);
    final selected = onboardingState.incomeSource;
    final gridItems = getIncomeOptions(context);

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: Padding(
        padding: ResponsiveUtilities.horizontalPadding(context),
        child: AppGrid(
          items: gridItems,
          selectedLabel: selected,
          onSelect: (label) {
            ref.read(onboardingStateProvider.notifier).setIncomeSource(label);
          },
        ),
      ),
    );
  }
}
