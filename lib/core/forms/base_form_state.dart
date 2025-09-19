/// Base form state with common fields and behavior
class BaseFormState {
  final bool isLoading;
  final bool isValid;
  final String? error;
  final Map<String, String> fieldErrors;

  const BaseFormState({
    this.isLoading = false,
    this.isValid = false,
    this.error,
    this.fieldErrors = const {},
  });

  factory BaseFormState.initial() => const BaseFormState();

  BaseFormState copyWith({
    bool? isLoading,
    bool? isValid,
    String? error,
    Map<String, String>? fieldErrors,
  }) {
    return BaseFormState(
      isLoading: isLoading ?? this.isLoading,
      isValid: isValid ?? this.isValid,
      error: error ?? this.error,
      fieldErrors: fieldErrors ?? this.fieldErrors,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BaseFormState &&
        other.isLoading == isLoading &&
        other.isValid == isValid &&
        other.error == error &&
        other.fieldErrors == fieldErrors;
  }

  @override
  int get hashCode {
    return isLoading.hashCode ^
        isValid.hashCode ^
        error.hashCode ^
        fieldErrors.hashCode;
  }
}

/// Base form state extensions
extension BaseFormStateX on BaseFormState {
  /// Check if form has any errors
  bool get hasErrors => error != null || fieldErrors.isNotEmpty;

  /// Get error for specific field
  String? getFieldError(String fieldName) => fieldErrors[fieldName];

  /// Check if specific field has error
  bool hasFieldError(String fieldName) => fieldErrors.containsKey(fieldName);

  /// Get all field errors as a single message
  String get allFieldErrors => fieldErrors.values.join('\n');
}

/// Base form validation mixin
mixin BaseFormValidation {
  /// Validate required field
  String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validate minimum length
  String? validateMinLength(String? value, int minLength, String fieldName) {
    if (value == null || value.trim().length < minLength) {
      return '$fieldName must be at least $minLength characters';
    }
    return null;
  }

  /// Validate maximum length
  String? validateMaxLength(String? value, int maxLength, String fieldName) {
    if (value != null && value.trim().length > maxLength) {
      return '$fieldName must be no more than $maxLength characters';
    }
    return null;
  }

  /// Validate email format
  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  /// Validate positive number
  String? validatePositiveNumber(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) return null;
    final number = double.tryParse(value.trim());
    if (number == null) {
      return '$fieldName must be a valid number';
    }
    if (number <= 0) {
      return '$fieldName must be greater than 0';
    }
    return null;
  }

  /// Validate non-negative number
  String? validateNonNegativeNumber(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) return null;
    final number = double.tryParse(value.trim());
    if (number == null) {
      return '$fieldName must be a valid number';
    }
    if (number < 0) {
      return '$fieldName must be 0 or greater';
    }
    return null;
  }

  /// Validate unique value
  String? validateUnique(
    String? value,
    String fieldName,
    bool Function(String) isUnique,
  ) {
    if (value == null || value.trim().isEmpty) return null;
    if (!isUnique(value.trim())) {
      return '$fieldName already exists';
    }
    return null;
  }
}
