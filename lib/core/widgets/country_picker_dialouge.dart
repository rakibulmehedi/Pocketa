import 'package:country_currency_pickers/country.dart';
import 'package:country_currency_pickers/country_picker_dialog.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/provider/onboarding_state.dart';
import '../../config/provider/theme_provider.dart';
import '../../features/onboarding/data/currency_data.dart';
import '../themes/app_colors.dart';
import '../utils/responsive_utils.dart';

class MyCountryPicker extends ConsumerWidget {
  const MyCountryPicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkModeProvider);

    return CountryPickerDialog(
      titlePadding: ResponsiveUtilities.symmetricPadding(context),
      searchInputDecoration: const InputDecoration(
        hintText: 'Search...',
        suffixIcon: Icon(Icons.search),
      ),
      isSearchable: true,
      title: const Text(
        'Select your currency',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
      ),
      onValuePicked: (Country country) {
        final currency = country.currencyCode ?? 'BDT';
        final isoCode = country.iso3Code ?? 'BGD';

        ref.read(onboardingStateProvider.notifier).setCurrency(currency);
        ref.read(onboardingStateProvider.notifier).setCurrencyIsoCode(isoCode);

      },
      itemBuilder: (Country country) {
        final countryName = country.name ?? 'Unknown Country';
        final currencyCode = country.currencyCode ?? 'BDT';
        final isoCode = country.iso3Code ?? 'BGD';
        final symbol = getCurrencySymbol(currencyCode);

        return Card(
          color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
          child: ListTile(
            leading: _leading(isoCode),
            title: Text(countryName),
            trailing: _trailing(symbol, context),
            selectedColor: AppColors.primary,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              side: BorderSide(
                color: Colors.grey,
                width: 1,
                style: BorderStyle.solid,
              ),
            ),
          ),
        );
      },
    );
  }

  /// Country flag
  CircleAvatar _leading(String iso3Code) {
    return CircleAvatar(
      backgroundColor: Colors.grey[200],
      foregroundColor: AppColors.primary,
      child: CountryFlag.fromCountryCode(iso3Code, shape: Circle()),
    );
  }

  /// Currency symbol
  Widget _trailing(String currencySymbol, BuildContext context) {
    return Text(
      currencySymbol,
      style: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: ResponsiveUtilities.font(context, 18),
      ),
    );
  }
}
