import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pocketa/shared/widgets/ui_components.dart';

void main() {
  group('Premium UI Components Tests', () {
    testWidgets('AppButton renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
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

    testWidgets('AppCard renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppCard(
              child: Text('Card Content'),
            ),
          ),
        ),
      );

      expect(find.text('Card Content'), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('AppListTile renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
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

    testWidgets('AppSnackbar renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppSnackbar(
              message: 'Test Snackbar',
              type: AppSnackbarType.success,
            ),
          ),
        ),
      );

      expect(find.text('Test Snackbar'), findsOneWidget);
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('QuickButton renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuickButton(
              label: 'Quick Action',
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Quick Action'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('AppDialog renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
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
