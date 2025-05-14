// lib/features/onboarding/view/income_source_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/core/component/app_button.dart';
import 'package:pocketa/core/component/app_header.dart';
import 'package:pocketa/core/themes/app_colors.dart';

import '../../core/component/app_chip.dart';
import '../../core/constants/strings.dart';

final incomeSources = ['Freelance', 'Job', 'Family Support', 'Other'];

final selectedIncomeSourceProvider = StateProvider<String?>((ref) => null);

class IncomeSourceSelectionScreen extends ConsumerWidget {
  const IncomeSourceSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIncomeSource = ref.watch(selectedIncomeSourceProvider);
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: Colors.black12
          ),
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back, color: Colors.black,),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const AppHeader(
                title: 'Step 1 of 3',
                subtitle: AppString.whatIsYourMainIncomeSource,
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children:
                    incomeSources.map((source) {
                      return AppChip(
                        label: source,
                        isSelected: selectedIncomeSource == source,
                        onTap: () {
                          ref
                              .read(selectedIncomeSourceProvider.notifier)
                              .state = source;
                        },
                      );
                    }).toList(),
              ),
              const Spacer(),
              AppButton(
                label: 'Next',
                onPressed: () {
                  selectedIncomeSource != null
                      ? () => Navigator.pushNamed(
                        context,
                        '/onboarding/income-range',
                      )
                      : null;
                },
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () {},
                  child: const Text('Skip for now'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
