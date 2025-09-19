import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pocketa/core/core.dart';
import 'package:pocketa/core/ui/base_sheet.dart';

void main() {
  group('BaseSheet', () {
    testWidgets('should render sheet with title and content', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => Responsive.builder(child: child ?? const SizedBox()),
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showModalBottomSheet(
                  context: context,
                  builder: (context) => const BaseSheet(
                    title: 'Test Sheet',
                    content: Text('Test content'),
                    maxHeight: 200,
                  ),
                ),
                child: const Text('Show Sheet'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Sheet'));
      await tester.pumpAndSettle();

      expect(find.text('Test Sheet'), findsOneWidget);
      expect(find.text('Test content'), findsOneWidget);
    });

    testWidgets('should render sheet without title', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => Responsive.builder(child: child ?? const SizedBox()),
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showModalBottomSheet(
                  context: context,
                  builder: (context) => const BaseSheet(
                    content: Text('Test content'),
                    maxHeight: 200,
                  ),
                ),
                child: const Text('Show Sheet'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Sheet'));
      await tester.pumpAndSettle();

      expect(find.text('Test content'), findsOneWidget);
    });

    testWidgets('should render sheet with actions', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => Responsive.builder(child: child ?? const SizedBox()),
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showModalBottomSheet(
                  context: context,
                  builder: (context) => const BaseSheet(
                    title: 'Test Sheet',
                    content: Text('Test content'),
                    maxHeight: 200,
                    actions: [
                      TextButton(
                        onPressed: null,
                        child: Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: null,
                        child: Text('OK'),
                      ),
                    ],
                  ),
                ),
                child: const Text('Show Sheet'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Sheet'));
      await tester.pumpAndSettle();

      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('OK'), findsOneWidget);
    });

    testWidgets('should render scrollable sheet', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => Responsive.builder(child: child ?? const SizedBox()),
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => BaseSheet(
                    title: 'Scrollable Sheet',
                    maxHeight: 300,
                    content: SingleChildScrollView(
                      child: Column(
                        children: List.generate(20, (i) => ListTile(
                          title: Text('Item $i'),
                        )),
                      ),
                    ),
                  ),
                ),
                child: const Text('Show Sheet'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Sheet'));
      await tester.pumpAndSettle();

      expect(find.text('Scrollable Sheet'), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });
  });

  group('BaseDialog', () {
    testWidgets('should render base dialog', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => Responsive.builder(child: child ?? const SizedBox()),
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => const BaseDialog(
                    title: 'Test Dialog',
                    content: Text('Test content'),
                    actions: [
                      TextButton(
                        onPressed: null,
                        child: Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: null,
                        child: Text('OK'),
                      ),
                    ],
                  ),
                ),
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Test Dialog'), findsOneWidget);
      expect(find.text('Test content'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('OK'), findsOneWidget);
    });
  });
}
