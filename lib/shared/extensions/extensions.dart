import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  double get screenWidth => mediaQuery.size.width;
  double get screenHeight => mediaQuery.size.height;
  EdgeInsets get padding => mediaQuery.padding;
  bool get isDarkMode => theme.brightness == Brightness.dark;
}

extension StringExtensions on String {
  String get capitalize => isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
  String get capitalizeWords => split(' ').map((w) => w.capitalize).join(' ');
  bool get isValidEmail => RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
  bool get isValidPhone => RegExp(r'^\+?[1-9]\d{1,14}$').hasMatch(this);
}

extension DateTimeExtensions on DateTime {
  String get formatted => '$day/${month.toString().padLeft(2, '0')}/$year';
  String get timeFormatted => '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  String get fullFormatted => '$formatted $timeFormatted';
  bool get isToday => DateTime.now().year == year && DateTime.now().month == month && DateTime.now().day == day;
  bool get isTomorrow => DateTime.now().year == year && DateTime.now().month == month && DateTime.now().day == day + 1;
  bool get isYesterday => DateTime.now().year == year && DateTime.now().month == month && DateTime.now().day == day - 1;
  DateTime get startOfDay => DateTime(year, month, day);
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59);
  DateTime get startOfWeek => subtract(Duration(days: weekday - 1)).startOfDay;
  DateTime get endOfWeek => add(Duration(days: 7 - weekday)).endOfDay;
  DateTime get startOfMonth => DateTime(year, month, 1);
  DateTime get endOfMonth => DateTime(year, month + 1, 0, 23, 59, 59);
}

extension NumExtensions on num {
  Duration get seconds => Duration(seconds: toInt());
  Duration get minutes => Duration(minutes: toInt());
  Duration get hours => Duration(hours: toInt());
  Duration get days => Duration(days: toInt());
}

extension ListExtensions<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
  T? get lastOrNull => isEmpty ? null : last;
  T? elementAtOrNull(int index) => index < length ? this[index] : null;
}
