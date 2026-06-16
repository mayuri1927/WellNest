import 'package:flutter_test/flutter_test.dart';
import 'package:well_nest/core/utils/validators.dart';

void main() {
  group('Validators', () {
    group('email', () {
      test('returns error when email is empty', () {
        expect(Validators.email(''), 'Email is required');
      });

      test('returns error when email is null', () {
        expect(Validators.email(null), 'Email is required');
      });

      test('returns error when email is invalid', () {
        expect(Validators.email('invalid'), 'Please enter a valid email');
      });

      test('returns null for valid email', () {
        expect(Validators.email('test@example.com'), null);
      });
    });

    group('password', () {
      test('returns error when password is empty', () {
        expect(Validators.password(''), 'Password is required');
      });

      test('returns error when password is too short', () {
        expect(Validators.password('abc'), 'Password must be at least 8 characters');
      });

      test('returns error when password lacks uppercase', () {
        expect(Validators.password('abcdefgh1'), 
            'Password must contain at least one uppercase letter');
      });

      test('returns error when password lacks lowercase', () {
        expect(Validators.password('ABCDEFGH1'), 
            'Password must contain at least one lowercase letter');
      });

      test('returns error when password lacks number', () {
        expect(Validators.password('Abcdefgh'), 
            'Password must contain at least one number');
      });

      test('returns null for valid password', () {
        expect(Validators.password('Abcdefgh1'), null);
      });
    });

    group('required', () {
      test('returns error when value is empty', () {
        expect(Validators.required(''), 'This field is required');
      });

      test('returns error when value is null', () {
        expect(Validators.required(null), 'This field is required');
      });

      test('returns null for valid value', () {
        expect(Validators.required('test'), null);
      });

      test('returns custom field name in error message', () {
        expect(Validators.required('', 'Name'), 'Name is required');
      });
    });

    group('numeric', () {
      test('returns error when value is empty', () {
        expect(Validators.numeric(''), 'This field is required');
      });

      test('returns error when value is not a number', () {
        expect(Validators.numeric('abc'), 'Please enter a valid number');
      });

      test('returns null for valid number', () {
        expect(Validators.numeric('123'), null);
      });

      test('returns null for decimal number', () {
        expect(Validators.numeric('123.45'), null);
      });
    });

    group('positiveNumber', () {
      test('returns error when value is empty', () {
        expect(Validators.positiveNumber(''), 'This field is required');
      });

      test('returns error when value is zero', () {
        expect(Validators.positiveNumber('0'), 'Please enter a positive number');
      });

      test('returns error when value is negative', () {
        expect(Validators.positiveNumber('-5'), 'Please enter a positive number');
      });

      test('returns null for positive number', () {
        expect(Validators.positiveNumber('5'), null);
      });
    });
  });
}
