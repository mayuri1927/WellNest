import 'package:flutter_test/flutter_test.dart';
import 'package:well_nest/core/errors/failures.dart';

void main() {
  group('Failure', () {
    test('ServerFailure has correct message', () {
      const failure = ServerFailure(message: 'Server error');
      expect(failure.message, 'Server error');
    });

    test('CacheFailure has correct message', () {
      const failure = CacheFailure(message: 'Cache error');
      expect(failure.message, 'Cache error');
    });

    test('NetworkFailure has correct message', () {
      const failure = NetworkFailure(message: 'Network error');
      expect(failure.message, 'Network error');
    });

    test('AuthFailure has correct message', () {
      const failure = AuthFailure(message: 'Auth error');
      expect(failure.message, 'Auth error');
    });

    test('ValidationFailure has correct message', () {
      const failure = ValidationFailure(message: 'Validation error');
      expect(failure.message, 'Validation error');
    });

    test('failures with same props are equal', () {
      const failure1 = ServerFailure(message: 'Error', code: 500);
      const failure2 = ServerFailure(message: 'Error', code: 500);
      expect(failure1, failure2);
    });
  });
}
