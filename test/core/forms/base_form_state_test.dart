import 'package:flutter_test/flutter_test.dart';
import 'package:pocketa/core/forms/base_form_state.dart';

void main() {
  group('BaseFormState', () {
    test('should create initial state', () {
      final state = BaseFormState.initial();
      
      expect(state.isLoading, false);
      expect(state.isValid, false);
      expect(state.error, null);
      expect(state.fieldErrors, {});
    });

    test('should create state with custom values', () {
      final state = BaseFormState(
        isLoading: true,
        isValid: true,
        error: 'Test error',
        fieldErrors: {'field1': 'Error 1', 'field2': 'Error 2'},
      );
      
      expect(state.isLoading, true);
      expect(state.isValid, true);
      expect(state.error, 'Test error');
      expect(state.fieldErrors, {'field1': 'Error 1', 'field2': 'Error 2'});
    });

    test('should copy with new values', () {
      final state = BaseFormState(
        isLoading: false,
        isValid: false,
        error: 'Old error',
        fieldErrors: {'field1': 'Old error 1'},
      );
      
      final newState = state.copyWith(
        isLoading: true,
        isValid: true,
        error: 'New error',
        fieldErrors: {'field2': 'New error 2'},
      );
      
      expect(newState.isLoading, true);
      expect(newState.isValid, true);
      expect(newState.error, 'New error');
      expect(newState.fieldErrors, {'field2': 'New error 2'});
    });

    test('should copy with partial values', () {
      final state = BaseFormState(
        isLoading: false,
        isValid: false,
        error: 'Old error',
        fieldErrors: {'field1': 'Old error 1'},
      );
      
      final newState = state.copyWith(isLoading: true);
      
      expect(newState.isLoading, true);
      expect(newState.isValid, false); // Unchanged
      expect(newState.error, 'Old error'); // Unchanged
      expect(newState.fieldErrors, {'field1': 'Old error 1'}); // Unchanged
    });

    test('should test equality', () {
      final state1 = BaseFormState(
        isLoading: true,
        isValid: false,
        error: 'Test error',
        fieldErrors: {'field1': 'Error 1'},
      );
      
      final state2 = BaseFormState(
        isLoading: true,
        isValid: false,
        error: 'Test error',
        fieldErrors: {'field1': 'Error 1'},
      );
      
      final state3 = BaseFormState(
        isLoading: false,
        isValid: false,
        error: 'Test error',
        fieldErrors: {'field1': 'Error 1'},
      );
      
      expect(state1, equals(state2));
      expect(state1, isNot(equals(state3)));
    });

    test('should test hashCode', () {
      final state1 = BaseFormState(
        isLoading: true,
        isValid: false,
        error: 'Test error',
        fieldErrors: {'field1': 'Error 1'},
      );
      
      final state2 = BaseFormState(
        isLoading: true,
        isValid: false,
        error: 'Test error',
        fieldErrors: {'field1': 'Error 1'},
      );
      
      expect(state1.hashCode, equals(state2.hashCode));
    });
  });

  group('BaseFormStateX', () {
    test('should check if form has errors', () {
      final stateWithError = BaseFormState(error: 'General error');
      final stateWithFieldErrors = BaseFormState(fieldErrors: {'field1': 'Field error'});
      final stateWithBothErrors = BaseFormState(
        error: 'General error',
        fieldErrors: {'field1': 'Field error'},
      );
      final stateWithoutErrors = BaseFormState();
      
      expect(stateWithError.hasErrors, true);
      expect(stateWithFieldErrors.hasErrors, true);
      expect(stateWithBothErrors.hasErrors, true);
      expect(stateWithoutErrors.hasErrors, false);
    });

    test('should get field error', () {
      final state = BaseFormState(
        fieldErrors: {'field1': 'Error 1', 'field2': 'Error 2'},
      );
      
      expect(state.getFieldError('field1'), 'Error 1');
      expect(state.getFieldError('field2'), 'Error 2');
      expect(state.getFieldError('field3'), null);
    });
  });
}