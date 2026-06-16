import 'package:flutter_test/flutter_test.dart';
import 'package:well_nest/core/utils/date_time_utils.dart';

void main() {
  group('DateTimeUtils', () {
    test('formatDate formats date correctly', () {
      final date = DateTime(2024, 6, 15);
      expect(DateTimeUtils.formatDate(date), 'Jun 15, 2024');
    });

    test('formatTime formats time correctly', () {
      final time = DateTime(2024, 6, 15, 14, 30);
      expect(DateTimeUtils.formatTime(time), '02:30 PM');
    });

    test('formatDateTime formats correctly', () {
      final dateTime = DateTime(2024, 6, 15, 14, 30);
      expect(DateTimeUtils.formatDateTime(dateTime), 'Jun 15, 2024 02:30 PM');
    });

    test('isSameDay returns true for same day', () {
      final date1 = DateTime(2024, 6, 15, 10, 0);
      final date2 = DateTime(2024, 6, 15, 20, 0);
      expect(DateTimeUtils.isSameDay(date1, date2), true);
    });

    test('isSameDay returns false for different days', () {
      final date1 = DateTime(2024, 6, 15);
      final date2 = DateTime(2024, 6, 16);
      expect(DateTimeUtils.isSameDay(date1, date2), false);
    });

    test('startOfDay returns midnight', () {
      final date = DateTime(2024, 6, 15, 14, 30, 45);
      final start = DateTimeUtils.startOfDay(date);
      expect(start, DateTime(2024, 6, 15, 0, 0, 0));
    });

    test('endOfDay returns 23:59:59', () {
      final date = DateTime(2024, 6, 15, 14, 30, 45);
      final end = DateTimeUtils.endOfDay(date);
      expect(end, DateTime(2024, 6, 15, 23, 59, 59));
    });
  });
}
