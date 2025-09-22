import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow/core/forms/base_form_state.dart';

/// Base form notifier with common form handling logic
abstract class BaseFormNotifier<T> extends StateNotifier<T> with BaseFormValidation {
  BaseFormNotifier(super.initialState);

  /// Set loading state
  void setLoading(bool loading) {
    if (mounted) {
      state = updateLoadingState(state, loading);
    }
  }

  /// Set error state
  void setError(String? error) {
    if (mounted) {
      state = updateErrorState(state, error);
    }
  }

  /// Set field error
  void setFieldError(String fieldName, String? error) {
    if (mounted) {
      state = updateFieldErrorState(state, fieldName, error);
    }
  }

  /// Clear all errors
  void clearErrors() {
    if (mounted) {
      state = clearErrorState(state);
    }
  }

  /// Clear field error
  void clearFieldError(String fieldName) {
    if (mounted) {
      state = clearFieldErrorState(state, fieldName);
    }
  }

  /// Validate form and update state
  bool validateForm(Map<String, String? Function()> validators) {
    clearErrors();
    bool isValid = true;
    Map<String, String> fieldErrors = {};

    for (final entry in validators.entries) {
      final error = entry.value();
      if (error != null) {
        fieldErrors[entry.key] = error;
        isValid = false;
      }
    }

    if (mounted) {
      state = updateValidationState(state, isValid, fieldErrors);
    }

    return isValid;
  }

  /// Handle form submission with validation
  Future<void> handleSubmit(
    Map<String, String? Function()> validators,
    Future<void> Function() onSubmit,
  ) async {
    if (!validateForm(validators)) return;

    setLoading(true);
    try {
      await onSubmit();
      setLoading(false);
    } catch (error) {
      setLoading(false);
      setError(error.toString());
    }
  }

  // Abstract methods to be implemented by concrete form notifiers
  T updateLoadingState(T state, bool loading);
  T updateErrorState(T state, String? error);
  T updateFieldErrorState(T state, String fieldName, String? error);
  T clearErrorState(T state);
  T clearFieldErrorState(T state, String fieldName);
  T updateValidationState(T state, bool isValid, Map<String, String> fieldErrors);
}

/// Base form notifier for simple forms
class SimpleFormNotifier extends BaseFormNotifier<BaseFormState> {
  SimpleFormNotifier() : super(BaseFormState.initial());

  @override
  BaseFormState updateLoadingState(BaseFormState state, bool loading) {
    return state.copyWith(isLoading: loading);
  }

  @override
  BaseFormState updateErrorState(BaseFormState state, String? error) {
    return state.copyWith(error: error);
  }

  @override
  BaseFormState updateFieldErrorState(BaseFormState state, String fieldName, String? error) {
    final fieldErrors = Map<String, String>.from(state.fieldErrors);
    if (error == null) {
      fieldErrors.remove(fieldName);
    } else {
      fieldErrors[fieldName] = error;
    }
    return state.copyWith(fieldErrors: fieldErrors);
  }

  @override
  BaseFormState clearErrorState(BaseFormState state) {
    return state.copyWith(error: null, fieldErrors: {});
  }

  @override
  BaseFormState clearFieldErrorState(BaseFormState state, String fieldName) {
    final fieldErrors = Map<String, String>.from(state.fieldErrors);
    fieldErrors.remove(fieldName);
    return state.copyWith(fieldErrors: fieldErrors);
  }

  @override
  BaseFormState updateValidationState(BaseFormState state, bool isValid, Map<String, String> fieldErrors) {
    return state.copyWith(isValid: isValid, fieldErrors: fieldErrors);
  }
}

/// Provider for simple form notifier
final simpleFormProvider = StateNotifierProvider<SimpleFormNotifier, BaseFormState>(
  (ref) => SimpleFormNotifier(),
);
