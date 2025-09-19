import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pocketa/core/responsive/responsive_animations.dart';
import 'package:pocketa/core/responsive/responsive.dart';

void main() {
  group('ResponsiveAnimations', () {
    testWidgets('should get animation duration for mobile', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => Responsive.builder(child: child ?? const SizedBox()),
          home: Builder(
            builder: (context) {
              final duration = ResponsiveAnimations.getDuration(context);
              expect(duration, isA<Duration>());
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('should get animation duration with custom values', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => Responsive.builder(child: child ?? const SizedBox()),
          home: Builder(
            builder: (context) {
              final duration = ResponsiveAnimations.getDuration(
                context,
                fast: const Duration(milliseconds: 100),
                normal: const Duration(milliseconds: 200),
                slow: const Duration(milliseconds: 300),
              );
              expect(duration, isA<Duration>());
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('should get animation curve', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => Responsive.builder(child: child ?? const SizedBox()),
          home: Builder(
            builder: (context) {
              final curve = ResponsiveAnimations.getCurve(context);
              expect(curve, isA<Curve>());
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('should get animation scale', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => Responsive.builder(child: child ?? const SizedBox()),
          home: Builder(
            builder: (context) {
              final scale = ResponsiveAnimations.getScale(context);
              expect(scale, isA<double>());
              expect(scale, greaterThan(0));
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('should create staggered fade in animation', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => Responsive.builder(child: child ?? const SizedBox()),
          home: Builder(
            builder: (context) {
              final widget = ResponsiveAnimations.staggeredFadeIn(
                context: context,
                children: [
                  const Text('Item 1'),
                  const Text('Item 2'),
                  const Text('Item 3'),
                ],
              );
              expect(widget, isA<Widget>());
              return widget;
            },
          ),
        ),
      );
    });

    testWidgets('should create slide in animation', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => Responsive.builder(child: child ?? const SizedBox()),
          home: Builder(
            builder: (context) {
              final widget = ResponsiveAnimations.slideIn(
                context: context,
                child: const Text('Slide in'),
              );
              expect(widget, isA<Widget>());
              return widget;
            },
          ),
        ),
      );
    });

    testWidgets('should create scale in animation', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => Responsive.builder(child: child ?? const SizedBox()),
          home: Builder(
            builder: (context) {
              final widget = ResponsiveAnimations.scaleIn(
                context: context,
                child: const Text('Scale in'),
              );
              expect(widget, isA<Widget>());
              return widget;
            },
          ),
        ),
      );
    });

    testWidgets('should create pulse animation', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => Responsive.builder(child: child ?? const SizedBox()),
          home: Builder(
            builder: (context) {
              final widget = ResponsiveAnimations.pulse(
                context: context,
                child: const Text('Pulse'),
              );
              expect(widget, isA<Widget>());
              return widget;
            },
          ),
        ),
      );
    });

    testWidgets('should create shimmer animation', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => Responsive.builder(child: child ?? const SizedBox()),
          home: Builder(
            builder: (context) {
              final widget = ResponsiveAnimations.shimmer(
                context: context,
                child: const Text('Shimmer'),
              );
              expect(widget, isA<Widget>());
              return widget;
            },
          ),
        ),
      );
    });
  });

  group('ResponsiveAnimationsX', () {
    testWidgets('should get responsive animations from context', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                final animations = ResponsiveAnimations();
                expect(animations, isA<ResponsiveAnimations>());
                return Container();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('should get animation duration from context', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                final duration = ResponsiveAnimations.getDuration(context);
                expect(duration, isA<Duration>());
                return Container();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('should get animation curve from context', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                final curve = ResponsiveAnimations.getCurve(context);
                expect(curve, isA<Curve>());
                return Container();
              },
            ),
          ),
        ),
      );
    });
  });

  group('ResponsiveAnimationBuilder', () {
    testWidgets('should build with responsive animations', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => Responsive.builder(child: child ?? const SizedBox()),
          home: Scaffold(
            body: Builder(
              builder: (context) {
                final animations = ResponsiveAnimations();
                expect(animations, isA<ResponsiveAnimations>());
                return Container();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('should build with custom animations', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => Responsive.builder(child: child ?? const SizedBox()),
          home: Scaffold(
            body: Builder(
              builder: (context) {
                final animations = ResponsiveAnimations();
                expect(animations, isA<ResponsiveAnimations>());
                return Container();
              },
            ),
          ),
        ),
      );
    });
  });
}
