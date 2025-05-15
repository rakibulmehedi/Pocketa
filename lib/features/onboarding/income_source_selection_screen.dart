// lib/features/onboarding/view/income_source_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/core/component/app_button.dart';
import 'package:pocketa/core/component/app_header.dart';
import 'package:pocketa/core/component/onboarding_chip.dart';
import 'package:pocketa/core/component/skip_button.dart';
import 'package:pocketa/core/themes/app_colors.dart';
import 'package:pocketa/core/utils/responsive_utils.dart';
import 'package:pocketa/core/widgets/app_bar.dart';
import 'package:pocketa/features/onboarding/data/income_options_data.dart';

import '../../l10n/app_localization.dart';
import 'package:pocketa/features/onboarding/model/income_options.dart';

import 'controller/onboarding_controller.dart';

final selectedIncomeSourceProvider = StateProvider<String?>((ref) => null);

class IncomeSourceSelectionScreen extends ConsumerWidget {
  const IncomeSourceSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentStep = ref.watch(onboardingControllerProvider);
    final incomeSource = getIncomeOptions(context);
    int crossAxisCount() {
      final width = MediaQuery
          .of(context)
          .size
          .width;
      if (width < 320) {
        return 1;
      } else if (width < 512) {
        return 2;
      } else if (width < 900) {
        return 3;
      }
      return 2;
    }

    final selectedIncomeSource = ref.watch(selectedIncomeSourceProvider);
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppAppBar(showBackButton: true),
      body: SafeArea(
        child: Padding(
          padding: ResponsiveUtils.horizontalPadding(context),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
          AppHeader(
          title: context.l10n.onboardingStep1,
          subtitle: context.l10n.whatIsYourMainIncomeSource,
          step: currentStep + 1,
          totalSteps: 3,
        ),
        ResponsiveUtils.spacing(context),

        // Income Source Grid
        _buildGridView(
          incomeSource,
          crossAxisCount,
          selectedIncomeSource,
          ref,
        ),
        const Spacer(),
        AppButton(
          label: context.l10n.next,
          onPressed: () {
            selectedIncomeSource != null
                ? ref
                .read(onboardingControllerProvider.notifier)
                .nextStep()
                : null;
            Navigator.pushNamed(context, '/onboarding/next-screen');
          },
        ),
        const SizedBox(height: 16),
        SkipButton(onPressed: (){
          ref.read(onboardingControllerProvider.notifier).skipToEnd();
          Navigator.pushNamed(context, '/onboarding/next-screen');
        }),
      ResponsiveUtils.spacing(context),
      ],
    ),)
    ,
    )
    ,
    );
  }

  GridView _buildGridView(List<IncomeOption> incomeSource,
      int Function() crossAxisCount,
      String? selectedIncomeSource,
      WidgetRef ref,) {
    return GridView.builder(
      itemCount: incomeSource.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount(),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemBuilder: (_, index) {
        final source = incomeSource[index];
        return OnboardingChip(
          label: source.label,
          icon: source.icon,
          isSelected: selectedIncomeSource == source.label,
          onTap: () {
            ref
                .read(selectedIncomeSourceProvider.notifier)
                .state =
                source.label;
          },
        );
      },
    );
  }
}
