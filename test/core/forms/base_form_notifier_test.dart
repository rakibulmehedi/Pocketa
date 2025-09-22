import 'package:flutter_test/flutter_test.dart';
import 'package:flow/core/forms/base_form_notifier.dart';
import 'package:flow/core/forms/base_form_state.dart';

// Test implementation of BaseFormNotifier
class TestFormNotifier extends BaseFormNotifier<TestFormState> {
  TestFormNotifier() : super(TestFormState.initial());

  @override
  TestFormState updateLoadingState(TestFormState state, bool loading) {
    return state.copyWith(isLoading: loading);
  }

  @override
  TestFormState updateErrorState(TestFormState state, String? error) {
    return state.copyWith(error: error);
  }

  @override
  TestFormState updateFieldErrorState(TestFormState state, String fieldName, String? error) {
    final newFieldErrors = Map<String, String>.from(state.fieldErrors);
    if (error == null) {
      newFieldErrors.remove(fieldName);
    } else {
      newFieldErrors[fieldName] = error;
    }
    return state.copyWith(fieldErrors: newFieldErrors);
  }

  @override
  TestFormState clearErrorState(TestFormState state) {
    return state.copyWith(error: null, fieldErrors: {});
  }

  @override
  TestFormState clearFieldErrorState(TestFormState state, String fieldName) {
    final newFieldErrors = Map<String, String>.from(state.fieldErrors);
    newFieldErrors.remove(fieldName);
    return state.copyWith(fieldErrors: newFieldErrors);
  }

  @override
  TestFormState updateValidationState(TestFormState state, bool isValid, Map<String, String> fieldErrors) {
    return state.copyWith(isValid: isValid, fieldErrors: fieldErrors);
  }

  // Add the setValidation method that's being called in tests
  void setValidation({required bool isValid, Map<String, String> fieldErrors = const {}}) {
    state = updateValidationState(state, isValid, fieldErrors);
  }
}

// Test form state
class TestFormState extends BaseFormState {
  TestFormState({
    super.isLoading,
    super.isValid,
    super.error,
    super.fieldErrors,
  });

  factory TestFormState.initial() => TestFormState();

  @override
  TestFormState copyWith({
    bool? isLoading,
    bool? isValid,
    String? error,
    Map<String, String>? fieldErrors,
  }) {
    return TestFormState(
      isLoading: isLoading ?? this.isLoading,
      isValid: isValid ?? this.isValid,
      error: error ?? this.error,
      fieldErrors: fieldErrors ?? this.fieldErrors,
    );
  }
}

void main() {
  group('BaseFormNotifier', () {
    late TestFormNotifier notifier;

    setUp(() {
      notifier = TestFormNotifier();
    });

    test('should set loading state', () {
      expect(notifier.state.isLoading, false);
      
      notifier.setLoading(true);
      expect(notifier.state.isLoading, true);
      
      notifier.setLoading(false);
      expect(notifier.state.isLoading, false);
    });

    test('should set error state', () {
      expect(notifier.state.error, null);
      
      notifier.setError('Test error');
      expect(notifier.state.error, 'Test error');
      
      notifier.setError(null);
      expect(notifier.state.error, null);
    });

    test('should set field error state', () {
      expect(notifier.state.fieldErrors, {});
      
      notifier.setFieldError('field1', 'Field error 1');
      expect(notifier.state.fieldErrors, {'field1': 'Field error 1'});
      
      notifier.setFieldError('field2', 'Field error 2');
      expect(notifier.state.fieldErrors, {
        'field1': 'Field error 1',
        'field2': 'Field error 2',
      });
      
      notifier.setFieldError('field1', null);
      expect(notifier.state.fieldErrors, {'field2': 'Field error 2'});
    });

    test('should clear all errors', () {
      notifier.setError('General error');
      notifier.setFieldError('field1', 'Field error 1');
      notifier.setFieldError('field2', 'Field error 2');
      
      expect(notifier.state.error, 'General error');
      expect(notifier.state.fieldErrors, {
        'field1': 'Field error 1',
        'field2': 'Field error 2',
      });
      
      notifier.clearErrors();
      
      expect(notifier.state.error, null);
      expect(notifier.state.fieldErrors, {});
    });

    test('should clear specific field error', () {
      notifier.setFieldError('field1', 'Field error 1');
      notifier.setFieldError('field2', 'Field error 2');
      
      expect(notifier.state.fieldErrors, {
        'field1': 'Field error 1',
        'field2': 'Field error 2',
      });
      
      notifier.clearFieldError('field1');
      
      expect(notifier.state.fieldErrors, {'field2': 'Field error 2'});
    });

    test('should set validation state', () {
      expect(notifier.state.isValid, false);
      expect(notifier.state.fieldErrors, {});
      
      notifier.setValidation(
        isValid: true,
        fieldErrors: {'field1': 'Error 1', 'field2': 'Error 2'},
      );
      
      expect(notifier.state.isValid, true);
      expect(notifier.state.fieldErrors, {
        'field1': 'Error 1',
        'field2': 'Error 2',
      });
    });

    test('should handle multiple state changes', () {
      notifier.setLoading(true);
      notifier.setError('Loading error');
      notifier.setFieldError('field1', 'Field error');
      
      expect(notifier.state.isLoading, true);
      expect(notifier.state.error, 'Loading error');
      expect(notifier.state.fieldErrors, {'field1': 'Field error'});
      
      notifier.setValidation(isValid: true, fieldErrors: {});
      
      expect(notifier.state.isValid, true);
      expect(notifier.state.fieldErrors, {});
      expect(notifier.state.error, 'Loading error'); // Should remain
    });
  });
}
