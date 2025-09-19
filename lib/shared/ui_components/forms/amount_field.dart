import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pocketa/l10n/app_localizations.dart';
import 'app_text_form_field.dart';
import 'indian_grouping_formatter.dart';

/// Amount input field with currency formatting
class AmountField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? currencySymbol;
  final ValueChanged<String>? onChanged;

  const AmountField({
    super.key,
    required this.controller,
    this.label = 'Amount',
    this.currencySymbol,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextFormField(
      controller: controller,
      label: label,
      hintText: AppLocalizations.of(context).amountHint,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[\d,\.]')),
        IndianGroupingFormatter(),
      ],
      prefixText: currencySymbol == null ? null : '${currencySymbol!} ',
      prefixStyle: const TextStyle(fontWeight: FontWeight.w600),
      validator: (v) {
        if (v == null || v.trim().isEmpty) return 'Required';

        final clean = v.replaceAll(',', '');

        final d = double.tryParse(clean);
        if (d == null || d <= 0) {
          return AppLocalizations.of(context).errorAmountPositive;
        }
        return null;
      },
    );
  }
}
