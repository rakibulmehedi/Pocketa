import 'package:flutter_test/flutter_test.dart';
import 'package:pocketa/core/forms/base_form_state.dart';

class TestFormNotifier with BaseFormValidation {
  // This class is just for testing the mixin
}

void main() {
  group('BaseFormValidation', () {
    late TestFormNotifier notifier;

    setUp(() {
      notifier = TestFormNotifier();
    });

    group('validateRequired', () {
      test('should return null for valid non-empty string', () {
        final result = notifier.validateRequired('test', 'Field Name');
        expect(result, null);
      });

      test('should return error for null value', () {
        final result = notifier.validateRequired(null, 'Field Name');
        expect(result, 'Field Name is required');
      });

      test('should return error for empty string', () {
        final result = notifier.validateRequired('', 'Field Name');
        expect(result, 'Field Name is required');
      });

      test('should return error for whitespace-only string', () {
        final result = notifier.validateRequired('   ', 'Field Name');
        expect(result, 'Field Name is required');
      });
    });

    group('validateMinLength', () {
      test('should return null for valid length', () {
        final result = notifier.validateMinLength('test', 3, 'Field Name');
        expect(result, null);
      });

      test('should return null for exact minimum length', () {
        final result = notifier.validateMinLength('test', 4, 'Field Name');
        expect(result, null);
      });

      test('should return error for too short string', () {
        final result = notifier.validateMinLength('te', 3, 'Field Name');
        expect(result, 'Field Name must be at least 3 characters');
      });

      test('should return null for null value', () {
        final result = notifier.validateMinLength(null, 3, 'Field Name');
        expect(result, null);
      });
    });

    group('validateMaxLength', () {
      test('should return null for valid length', () {
        final result = notifier.validateMaxLength('test', 10, 'Field Name');
        expect(result, null);
      });

      test('should return null for exact maximum length', () {
        final result = notifier.validateMaxLength('test', 4, 'Field Name');
        expect(result, null);
      });

      test('should return error for too long string', () {
        final result = notifier.validateMaxLength('test', 3, 'Field Name');
        expect(result, 'Field Name must be no more than 3 characters');
      });

      test('should return null for null value', () {
        final result = notifier.validateMaxLength(null, 3, 'Field Name');
        expect(result, null);
      });
    });

    group('validateEmail', () {
      test('should return null for valid email', () {
        final result = notifier.validateEmail('test@example.com');
        expect(result, null);
      });

      test('should return null for null value', () {
        final result = notifier.validateEmail(null);
        expect(result, null);
      });

      test('should return null for empty string', () {
        final result = notifier.validateEmail('');
        expect(result, null);
      });

      test('should return error for invalid email', () {
        final result = notifier.validateEmail('invalid-email');
        expect(result, 'Please enter a valid email address');
      });

      test('should return error for email without domain', () {
        final result = notifier.validateEmail('test@');
        expect(result, 'Please enter a valid email address');
      });

      test('should return error for email without @', () {
        final result = notifier.validateEmail('testexample.com');
        expect(result, 'Please enter a valid email address');
      });
    });

    group('validatePositiveNumber', () {
      test('should return null for valid positive number', () {
        final result = notifier.validatePositiveNumber('42.5', 'Amount');
        expect(result, null);
      });

      test('should return null for null value', () {
        final result = notifier.validatePositiveNumber(null, 'Amount');
        expect(result, null);
      });

      test('should return null for empty string', () {
        final result = notifier.validatePositiveNumber('', 'Amount');
        expect(result, null);
      });

      test('should return error for invalid number', () {
        final result = notifier.validatePositiveNumber('not-a-number', 'Amount');
        expect(result, 'Amount must be a valid number');
      });

      test('should return error for zero', () {
        final result = notifier.validatePositiveNumber('0', 'Amount');
        expect(result, 'Amount must be greater than 0');
      });

      test('should return error for negative number', () {
        final result = notifier.validatePositiveNumber('-5', 'Amount');
        expect(result, 'Amount must be greater than 0');
      });
    });

    group('validateNonNegativeNumber', () {
      test('should return null for valid positive number', () {
        final result = notifier.validateNonNegativeNumber('42.5', 'Amount');
        expect(result, null);
      });

      test('should return null for zero', () {
        final result = notifier.validateNonNegativeNumber('0', 'Amount');
        expect(result, null);
      });

      test('should return null for null value', () {
        final result = notifier.validateNonNegativeNumber(null, 'Amount');
        expect(result, null);
      });

      test('should return null for empty string', () {
        final result = notifier.validateNonNegativeNumber('', 'Amount');
        expect(result, null);
      });

      test('should return error for invalid number', () {
        final result = notifier.validateNonNegativeNumber('not-a-number', 'Amount');
        expect(result, 'Amount must be a valid number');
      });

      test('should return error for negative number', () {
        final result = notifier.validateNonNegativeNumber('-5', 'Amount');
        expect(result, 'Amount must be 0 or greater');
      });
    });

    group('validateUnique', () {
      test('should return null for unique value', () {
        final result = notifier.validateUnique('unique-value', 'Field Name', (value) => true);
        expect(result, null);
      });

      test('should return null for null value', () {
        final result = notifier.validateUnique(null, 'Field Name', (value) => false);
        expect(result, null);
      });

      test('should return null for empty string', () {
        final result = notifier.validateUnique('', 'Field Name', (value) => false);
        expect(result, null);
      });

      test('should return error for non-unique value', () {
        final result = notifier.validateUnique('duplicate-value', 'Field Name', (value) => false);
        expect(result, 'Field Name already exists');
      });
    });
  });
}
