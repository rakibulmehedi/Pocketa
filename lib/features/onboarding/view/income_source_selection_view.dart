// lib/features/onboarding/view/income_source_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/core/themes/app_colors.dart';
import 'package:pocketa/core/utils/responsive_utils.dart';

import 'package:pocketa/features/onboarding/view/widget/income_source_grid.dart';

import '../../../config/provider/theme_provider.dart';

final selectedIncomeSourceProvider = StateProvider<String?>((ref) => null);

class IncomeSourceSelectionScreen extends ConsumerWidget {
  const IncomeSourceSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isDark = ref.watch(isDarkModeProvider);

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: Padding(
        padding: ResponsiveUtils.horizontalPadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ResponsiveUtils.spacing(context, multiplier: 1.5),
            const IncomeSourceGrid(),
            ResponsiveUtils.spacing(context, multiplier: 2),
          ],
        ),
      ),
    );
  }
}
