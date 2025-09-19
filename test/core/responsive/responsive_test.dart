import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pocketa/core/responsive/responsive.dart';

void main() {
  group('Responsive', () {
    testWidgets('should create responsive with mobile layout', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => Responsive.builder(child: child ?? const SizedBox()),
          home: Scaffold(
            body: Builder(
              builder: (context) {
                final layout = context.layout;
                expect(layout.isMobile, true);
                expect(layout.isTablet, false);
                expect(layout.isDesktop, false);
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('should create responsive with tablet layout', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => Responsive.builder(child: child ?? const SizedBox()),
          home: SizedBox(
            width: 800,
            height: 600,
            child: Scaffold(
              body: Builder(
                builder: (context) {
                  final layout = context.layout;
                  expect(layout.isMobile, false);
                  expect(layout.isTablet, true);
                  expect(layout.isDesktop, false);
                  return const SizedBox();
                },
              ),
            ),
          ),
        ),
      );
    });

    testWidgets('should create responsive with desktop layout', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => Responsive.builder(child: child ?? const SizedBox()),
          home: SizedBox(
            width: 1200,
            height: 800,
            child: Scaffold(
              body: Builder(
                builder: (context) {
                  final layout = context.layout;
                  expect(layout.isMobile, false);
                  expect(layout.isTablet, false);
                  expect(layout.isDesktop, true);
                  return const SizedBox();
                },
              ),
            ),
          ),
        ),
      );
    });

    testWidgets('should calculate breakpoints correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => Responsive.builder(child: child ?? const SizedBox()),
          home: Builder(
            builder: (context) {
              final layout = context.layout;
              expect(layout.breakpoint, AppBreakpoint.mobile);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('should calculate responsive values', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => Responsive.builder(child: child ?? const SizedBox()),
          home: Builder(
            builder: (context) {
              final layout = context.layout;
              final value = layout.responsiveSize(
                phone: 10,
                tablet: 20,
                desktop: 30,
              );
              expect(value, isA<double>());
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('should calculate responsive spacing', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => Responsive.builder(child: child ?? const SizedBox()),
          home: Builder(
            builder: (context) {
              final layout = context.layout;
              expect(layout.spaceS, isA<double>());
              expect(layout.spaceM, isA<double>());
              expect(layout.spaceL, isA<double>());
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('should calculate responsive radius', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => Responsive.builder(child: child ?? const SizedBox()),
          home: Builder(
            builder: (context) {
              final layout = context.layout;
              expect(layout.radiusS, isA<double>());
              expect(layout.radiusM, isA<double>());
              expect(layout.radiusL, isA<double>());
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('should calculate responsive icon size', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => Responsive.builder(child: child ?? const SizedBox()),
          home: Builder(
            builder: (context) {
              final layout = context.layout;
              expect(layout.iconS, isA<double>());
              expect(layout.iconM, isA<double>());
              expect(layout.iconL, isA<double>());
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('should calculate responsive font size', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => Responsive.builder(child: child ?? const SizedBox()),
          home: Builder(
            builder: (context) {
              final layout = context.layout;
              expect(layout.tXs, isA<double>());
              expect(layout.tSm, isA<double>());
              expect(layout.tBase, isA<double>());
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('should calculate responsive grid columns', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => Responsive.builder(child: child ?? const SizedBox()),
          home: Builder(
            builder: (context) {
              final layout = context.layout;
              final columns = layout.columnsFor(100);
              expect(columns, isA<int>());
              expect(columns, greaterThan(0));
              return const SizedBox();
            },
          ),
        ),
      );
    });
  });

  group('ResponsiveX', () {
    testWidgets('should get responsive from context', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                final responsive = context.layout;
                expect(responsive, isA<AppSize>());
                return Container();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('should get layout from context', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                final layout = context.layout;
                expect(layout, isA<Responsive>());
                return Container();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('should get responsive padding from context', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                final padding = context.layout.pageGutter;
                expect(padding, isA<EdgeInsetsGeometry>());
                return Container();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('should get responsive margin from context', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                final margin = context.layout.pageGutter;
                expect(margin, isA<EdgeInsetsGeometry>());
                return Container();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('should get responsive spacing from context', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                final spacing = context.layout.spaceM;
                expect(spacing, isA<double>());
                return Container();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('should get responsive radius from context', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                final radius = context.layout.radiusM;
                expect(radius, isA<double>());
                return Container();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('should get responsive icon size from context', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                final iconSize = context.layout.iconM;
                expect(iconSize, isA<double>());
                return Container();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('should get responsive font size from context', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                final fontSize = context.layout.tBase;
                expect(fontSize, isA<double>());
                return Container();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('should get responsive grid columns from context', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                final gridColumns = context.layout.breakpoint.index + 1;
                expect(gridColumns, isA<int>());
                return Container();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('should get responsive grid spacing from context', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                final gridSpacing = context.layout.spaceM;
                expect(gridSpacing, isA<double>());
                return Container();
              },
            ),
          ),
        ),
      );
    });
  });
}
