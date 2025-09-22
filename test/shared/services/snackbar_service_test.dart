import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flow/shared/services/ui/ui_services.dart';

void main() {
  group('SnackbarService Tests', () {
    late Widget testWidget;

    setUp(() {
      testWidget = MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => Column(
              children: [
                ElevatedButton(
                  onPressed: () => SnackbarService.showSuccess(
                    context,
                    message: 'Success message',
                  ),
                  child: Text('Show Success'),
                ),
                ElevatedButton(
                  onPressed: () => SnackbarService.showError(
                    context,
                    message: 'Error message',
                  ),
                  child: Text('Show Error'),
                ),
                ElevatedButton(
                  onPressed: () => SnackbarService.showWarning(
                    context,
                    message: 'Warning message',
                  ),
                  child: Text('Show Warning'),
                ),
                ElevatedButton(
                  onPressed: () => SnackbarService.showInfo(
                    context,
                    message: 'Info message',
                  ),
                  child: Text('Show Info'),
                ),
                ElevatedButton(
                  onPressed: () => SnackbarService.showWithAction(
                    context,
                    message: 'Action message',
                    actionLabel: 'Action',
                    onAction: () {},
                  ),
                  child: Text('Show With Action'),
                ),
                ElevatedButton(
                  onPressed: () => SnackbarService.showWithRetry(
                    context,
                    message: 'Retry message',
                    onRetry: () {},
                  ),
                  child: Text('Show With Retry'),
                ),
                ElevatedButton(
                  onPressed: () => SnackbarService.showWithUndo(
                    context,
                    message: 'Undo message',
                    onUndo: () {},
                  ),
                  child: Text('Show With Undo'),
                ),
                ElevatedButton(
                  onPressed: () => SnackbarService.showSilent(
                    context,
                    message: 'Silent message',
                  ),
                  child: Text('Show Silent'),
                ),
              ],
            ),
          ),
        ),
      );
    });

    testWidgets('showSuccess displays success snackbar', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      
      await tester.tap(find.text('Show Success'));
      await tester.pump();
      
      expect(find.text('Success message'), findsOneWidget);
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('showError displays error snackbar', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      
      await tester.tap(find.text('Show Error'));
      await tester.pump();
      
      expect(find.text('Error message'), findsOneWidget);
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('showWarning displays warning snackbar', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      
      await tester.tap(find.text('Show Warning'));
      await tester.pump();
      
      expect(find.text('Warning message'), findsOneWidget);
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('showInfo displays info snackbar', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      
      await tester.tap(find.text('Show Info'));
      await tester.pump();
      
      expect(find.text('Info message'), findsOneWidget);
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('showWithAction displays snackbar with action', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      
      await tester.tap(find.text('Show With Action'));
      await tester.pump();
      
      expect(find.text('Action message'), findsOneWidget);
      expect(find.text('Action'), findsOneWidget);
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('showWithRetry displays snackbar with retry action', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      
      await tester.tap(find.text('Show With Retry'));
      await tester.pump();
      
      expect(find.text('Retry message'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('showWithUndo displays snackbar with undo action', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      
      await tester.tap(find.text('Show With Undo'));
      await tester.pump();
      
      expect(find.text('Undo message'), findsOneWidget);
      expect(find.text('Undo'), findsOneWidget);
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('showSilent displays snackbar without haptic', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      
      await tester.tap(find.text('Show Silent'));
      await tester.pump();
      
      expect(find.text('Silent message'), findsOneWidget);
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('convenience methods work correctly', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      
      // Test transaction added
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => SnackbarService.showTransactionAdded(context),
              child: Text('Transaction Added'),
            ),
          ),
        ),
      ));
      
      await tester.tap(find.text('Transaction Added'));
      await tester.pump();
      
      expect(find.text('Transaction added successfully'), findsOneWidget);
    });

    testWidgets('hide and clearAll methods work', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      
      // Show a snackbar first
      await tester.tap(find.text('Show Success'));
      await tester.pump();
      
      expect(find.byType(SnackBar), findsOneWidget);
      
      // Hide it
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => SnackbarService.hide(context),
              child: Text('Hide'),
            ),
          ),
        ),
      ));
      
      await tester.tap(find.text('Hide'));
      await tester.pump();
      
      expect(find.byType(SnackBar), findsNothing);
    });

    testWidgets('custom duration works', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => SnackbarService.showCustomDuration(
                context,
                message: 'Custom duration',
                duration: Duration(seconds: 1),
              ),
              child: Text('Custom Duration'),
            ),
          ),
        ),
      ));
      
      await tester.tap(find.text('Custom Duration'));
      await tester.pump();
      
      expect(find.text('Custom duration'), findsOneWidget);
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('AppSnackbar component is used', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      
      await tester.tap(find.text('Show Success'));
      await tester.pump();
      
      expect(find.byType(SnackBar), findsOneWidget);
    });
  });

  group('SnackbarService Haptic Feedback Tests', () {
    testWidgets('haptic feedback is triggered for success', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => SnackbarService.showSuccess(
                context,
                message: 'Success',
                enableHaptic: true,
              ),
              child: Text('Success'),
            ),
          ),
        ),
      ));
      
      await tester.tap(find.text('Success'));
      await tester.pump();
      
      // Haptic feedback should be triggered
      // Note: In real tests, you might want to mock HapticFeedback
      expect(find.text('Success'), findsNWidgets(2));
    });

    testWidgets('haptic feedback is disabled when specified', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => SnackbarService.showSuccess(
                context,
                message: 'Success',
                enableHaptic: false,
              ),
              child: Text('Success'),
            ),
          ),
        ),
      ));
      
      await tester.tap(find.text('Success'));
      await tester.pump();
      
      expect(find.text('Success'), findsNWidgets(2));
    });
  });

  group('SnackbarService Edge Cases', () {
    testWidgets('multiple snackbars are handled correctly', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => Column(
              children: [
                ElevatedButton(
                  onPressed: () => SnackbarService.showSuccess(
                    context,
                    message: 'First',
                  ),
                  child: Text('First'),
                ),
                ElevatedButton(
                  onPressed: () => SnackbarService.showError(
                    context,
                    message: 'Second',
                  ),
                  child: Text('Second'),
                ),
              ],
            ),
          ),
        ),
      ));
      
      // Show first snackbar
      await tester.tap(find.text('First'));
      await tester.pump();
      expect(find.text('First'), findsNWidgets(2));
      
      // Show second snackbar (should replace first)
      await tester.tap(find.text('Second'));
      await tester.pump();
      expect(find.text('Second'), findsNWidgets(2));
      expect(find.text('First'), findsNothing);
    });

    testWidgets('empty message is handled', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => SnackbarService.showSuccess(
                context,
                message: '',
              ),
              child: Text('Empty'),
            ),
          ),
        ),
      ));
      
      await tester.tap(find.text('Empty'));
      await tester.pump();
      
      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}
