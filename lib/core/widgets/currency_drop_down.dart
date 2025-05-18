// lib/core/component/currency_dropdown.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/core/utils/responsive_utils.dart';
import 'package:pocketa/config/provider/onboarding_state.dart';

import '../../config/provider/providers.dart';

class CurrencyDropdown extends ConsumerWidget {
  const CurrencyDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currencies = ['৳ BDT', '\$ USD', '₹ INR', '€ EUR', '¥ JPY'];
    final onboardingState = ref.watch(onboardingStateProvider);
    final selectedCurrency = onboardingState.selectedCurrency;

    return DropdownButtonFormField<String>(
      value: selectedCurrency,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: 'Currency',
        labelStyle: Theme.of(context).textTheme.bodyMedium,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: EdgeInsets.symmetric(
          horizontal: ResponsiveUtilities.width(context, 0.04),
          vertical: ResponsiveUtilities.height(context, 0.02),
        ),
      ),
      items:
          currencies.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            );
          }).toList(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          ref.read(onboardingStateProvider.notifier).setCurrency(newValue);
        }
      },
    );
  }
}
