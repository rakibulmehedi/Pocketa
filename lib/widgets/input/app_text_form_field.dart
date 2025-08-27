import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? initialValue;
  final String label;
  final IconData? prefixIcon;
  final Widget? suffix;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;
  final int minLines;
  final bool readOnly;
  final bool enabled;
  final bool autofocus;
  final String? helperText;
  final String? hintText;

  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final VoidCallback? onTap;

  const AppTextFormField({
    super.key,
    required this.label,
    this.controller,
    this.initialValue,
    this.prefixIcon,
    this.suffix,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.inputFormatters,
    this.maxLines = 1,
    this.minLines = 1,
    this.readOnly = false,
    this.enabled = true,
    this.autofocus = false,
    this.helperText,
    this.hintText,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.onTap,
  }) : assert(
         controller == null || initialValue == null,
         'Use either controller or initialValue',
       );

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: controller == null ? initialValue : null,
      readOnly: readOnly,
      enabled: enabled,
      autofocus: autofocus,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      minLines: minLines,
      onTap: onTap,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        helperText: helperText,
        prefixIcon: prefixIcon == null ? null : Icon(prefixIcon),
        suffixIcon: suffix,
      ),
    );
  }
}
