import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pocketa/widgets/input/app_text_form_field.dart';

class AmountField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? currencySymbol;

  const AmountField({
    super.key,
    required this.controller,
    this.label = 'Amount',
    this.currencySymbol,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextFormField(
      controller: controller,
      label: label,
      hintText: '0.00',
      prefixIcon: Icons.numbers,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
      ],
      suffix: currencySymbol == null
          ? null
          : Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Center(
                child: Text(
                  currencySymbol!,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
      validator: (v) {
        if (v == null || v.trim().isEmpty) return 'Required';
        final d = double.tryParse(v);
        if (d == null || d <= 0) return 'Enter a valid amount';
        return null;
      },
    );
  }
}
