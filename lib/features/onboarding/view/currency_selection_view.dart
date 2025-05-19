import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../config/provider/onboarding_state.dart';
import '../../../config/provider/theme_provider.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/utils/responsive_utils.dart';
import '../../../core/widgets/country_picker_dialouge.dart';

class CurrencySelectionView extends ConsumerWidget {
  const CurrencySelectionView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkModeProvider);
    final onboardingState = ref.watch(onboardingStateProvider);
    final selectedCurrency = onboardingState.selectedCurrency;
    final selectedCurrencyIso = onboardingState.selectedCurrencyIso ?? 'BD';

    final textColor = isDark ? AppColors.textLight : AppColors.textDark;

    final String label = selectedCurrency ?? 'BDT';
    final String btnLabel =
        selectedCurrency == null ? 'Select Currency' : 'Change Currency';

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: Padding(
        padding: ResponsiveUtilities.symmetricPadding(context),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shadowColor: Colors.grey[200],
            elevation: 4,
            backgroundColor:
                isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
          ),
          onPressed: () => _showDialog(context),
          child: Row(
            children: [

              // Label Text
              Expanded(
                child: Text(
                  btnLabel,
                  style: TextStyle(
                    fontSize: ResponsiveUtilities.font(context, 16),
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ),
              const SizedBox(width: 6),

              // Country Flag with safe fallback
              CountryFlag.fromCountryCode(
                selectedCurrencyIso.isNotEmpty ? selectedCurrencyIso : 'BD',
                shape: Circle(),
              ),
              const SizedBox(width: 6),
              // Selected Currency
              Text(
                '($label)',
                style: TextStyle(
                  fontSize: ResponsiveUtilities.font(context, 16),
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),

              // Arrow Icon
              IconButton(
                onPressed: () => _showDialog(context),
                icon: Icon(
                  Icons.keyboard_arrow_right,
                  color: textColor,
                  size: ResponsiveUtilities.icon(context, 28),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Show country picker dialog
  Future<void> _showDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => const MyCountryPicker(),
    );
  }
}
