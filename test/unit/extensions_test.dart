import 'package:flutter_test/flutter_test.dart';
import 'package:well_nest/shared/extensions/extensions.dart';

void main() {
  group('String Extensions', () {
    test('capitalize should capitalize first letter', () {
      expect('hello'.capitalize, 'Hello');
      expect('HELLO'.capitalize, 'HELLO');
      expect(''.capitalize, '');
    });

    test('isValidEmail should validate email correctly', () {
      expect('test@example.com'.isValidEmail, true);
      expect('invalid'.isValidEmail, false);
      expect('test@'.isValidEmail, false);
    });
  });

  group('DateTime Extensions', () {
    test('isToday should return true for today', () {
      final now = DateTime.now();
      expect(now.isToday, true);
    });

    test('formatted should return correct format', () {
      final date = DateTime(2024, 1, 5);
      expect(date.formatted, '5/01/2024');
    });
  });
}
