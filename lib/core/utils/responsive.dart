import 'package:flutter/material.dart';

class Responsive {
  Responsive._();

  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobileBreakpoint;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= mobileBreakpoint &&
      MediaQuery.of(context).size.width < tabletBreakpoint;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= tabletBreakpoint;

  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static T value<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop(context)) return desktop ?? tablet ?? mobile;
    if (isTablet(context)) return tablet ?? mobile;
    return mobile;
  }

  static EdgeInsets padding(BuildContext context) => value(
        context,
        mobile: const EdgeInsets.all(16),
        tablet: const EdgeInsets.all(24),
        desktop: const EdgeInsets.all(32),
      );

  static double gridCrossAxisCount(BuildContext context) => value(
        context,
        mobile: 1,
        tablet: 2,
        desktop: 3,
      );

  static double cardWidth(BuildContext context) {
    final width = screenWidth(context);
    if (width >= desktopBreakpoint) return 400;
    if (width >= tabletBreakpoint) return 350;
    return width - 32;
  }
}

class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, ScreenSize size) builder;

  const ResponsiveBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = _getScreenSize(constraints.maxWidth);
        return builder(context, size);
      },
    );
  }

  ScreenSize _getScreenSize(double width) {
    if (width >= DesktopBreakpoint.desktop) return ScreenSize.desktop;
    if (width >= DesktopBreakpoint.tablet) return ScreenSize.tablet;
    return ScreenSize.mobile;
  }
}

enum ScreenSize { mobile, tablet, desktop }

class DesktopBreakpoint {
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
}

class Spacing {
  Spacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
}

class Radii {
  Radii._();

  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double full = 999;
}
