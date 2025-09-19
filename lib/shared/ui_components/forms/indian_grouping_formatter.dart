import 'package:flutter/services.dart';

/// Indian number grouping formatter
class IndianGroupingFormatter extends TextInputFormatter {
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
