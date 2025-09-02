
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum AppBreakpoint { compact, mobile, tablet, desktop }

/// Design reference (base canvas). We scale *toward* this.
const _designWidth = 390.0; // iPhone 12-ish width
const _designHeight = 844.0; // unused for scale, kept for reference

class _ResponsiveScope extends InheritedWidget {
  final AppSize size;
  const _ResponsiveScope({required this.size, required super.child});
  @override
  bool updateShouldNotify(_ResponsiveScope old) => old.size != size;
}

/// Wrap the whole app:
/// MaterialApp.builder: (context, child) => Responsive(child: child!)
class Responsive extends StatelessWidget {
  final Widget child;

  /// If true, honors device Text Scale; we still clamp to sane bounds.
  final bool respectSystemTextScale;

  /// Clamp text scale between these bounds after applying uiScale.
  final double minTextScale;
  final double maxTextScale;

  /// Optional per-platform scale tweak (e.g., smaller on web desktop).
  final double? platformUiScaleOverride;

  const Responsive({
    super.key,
    required this.child,
    this.respectSystemTextScale = true,
    this.minTextScale = 0.85,
    this.maxTextScale = 1.30,
    this.platformUiScaleOverride,
  });

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final w = mq.size.width;
    final h = mq.size.height;
    final shortestSide = math.max(320.0, math.min(w, h)); // avoid ultra tiny
    final orientation = mq.orientation;

    // Orientation-aware breakpoint: use shortestSide for categorization
    final bp = shortestSide >= 1024
        ? AppBreakpoint.desktop
        : shortestSide >= 700 // a bit earlier to favor tablet UI
            ? AppBreakpoint.tablet
            : shortestSide >= 360
                ? AppBreakpoint.mobile
                : AppBreakpoint.compact;

    // Width-driven scale toward our design width.
    final double baseScale = (w / _designWidth).clamp(0.84, 1.42);

    // Subtle boost by breakpoint so tablet/desktop don’t feel cramped.
    final bpBoost = switch (bp) {
      AppBreakpoint.compact => 0.96,
      AppBreakpoint.mobile => 1.00,
      AppBreakpoint.tablet => 1.08,
      AppBreakpoint.desktop => 1.12,
    };

    // Optional per-platform override.
    final platformBoost = platformUiScaleOverride ??
        (kIsWeb ? (bp == AppBreakpoint.desktop ? 0.98 : 1.0) : 1.0);

    // Final scale for paddings/icons/radius.
    final uiScale = baseScale * bpBoost * platformBoost;

    // Text scale: respect accessibility + our uiScale, then clamp.
    final rawTextScale =
        // ignore: deprecated_member_use
        (respectSystemTextScale ? mq.textScaleFactor : 1.0) * uiScale;
    final textScale = rawTextScale.clamp(minTextScale, maxTextScale);

    final size = AppSize._(
      bp: bp,
      width: w,
      height: h,
      uiScale: uiScale,
      textScale: textScale,
      devicePixelRatio: mq.devicePixelRatio,
      safeTop: mq.padding.top,
      safeBottom: mq.padding.bottom,
      safeLeft: mq.padding.left,
      safeRight: mq.padding.right,
      viewInsetsBottom: mq.viewInsets.bottom, // keyboard
      orientation: orientation,
    );

    return _ResponsiveScope(size: size, child: child);
  }
}

/// Central API accessed via `context.s`.
@immutable
class AppSize {
  final AppBreakpoint bp;
  final Orientation orientation;
  final double width;
  final double height;
  final double uiScale; // paddings/margins/icons
  final double textScale; // font sizes
  final double devicePixelRatio;

  // Safe-area insets
  final double safeTop, safeBottom, safeLeft, safeRight;
  // Keyboard inset
  final double viewInsetsBottom;

  const AppSize._({
    required this.bp,
    required this.orientation,
    required this.width,
    required this.height,
    required this.uiScale,
    required this.textScale,
    required this.devicePixelRatio,
    required this.safeTop,
    required this.safeBottom,
    required this.safeLeft,
    required this.safeRight,
    required this.viewInsetsBottom,
  });

  // ---- Spacing system (8pt baseline) ----
  double rem([double n = 1]) => 8.0 * n * uiScale;

  double get spaceXs => rem(0.5); // 4 at base
  double get spaceS => rem(1); // 8
  double get spaceM => rem(1.5); // 12
  double get spaceL => rem(2); // 16
  double get spaceXl => rem(3); // 24
  double get space2xl => rem(4); // 32
  double get space3xl => rem(6); // 48

  // ---- Icon sizes ----
  double get iconS => 18 * uiScale;
  double get iconM => 22 * uiScale;
  double get iconL => 28 * uiScale;
  double get iconXl => 36 * uiScale;

  // ---- Radius ----
  double get radiusS => 8 * uiScale;
  double get radiusM => 12 * uiScale;
  double get radiusL => 16 * uiScale;
  double get radiusXl => 24 * uiScale;

  // ---- Typography (font sizes only; apply to TextStyle.fontSize) ----
  double get tXs => 11 * textScale;
  double get tSm => 13 * textScale;
  double get tBase => 15 * textScale;
  double get tLg => 17 * textScale;
  double get tXl => 20 * textScale;
  double get t2xl => 24 * textScale;
  double get t3xl => 28 * textScale;

  // ---- EdgeInsets helpers ----
  EdgeInsets insetsAll(double n) => EdgeInsets.all(rem(n));
  EdgeInsets insetsSymmetric({double h = 0, double v = 0}) =>
      EdgeInsets.symmetric(horizontal: rem(h), vertical: rem(v));
  EdgeInsets insetsOnly(
          {double l = 0, double t = 0, double r = 0, double b = 0}) =>
      EdgeInsets.fromLTRB(rem(l), rem(t), rem(r), rem(b));

  /// Safe outer padding you can use as a page gutter.
  EdgeInsets get pageGutter => EdgeInsets.fromLTRB(
        safeLeft + gutter,
        safeTop + gutterTop,
        safeRight + gutter,
        safeBottom + gutterBottom,
      );

  // ---- Gutter (outer page padding) suggestion ----
  double get gutter => switch (bp) {
        AppBreakpoint.compact => rem(1.5), // 12
        AppBreakpoint.mobile => rem(2), // 16
        AppBreakpoint.tablet => rem(3), // 24
        AppBreakpoint.desktop => rem(4), // 32
      };

  // Safe margin boosters for header/footer areas
  double get gutterTop =>
      (orientation == Orientation.portrait ? rem(1) : rem(0.5));
  double get gutterBottom =>
      rem(2) + viewInsetsBottom / 2; // add half of keyboard inset

  // ---- Density helpers (touch target sizing) ----
  double get minTapTarget => (bp.index >= AppBreakpoint.tablet.index) ? 48 : 44;
  EdgeInsets get hitSlop => EdgeInsets.all(rem(0.5));

  // ---- Animations ----
  Duration get fast => Duration(milliseconds: (120 ~/ uiScale).clamp(90, 140));
  Duration get normal =>
      Duration(milliseconds: (200 ~/ uiScale).clamp(160, 240));
  Duration get slow => Duration(milliseconds: (320 ~/ uiScale).clamp(260, 380));

  // ---- Grid helpers ----
  /// Returns sensible column count for a given min tile width.
  int columnsFor(double minTileWidth) {
    final usable = width - (safeLeft + safeRight) - gutter * 2;
    return math.max(1, (usable / minTileWidth).floor());
  }

  // Convenience
  bool get isCompact => bp == AppBreakpoint.compact;
  bool get isMobile => bp == AppBreakpoint.mobile;
  bool get isTablet => bp == AppBreakpoint.tablet;
  bool get isDesktop => bp == AppBreakpoint.desktop;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSize &&
          bp == other.bp &&
          orientation == other.orientation &&
          width == other.width &&
          height == other.height &&
          uiScale == other.uiScale &&
          textScale == other.textScale &&
          devicePixelRatio == other.devicePixelRatio &&
          safeTop == other.safeTop &&
          safeBottom == other.safeBottom &&
          safeLeft == other.safeLeft &&
          safeRight == other.safeRight &&
          viewInsetsBottom == other.viewInsetsBottom;

  @override
  int get hashCode => Object.hash(
        bp,
        orientation,
        width,
        height,
        uiScale,
        textScale,
        devicePixelRatio,
        safeTop,
        safeBottom,
        safeLeft,
        safeRight,
        viewInsetsBottom,
      );
}

/// BuildContext extension: `context.s`
extension AppSizeContextX on BuildContext {
  AppSize get s {
    final scope = dependOnInheritedWidgetOfExactType<_ResponsiveScope>();
    assert(
      scope != null,
      'Responsive scope not found. Wrap your app with Responsive(child: ...) via MaterialApp.builder.',
    );
    return scope!.size;
  }
}

/// Numeric sugar:
extension NumSizeX on num {
  double rem(BuildContext context) => context.s.rem(toDouble()); // 1.rem(ctx)
  double sp(BuildContext context) => toDouble() * context.s.textScale; // 16.sp
  double ic(BuildContext context) => toDouble() * context.s.uiScale; // 24.ic
}
