// ──────────────────────────────────────────────────────────────────────────────
// Pocketa Responsive System — Lean + Rich API in one scope (back-compatible) 
// @Rakibul Islam Mehedi - rakibulmehedi.dev@gmail.com
// ──────────────────────────────────────────────────────────────────────────────
//
// HOW TO USE
// 1) Install once at the app root:
//    MaterialApp.builder: (ctx, child) => Responsive.builder(child: child ?? const SizedBox())
//
// 2) Lean access (fast, minimal):
//    final device = context.device;    // DeviceSize.phone/tablet/desktop
//    final vw     = context.vw;        // viewport width
//    final vh     = context.vh;        // viewport height
//
// 3) Rich access (ergonomic layout helpers):
//    final L = context.layout;         // AppSize (spacing, text scale, gutters, etc.)
//    Padding(padding: L.pageGutter, child: ...)
//    SizedBox(height: L.space2xl)      // 32 * uiScale
//    Icon(Icons.add, size: 24.ic(context))
//
// 4) Numeric sugar (kept for compatibility):
//    2.rem(context)  -> 16 * uiScale
//    16.sp(context)  -> 16 * textScale
//    24.ic(context)  -> 24 * uiScale
//
// NOTES
// - One MediaQuery/LayoutBuilder read at the top; deep subtree stays cheap.
// - Breakpoints use SHORTEST side (rotation-friendly).
// - Text scale respects accessibility, then clamps.
// - This file keeps historical API: `context.s` is still available (alias of `context.layout`).
//
// ──────────────────────────────────────────────────────────────────────────────

import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Breakpoints (based on shortest side for rotation safety).
enum AppBreakpoint { compact, mobile, tablet, desktop }

/// Lean device class for quick branching.
enum DeviceSize { phone, tablet, desktop }

/// Reference canvas width (gentle scaling target).
const double _kDesignWidth = 390.0;

/// Internal scope that carries both lean + rich data.
/// We compute once at the top → deep tree is cheap.
class _ResponsiveScope extends InheritedWidget {
  final DeviceSize device; // lean
  final double viewportWidth; // lean
  final double viewportHeight; // lean
  final AppSize layout; // rich

  const _ResponsiveScope({
    required this.device,
    required this.viewportWidth,
    required this.viewportHeight,
    required this.layout,
    required super.child,
  });

  @override
  bool updateShouldNotify(_ResponsiveScope old) =>
      device != old.device ||
      viewportWidth != old.viewportWidth ||
      viewportHeight != old.viewportHeight ||
      layout != old.layout;
}

/// Public wrapper: install once via MaterialApp.builder.
class Responsive extends StatelessWidget {
  final Widget child;

  /// Respect user's system text scale (a11y). We still clamp.
  final bool respectSystemTextScale;

  /// Text scale clamp after applying uiScale.
  final double minTextScale;
  final double maxTextScale;

  /// Optional platform tweak (e.g., slightly smaller on web desktop).
  final double? platformUiScaleOverride;

  const Responsive.builder({
    super.key,
    required this.child,
    this.respectSystemTextScale = true,
    this.minTextScale = 0.85,
    this.maxTextScale = 1.30,
    this.platformUiScaleOverride,
  });

  static _ResponsiveScope _of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_ResponsiveScope>()!;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        // Single MediaQuery read.
        final mq = MediaQuery.of(ctx);
        final maxWidth = constraints.maxWidth;
        final maxHeight = constraints.maxHeight;

        // Rotation-friendly classification by shortest side.
        final shortestSide =
            math.max(320.0, math.min(mq.size.width, mq.size.height));
        final breakpoint = shortestSide >= 1024
            ? AppBreakpoint.desktop
            : shortestSide >= 700
                ? AppBreakpoint.tablet
                : shortestSide >= 360
                    ? AppBreakpoint.mobile
                    : AppBreakpoint.compact;

        // Lean device class by width (useful for quick ifs).
        final device = maxWidth >= 1024
            ? DeviceSize.desktop
            : maxWidth >= 600
                ? DeviceSize.tablet
                : DeviceSize.phone;

        // Gentle UI scaling toward our reference width.
        final baseScale = (mq.size.width / _kDesignWidth).clamp(0.84, 1.42);

        // Subtle boost so large screens don't feel cramped.
        final bpBoost = switch (breakpoint) {
          AppBreakpoint.compact => 0.96,
          AppBreakpoint.mobile => 1.00,
          AppBreakpoint.tablet => 1.08,
          AppBreakpoint.desktop => 1.12,
        };

        final platformBoost = platformUiScaleOverride ??
            (kIsWeb && device == DeviceSize.desktop ? 0.98 : 1.0);

        final uiScale = baseScale * bpBoost * platformBoost;

        // Respect a11y text scale then clamp.
        final rawTextScale =
            (respectSystemTextScale ? mq.textScaler.scale(1.0) : 1.0) * uiScale;
        final textScale = rawTextScale.clamp(minTextScale, maxTextScale);

        final appSize = AppSize._(
          breakpoint: breakpoint,
          orientation: mq.orientation,
          screenWidth: mq.size.width,
          screenHeight: mq.size.height,
          uiScale: uiScale,
          textScale: textScale,
          devicePixelRatio: mq.devicePixelRatio,
          safeTop: mq.padding.top,
          safeBottom: mq.padding.bottom,
          safeLeft: mq.padding.left,
          safeRight: mq.padding.right,
          viewInsetsBottom: mq.viewInsets.bottom,
        );

        return _ResponsiveScope(
          device: device,
          viewportWidth: maxWidth,
          viewportHeight: maxHeight,
          layout: appSize,
          child: child,
        );
      },
    );
  }
}

/// Rich layout model: spacing, gutters, text scale, grid helpers.
@immutable
class AppSize {
  final AppBreakpoint breakpoint;
  final Orientation orientation;
  final double screenWidth;
  final double screenHeight;

  /// Scales paddings/margins/icons.
  final double uiScale;

  /// Scales font sizes.
  final double textScale;

  final double devicePixelRatio;

  // Safe-area insets.
  final double safeTop, safeBottom, safeLeft, safeRight;

  // Keyboard inset.
  final double viewInsetsBottom;

  const AppSize._({
    required this.breakpoint,
    required this.orientation,
    required this.screenWidth,
    required this.screenHeight,
    required this.uiScale,
    required this.textScale,
    required this.devicePixelRatio,
    required this.safeTop,
    required this.safeBottom,
    required this.safeLeft,
    required this.safeRight,
    required this.viewInsetsBottom,
  });

  // ── Spacing (8pt baseline) ────────────────────────────────────────────────
  double rem([double n = 1]) => 8.0 * n * uiScale;

  double get spaceXs => rem(0.5); // 4
  double get spaceS => rem(1); // 8
  double get spaceM => rem(1.5); // 12
  double get spaceL => rem(2); // 16
  double get spaceXl => rem(3); // 24
  double get space2xl => rem(4); // 32
  double get space3xl => rem(6); // 48
  // Back-compat aliases:
  double get space2XL => space2xl;
  double get spaceXL => spaceXl;

  // ── Icons ────────────────────────────────────────────────────────────────
  double get iconS => 18 * uiScale;
  double get iconM => 22 * uiScale;
  double get iconL => 28 * uiScale;
  double get iconXl => 36 * uiScale;

  // ── Radius ───────────────────────────────────────────────────────────────
  double get radiusS => 8 * uiScale;
  double get radiusM => 12 * uiScale;
  double get radiusL => 16 * uiScale;
  double get radiusXl => 24 * uiScale;

  // ── Typography (fontSize only; apply to TextStyle.fontSize) ─────────────
  double get tXs => 11 * textScale;
  double get tSm => 13 * textScale;
  double get tBase => 15 * textScale;
  double get tLg => 17 * textScale;
  double get tXl => 20 * textScale;
  double get t2xl => 24 * textScale;
  double get t3xl => 28 * textScale;

  // ── Insets helpers ──────────────────────────────────────────────────────
  EdgeInsets insetsAll(double n) => EdgeInsets.all(rem(n));
  EdgeInsets insetsSymmetric({double h = 0, double v = 0}) =>
      EdgeInsets.symmetric(horizontal: rem(h), vertical: rem(v));
  EdgeInsets insetsOnly(
          {double l = 0, double t = 0, double r = 0, double b = 0}) =>
      EdgeInsets.fromLTRB(rem(l), rem(t), rem(r), rem(b));

  /// Page gutter considering safe-area (good as a screen-level padding).
  EdgeInsets get pageGutter => EdgeInsets.fromLTRB(
        safeLeft + gutter,
        safeTop + gutterTop,
        safeRight + gutter,
        safeBottom + gutterBottom,
      );

  // Outer gutter magnitude by breakpoint.
  double get gutter => switch (breakpoint) {
        AppBreakpoint.compact => rem(1.5),
        AppBreakpoint.mobile => rem(2),
        AppBreakpoint.tablet => rem(3),
        AppBreakpoint.desktop => rem(4),
      };

  // Header/footer booster and keyboard-aware bottom.
  double get gutterTop =>
      (orientation == Orientation.portrait ? rem(1) : rem(0.5));
  double get gutterBottom => rem(2) + viewInsetsBottom / 2;

  // ── Density (touch target) ───────────────────────────────────────────────
  double get minTapTarget =>
      (breakpoint.index >= AppBreakpoint.tablet.index) ? 48 : 44;
  EdgeInsets get hitSlop => EdgeInsets.all(rem(0.5));

  // ── Animation timings (rough, scale-aware) ───────────────────────────────
  Duration get fast => Duration(milliseconds: (120 ~/ uiScale).clamp(90, 140));
  Duration get normal =>
      Duration(milliseconds: (200 ~/ uiScale).clamp(160, 240));
  Duration get slow => Duration(milliseconds: (320 ~/ uiScale).clamp(260, 380));

  // ── Grid helper ──────────────────────────────────────────────────────────
  /// Sensible column count for a given minimum tile width.
  int columnsFor(double minTileWidth) {
    final usable = screenWidth - (safeLeft + safeRight) - gutter * 2;
    return math.max(1, (usable / minTileWidth).floor());
  }

  // Quick flags
  bool get isCompact => breakpoint == AppBreakpoint.compact;
  bool get isMobile => breakpoint == AppBreakpoint.mobile;
  bool get isTablet => breakpoint == AppBreakpoint.tablet;
  bool get isDesktop => breakpoint == AppBreakpoint.desktop;

  // ── Responsive Size Helpers ────────────────────────────────────────────────
  /// Get responsive size based on device type
  double responsiveSize({
    required double phone,
    required double tablet,
    required double desktop,
  }) {
    return switch (breakpoint) {
      AppBreakpoint.compact || AppBreakpoint.mobile => phone * uiScale,
      AppBreakpoint.tablet => tablet * uiScale,
      AppBreakpoint.desktop => desktop * uiScale,
    };
  }

  /// Get responsive text size based on device type
  double responsiveTextSize({
    required double phone,
    required double tablet,
    required double desktop,
  }) {
    return switch (breakpoint) {
      AppBreakpoint.compact || AppBreakpoint.mobile => phone * textScale,
      AppBreakpoint.tablet => tablet * textScale,
      AppBreakpoint.desktop => desktop * textScale,
    };
  }

  /// Get responsive icon size based on device type
  double responsiveIconSize({
    required double phone,
    required double tablet,
    required double desktop,
  }) {
    return switch (breakpoint) {
      AppBreakpoint.compact || AppBreakpoint.mobile => phone * uiScale,
      AppBreakpoint.tablet => tablet * uiScale,
      AppBreakpoint.desktop => desktop * uiScale,
    };
  }

  /// Get responsive text style based on device type
  TextStyle responsiveTextStyle({
    required TextStyle phone,
    required TextStyle tablet,
    required TextStyle desktop,
  }) {
    final baseStyle = switch (breakpoint) {
      AppBreakpoint.compact || AppBreakpoint.mobile => phone,
      AppBreakpoint.tablet => tablet,
      AppBreakpoint.desktop => desktop,
    };
    return baseStyle.copyWith(
      fontSize: baseStyle.fontSize != null 
        ? baseStyle.fontSize! * textScale 
        : null,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSize &&
          breakpoint == other.breakpoint &&
          orientation == other.orientation &&
          screenWidth == other.screenWidth &&
          screenHeight == other.screenHeight &&
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
        breakpoint,
        orientation,
        screenWidth,
        screenHeight,
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

// ───────────────────────────────────────────────────────────────────────────
// Context extensions
// ───────────────────────────────────────────────────────────────────────────

/// Lean accessors (fast, minimal branching).
extension ResponsiveContextLeanX on BuildContext {
  DeviceSize get device => Responsive._of(this).device;
  double get vw => Responsive._of(this).viewportWidth;
  double get vh => Responsive._of(this).viewportHeight;
}

/// Rich accessor (primary): `context.layout`
extension LayoutContextX on BuildContext {
  AppSize get layout {
    final scope = dependOnInheritedWidgetOfExactType<_ResponsiveScope>();
    assert(
      scope != null,
      'Responsive scope not found. Wrap MaterialApp.builder with Responsive.builder.',
    );
    return scope!.layout;
  }
}

/// Back-compat alias (legacy code uses `context.s`)
extension AppSizeContextLegacyX on BuildContext {
  @Deprecated('Use context.layout instead; kept for back-compat.')
  AppSize get s => layout;
}

/// Numeric helpers (kept for compatibility)
extension NumSizeX on num {
  double rem(BuildContext context) => context.layout.rem(toDouble());
  double sp(BuildContext context) => toDouble() * context.layout.textScale;
  double ic(BuildContext context) => toDouble() * context.layout.uiScale;

  /// Fractional viewport helpers
  double w(BuildContext context) => toDouble() * context.layout.screenWidth;
  double h(BuildContext context) => toDouble() * context.layout.screenHeight;
}
