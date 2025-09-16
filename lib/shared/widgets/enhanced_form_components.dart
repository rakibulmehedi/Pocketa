import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pocketa/core/responsive/responsive.dart';
import 'package:pocketa/core/theme/app_colors.dart';
import 'package:pocketa/core/theme/text_styles.dart';
import 'package:pocketa/shared/widgets/input/input.dart';
import 'package:pocketa/shared/widgets/unified_animations.dart';

/// Enhanced form section with consistent styling and validation
class FormSection extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool showDivider;
  final bool required;
  final Widget? trailing;

  const FormSection({
    super.key,
    this.title,
    this.subtitle,
    required this.children,
    this.padding,
    this.margin,
    this.showDivider = true,
    this.required = false,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final layout = context.layout;
    final theme = Theme.of(context);

    return Container(
      margin: margin ?? EdgeInsets.only(bottom: layout.spaceL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    title!,
                    style: AppTextStyles.responsiveTitle(context),
                  ),
                ),
                if (required)
                  Text(
                    ' *',
                    style: AppTextStyles.responsiveTitle(context).copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                if (trailing != null) ...[
                  const SizedBox(width: 8),
                  trailing!,
                ],
              ],
            ),
            if (subtitle != null) ...[
              SizedBox(height: layout.spaceS),
              Text(
                subtitle!,
                style: AppTextStyles.responsiveBody(context),
              ),
            ],
            SizedBox(height: layout.spaceM),
          ],
          ...children,
          if (showDivider) ...[
            SizedBox(height: layout.spaceL),
            Divider(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
              height: 1,
            ),
          ],
        ],
      ),
    );
  }
}

/// Enhanced form field with validation and error handling
class EnhancedFormField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final TextEditingController? controller;
  final String? initialValue;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;
  final int minLines;
  final int? maxLength;
  final bool readOnly;
  final bool enabled;
  final bool autofocus;
  final bool obscureText;
  final bool showCounter;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final String? prefixText;
  final String? suffixText;
  final InputFieldVariant variant;
  final InputFieldSize size;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final void Function(String?)? onSaved;
  final VoidCallback? onTap;
  final VoidCallback? onEditingComplete;
  final bool required;
  final String? Function(String?)? customValidator;

  const EnhancedFormField({
    super.key,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.controller,
    this.initialValue,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.inputFormatters,
    this.maxLines = 1,
    this.minLines = 1,
    this.maxLength,
    this.readOnly = false,
    this.enabled = true,
    this.autofocus = false,
    this.obscureText = false,
    this.showCounter = false,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixText,
    this.suffixText,
    this.variant = InputFieldVariant.outlined,
    this.size = InputFieldSize.medium,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.onSaved,
    this.onTap,
    this.onEditingComplete,
    this.required = false,
    this.customValidator,
  });

  @override
  State<EnhancedFormField> createState() => _EnhancedFormFieldState();
}

class _EnhancedFormFieldState extends State<EnhancedFormField> {
  String? _errorText;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _errorText = widget.errorText;
  }

  @override
  void didUpdateWidget(EnhancedFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.errorText != oldWidget.errorText) {
      _errorText = widget.errorText;
    }
  }

  String? _validate(String? value) {
    if (widget.required && (value == null || value.isEmpty)) {
      return 'This field is required';
    }
    
    if (widget.customValidator != null) {
      return widget.customValidator!(value);
    }
    
    if (widget.validator != null) {
      return widget.validator!(value);
    }
    
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final layout = context.layout;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label with required indicator
        if (widget.label != null) ...[
          Row(
            children: [
              Text(
                widget.label!,
                style: AppTextStyles.responsiveLabel(context),
              ),
              if (widget.required)
                Text(
                  ' *',
                  style: AppTextStyles.responsiveLabel(context).copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
            ],
          ),
          SizedBox(height: layout.spaceS),
        ],
        
        // Form Field
        Focus(
          onFocusChange: (hasFocus) {
            setState(() {
              _isFocused = hasFocus;
            });
          },
          child: AppTextFormField(
            controller: widget.controller,
            initialValue: widget.initialValue,
            label: null, // We handle label separately
            hint: widget.hint,
            helperText: widget.helperText,
            errorText: _errorText,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            inputFormatters: widget.inputFormatters,
            maxLines: widget.maxLines,
            minLines: widget.minLines,
            maxLength: widget.maxLength,
            readOnly: widget.readOnly,
            enabled: widget.enabled,
            autofocus: widget.autofocus,
            obscureText: widget.obscureText,
            showCounter: widget.showCounter,
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.suffixIcon,
            prefixText: widget.prefixText,
            suffixText: widget.suffixText,
            variant: widget.variant,
            size: widget.size,
            validator: _validate,
            onChanged: (value) {
              // Clear error when user starts typing
              if (_errorText != null) {
                setState(() {
                  _errorText = null;
                });
              }
              widget.onChanged?.call(value);
            },
            onFieldSubmitted: widget.onFieldSubmitted,
            onSaved: widget.onSaved,
            onTap: widget.onTap,
            onEditingComplete: widget.onEditingComplete,
          ),
        ),
      ],
    );
  }
}

/// Form field group for related fields
class FormFieldGroup extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool showDivider;
  final Widget? trailing;

  const FormFieldGroup({
    super.key,
    this.title,
    this.subtitle,
    required this.children,
    this.padding,
    this.margin,
    this.showDivider = true,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final layout = context.layout;
    final theme = Theme.of(context);

    return Container(
      margin: margin ?? EdgeInsets.only(bottom: layout.spaceL),
      padding: padding ?? EdgeInsets.all(layout.spaceL),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(layout.radiusM),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    title!,
                    style: AppTextStyles.responsiveTitle(context),
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
            if (subtitle != null) ...[
              SizedBox(height: layout.spaceS),
              Text(
                subtitle!,
                style: AppTextStyles.responsiveBody(context),
              ),
            ],
            SizedBox(height: layout.spaceM),
          ],
          ...children,
          if (showDivider) ...[
            SizedBox(height: layout.spaceL),
            Divider(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
              height: 1,
            ),
          ],
        ],
      ),
    );
  }
}

/// Enhanced dropdown field
class EnhancedDropdownField<T> extends StatelessWidget {
  final String? label;
  final String? hint;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;
  final bool required;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final InputFieldVariant variant;
  final InputFieldSize size;
  final bool enabled;

  const EnhancedDropdownField({
    super.key,
    this.label,
    this.hint,
    this.value,
    required this.items,
    this.onChanged,
    this.validator,
    this.required = false,
    this.prefixIcon,
    this.suffixIcon,
    this.variant = InputFieldVariant.outlined,
    this.size = InputFieldSize.medium,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final layout = context.layout;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label with required indicator
        if (label != null) ...[
          Row(
            children: [
              Text(
                label!,
                style: AppTextStyles.responsiveLabel(context),
              ),
              if (required)
                Text(
                  ' *',
                  style: AppTextStyles.responsiveLabel(context).copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
            ],
          ),
          SizedBox(height: layout.spaceS),
        ],
        
        // Dropdown Field
        AppDropdownField<T>(
          label: hint ?? 'Select option',
          initialValue: value as T,
          items: items,
          onChanged: onChanged!,
          validator: validator,
        ),
      ],
    );
  }
}

/// Form validation helper
class FormValidationHelper {
  static String? required(String? value, {String? message}) {
    if (value == null || value.isEmpty) {
      return message ?? 'This field is required';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.isEmpty) return null;
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static String? minLength(String? value, int minLength) {
    if (value == null || value.isEmpty) return null;
    if (value.length < minLength) {
      return 'Must be at least $minLength characters';
    }
    return null;
  }

  static String? maxLength(String? value, int maxLength) {
    if (value == null || value.isEmpty) return null;
    if (value.length > maxLength) {
      return 'Must be no more than $maxLength characters';
    }
    return null;
  }

  static String? pattern(String? value, RegExp pattern, {String? message}) {
    if (value == null || value.isEmpty) return null;
    if (!pattern.hasMatch(value)) {
      return message ?? 'Invalid format';
    }
    return null;
  }

  static String? number(String? value) {
    if (value == null || value.isEmpty) return null;
    if (double.tryParse(value) == null) {
      return 'Please enter a valid number';
    }
    return null;
  }

  static String? positiveNumber(String? value) {
    if (value == null || value.isEmpty) return null;
    final number = double.tryParse(value);
    if (number == null) {
      return 'Please enter a valid number';
    }
    if (number <= 0) {
      return 'Must be greater than 0';
    }
    return null;
  }
}
