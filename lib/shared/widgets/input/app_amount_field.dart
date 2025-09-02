// app_amount_field.dart
import 'package:flutter/material.dart';
import 'package:pocketa/l10n/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:pocketa/shared/widgets/input/app_text_form_field.dart';

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
        _IndianGroupingFormatter(),
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

class _IndianGroupingFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final raw = newValue.text.replaceAll(',', '');
    if (raw.isEmpty) return newValue;

    final selectionIndexFromRight =
        newValue.text.length - newValue.selection.end;

    final parts = raw.split('.');
    final String intPart = parts[0];
    final fracPart = parts.length > 1 ? parts[1] : null;

    final buf = StringBuffer();
    if (intPart.length > 3) {
      final head = intPart.substring(0, intPart.length - 3);
      final tail = intPart.substring(intPart.length - 3);
      final headGroups = <String>[];
      for (int i = head.length; i > 0; i -= 2) {
        final start = (i - 2) < 0 ? 0 : i - 2;
        headGroups.insert(0, head.substring(start, i));
      }
      buf.write(headGroups.join(','));
      buf.write(',');
      buf.write(tail);
    } else {
      buf.write(intPart);
    }
    if (fracPart != null && fracPart.isNotEmpty) {
      buf.write('.');
      buf.write(fracPart);
    }

    final formatted = buf.toString();

    final newSelection = TextSelection.fromPosition(
      TextPosition(offset: formatted.length - selectionIndexFromRight),
    );
    return TextEditingValue(text: formatted, selection: newSelection);
  }
}
