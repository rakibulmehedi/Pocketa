import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pocketa/core/responsive/responsive.dart';
import 'package:pocketa/shared/ui_components/ui_components.dart';

void main() {
  group('Premium UI Components Tests', () {
    testWidgets('AppButton renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => Responsive.builder(child: child!),
          home: Scaffold(
            body: AppButton(
              text: 'Test Button',
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Test Button'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('AppButton with icon renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => Responsive.builder(child: child!),
          home: Scaffold(
            body: AppButton(
              text: 'Test Button',
              icon: Icons.add,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Test Button'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('SectionCard renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => Responsive.builder(child: child!),
          home: Scaffold(
            body: SectionCard(
              title: 'Test Card',
              children: [
                Text('Card Content'),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Card Content'), findsOneWidget);
      expect(find.text('Test Card'), findsOneWidget);
    });

    testWidgets('AppListTile renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => Responsive.builder(child: child!),
          home: Scaffold(
            body: AppListTile(
              title: Text('List Title'),
              subtitle: Text('List Subtitle'),
            ),
          ),
        ),
      );

      expect(find.text('List Title'), findsOneWidget);
      expect(find.text('List Subtitle'), findsOneWidget);
      expect(find.byType(ListTile), findsOneWidget);
    });

    testWidgets('AppLoadingIndicator renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => Responsive.builder(child: child!),
          home: Scaffold(
            body: AppLoadingIndicator(
              message: 'Loading...',
              showMessage: true,
            ),
          ),
        ),
      );

      expect(find.text('Loading...'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('QuickButton renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => Responsive.builder(child: child!),
          home: Scaffold(
            body: QuickButton(
              label: 'Quick Action',
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Quick Action'), findsOneWidget);
      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('AppDialog renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => Responsive.builder(child: child!),
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AppDialog(
                        title: 'Test Dialog',
                        content: Text('Dialog Content'),
                      ),
                    );
                  },
                  child: Text('Show Dialog'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pump();

      expect(find.text('Test Dialog'), findsOneWidget);
      expect(find.text('Dialog Content'), findsOneWidget);
      expect(find.byType(Dialog), findsOneWidget);
    });
  });
}
