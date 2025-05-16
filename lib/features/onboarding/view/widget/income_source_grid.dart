import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/component/onboarding_chip.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../data/income_options_data.dart';
import '../income_source_selection_screen.dart';

class IncomeSourceGrid extends ConsumerWidget {
  const IncomeSourceGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sources = getIncomeOptions(context);
    final selected = ref.watch(selectedIncomeSourceProvider);

    return // GridView-কে Expanded দিয়ে height দিলে overflow কমে
    Expanded(
      child: GridView.builder(
        itemCount: sources.length,
        padding: const EdgeInsets.all(8),
        physics: const BouncingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: ResponsiveUtils.gridCrossAxisCount(context),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.2,
        ),
        itemBuilder: (_, index) {
          final source = sources[index];
          return OnboardingChip(
            label: source.label,
            icon: source.icon,
            isSelected: selected == source.label,
            onTap:
                () =>
                    ref.read(selectedIncomeSourceProvider.notifier).state =
                        source.label,
          );
        },
      ),
    );
  }
}
