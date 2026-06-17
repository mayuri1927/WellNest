import 'package:flutter_test/flutter_test.dart';
import 'package:well_nest/core/utils/responsive.dart';
import 'package:flutter/material.dart';

void main() {
  group('Responsive', () {
    test('isMobile should return true for small screens', () {
      final context = _buildContext(400);
      expect(Responsive.isMobile(context), true);
    });

    test('isTablet should return true for medium screens', () {
      final context = _buildContext(700);
      expect(Responsive.isMobile(context), false);
      expect(Responsive.isTablet(context), true);
    });

    test('isDesktop should return true for large screens', () {
      final context = _buildContext(1000);
      expect(Responsive.isDesktop(context), true);
    });
  });
}

BuildContext _buildContext(double width) {
  return TestBuildContext(
    size: Size(width, 800),
    devicePixelRatio: 1.0,
    padding: EdgeInsets.zero,
    viewInsets: EdgeInsets.zero,
    viewPadding: EdgeInsets.zero,
  );
}

class TestBuildContext implements BuildContext {
  final Size size;
  final double devicePixelRatio;
  final EdgeInsets padding;
  final EdgeInsets viewInsets;
  final EdgeInsets viewPadding;

  TestBuildContext({
    required this.size,
    required this.devicePixelRatio,
    required this.padding,
    required this.viewInsets,
    required this.viewPadding,
  });

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
