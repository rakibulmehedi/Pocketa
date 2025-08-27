import 'package:flutter/material.dart';

/// 1) Breakpoints (Material 3 guideline-ish)
class AppBreakpoints {
  static const double phone = 0; // up to < 600
  static const double tablet = 600; // up to < 1024
  static const double desktop = 1024; // 1024+
}

/// 2) Device class from width
enum DeviceSizeClass { phone, tablet, desktop }

DeviceSizeClass deviceClassOf(double width) {
  if (width >= AppBreakpoints.desktop) return DeviceSizeClass.desktop;
  if (width >= AppBreakpoints.tablet) return DeviceSizeClass.tablet;
  return DeviceSizeClass.phone;
}

/// 3) Spacing scale (8pt base)
class Gaps {
  static const s2 = SizedBox(height: 2, width: 2);
  static const s4 = SizedBox(height: 4, width: 4);
  static const s8 = SizedBox(height: 8, width: 8);
  static const s12 = SizedBox(height: 12, width: 12);
  static const s16 = SizedBox(height: 16, width: 16);
  static const s20 = SizedBox(height: 20, width: 20);
  static const s24 = SizedBox(height: 24, width: 24);
  static const s32 = SizedBox(height: 32, width: 32);
  static const s40 = SizedBox(height: 40, width: 40);
}

/// 4) Context extensions
extension ContextX on BuildContext {
  MediaQueryData get mq => MediaQuery.of(this);
  double get width => mq.size.width;
  double get height => mq.size.height;
  DeviceSizeClass get sizeClass => deviceClassOf(width);

  /// Adaptive horizontal padding
  EdgeInsets get screenPadding {
    switch (sizeClass) {
      case DeviceSizeClass.desktop:
        return const EdgeInsets.symmetric(horizontal: 56, vertical: 16);
      case DeviceSizeClass.tablet:
        return const EdgeInsets.symmetric(horizontal: 32, vertical: 12);
      case DeviceSizeClass.phone:
      default:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
    }
  }

  /// Adaptive card maxWidth (centers content on wide screens)
  double get maxSheetWidth {
    switch (sizeClass) {
      case DeviceSizeClass.desktop:
        return 1000;
      case DeviceSizeClass.tablet:
        return 720;
      case DeviceSizeClass.phone:
      default:
        return double.infinity;
    }
  }

  /// Adaptive column count (e.g., forms/grids)
  int get columns {
    switch (sizeClass) {
      case DeviceSizeClass.desktop:
        return 3;
      case DeviceSizeClass.tablet:
        return 2;
      case DeviceSizeClass.phone:
      default:
        return 1;
    }
  }
}

/// 5) A wrapper that centers content & applies max width + padding
class ResponsiveConstrained extends StatelessWidget {
  final Widget child;
  const ResponsiveConstrained({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.screenPadding,
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: context.maxSheetWidth),
          child: child,
        ),
      ),
    );
  }
}
