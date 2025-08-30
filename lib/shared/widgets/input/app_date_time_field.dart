import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pocketa/shared/widgets/input/app_text_form_field.dart';

class AppDateTimeField extends StatelessWidget {
  final String label;
  final DateTime valueUtc;
  final ValueChanged<DateTime> onChanged; // returns UTC
  final IconData prefixIcon;
  final bool enable;

  const AppDateTimeField({
    super.key,
    required this.label,
    required this.valueUtc,
    required this.onChanged,
    this.prefixIcon = Icons.event_outlined,
    this.enable = true,
  });

  Future<void> _pick(BuildContext context) async {
    final initialLocal = valueUtc.toLocal();
    final date = await showDatePicker(
      context: context,
      initialDate: initialLocal,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date == null) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialLocal),
    );
    if (time == null) return;
    final combined = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    onChanged(combined.toUtc());
  }

  @override
  Widget build(BuildContext context) {
    final labelText = DateFormat(
      'EEE, dd MMM yyyy • hh:mm a',
    ).format(valueUtc.toLocal());
    return AppTextFormField(
      label: label,
      initialValue: labelText,
      readOnly: true,
      prefixIcon: prefixIcon,
      onTap: () => _pick(context),
      enabled: enable,
      validator: (_) => null, // date usually always valid
    );
  }
}
