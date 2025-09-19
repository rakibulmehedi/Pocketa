import 'package:flutter/material.dart';

/// Dropdown field with consistent styling
class AppDropdownField<T> extends StatelessWidget {
  final String label;
  final T initialValue;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final String? Function(T?)? validator;
  final IconData? prefixIcon;
  final bool isDense;

  const AppDropdownField({
    super.key,
    required this.label,
    required this.initialValue,
    required this.items,
    required this.onChanged,
    this.validator,
    this.prefixIcon,
    this.isDense = false,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: initialValue,
      items: items,
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: prefixIcon == null ? null : Icon(prefixIcon),
        isDense: isDense,
      ),
    );
  }
}
