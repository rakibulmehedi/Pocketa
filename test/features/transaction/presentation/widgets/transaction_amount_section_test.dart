import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow/core/responsive/responsive.dart';
import 'package:flow/features/transaction/data/models/transaction_model.dart';
import 'package:flow/features/transaction/presentation/viewmodels/transaction_form_state.dart';
import 'package:flow/features/transaction/presentation/widgets/transaction_form/transaction_amount_section.dart';
import 'package:flow/l10n/app_localizations.dart';

void main() {
  group('TransactionAmountSection', () {
    late TextEditingController amountController;
    late ProviderContainer container;

    setUp(() {
      amountController = TextEditingController();
      container = ProviderContainer();
    });

    tearDown(() {
      amountController.dispose();
      container.dispose();
    });

    testWidgets('should display amount field with correct currency', (tester) async {
      final form = TransactionFormState(
        type: TransactionType.expense,
        currency: 'BDT',
        amount: 0.0,
        dateUtc: DateTime.now().toUtc(),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [],
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            builder: (context, child) => Responsive.builder(
              child: child!,
            ),
            home: Scaffold(
              body: TransactionAmountSection(
                amountController: amountController,
                form: form,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(TextField), findsOneWidget);
      // The currency symbol is displayed as prefixText in the TextField
      expect(find.text('৳ '), findsOneWidget);
    });

    testWidgets('should display quick amount chips for expense', (tester) async {
      final form = TransactionFormState(
        type: TransactionType.expense,
        currency: 'BDT',
        amount: 0.0,
        dateUtc: DateTime.now().toUtc(),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [],
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            builder: (context, child) => Responsive.builder(
              child: child!,
            ),
            home: Scaffold(
              body: TransactionAmountSection(
                amountController: amountController,
                form: form,
              ),
            ),
          ),
        ),
      );

      // Should show quick amount chips
      expect(find.byType(ActionChip), findsWidgets);
      expect(find.text('৳100'), findsOneWidget);
      expect(find.text('৳500'), findsOneWidget);
    });

    testWidgets('should call onChanged when amount is entered', (tester) async {
      final form = TransactionFormState(
        type: TransactionType.expense,
        currency: 'BDT',
        amount: 0.0,
        dateUtc: DateTime.now().toUtc(),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [],
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            builder: (context, child) => Responsive.builder(
              child: child!,
            ),
            home: Scaffold(
              body: TransactionAmountSection(
                amountController: amountController,
                form: form,
              ),
            ),
          ),
        ),
      );

      // Enter amount
      await tester.enterText(find.byType(TextField), '1000');
      await tester.pump();

      // Verify the amount was set
      expect(amountController.text, '1,000');
    });

    testWidgets('should validate required amount', (tester) async {
      final form = TransactionFormState(
        type: TransactionType.expense,
        currency: 'BDT',
        amount: 0.0,
        dateUtc: DateTime.now().toUtc(),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [],
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            builder: (context, child) => Responsive.builder(
              child: child!,
            ),
            home: Scaffold(
              body: TransactionAmountSection(
                amountController: amountController,
                form: form,
              ),
            ),
          ),
        ),
      );

      // Leave amount empty and trigger validation
      await tester.enterText(find.byType(TextField), '');
      await tester.pump();

      // Should show validation error
      expect(find.text('Required'), findsOneWidget);
    });

    testWidgets('should validate positive amount', (tester) async {
      final form = TransactionFormState(
        type: TransactionType.expense,
        currency: 'BDT',
        amount: 0.0,
        dateUtc: DateTime.now().toUtc(),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [],
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            builder: (context, child) => Responsive.builder(
              child: child!,
            ),
            home: Scaffold(
              body: TransactionAmountSection(
                amountController: amountController,
                form: form,
              ),
            ),
          ),
        ),
      );

      // Enter negative amount
      await tester.enterText(find.byType(TextField), '-100');
      await tester.pump();

      // Should show validation error
      expect(find.text('Required'), findsOneWidget);
    });

    testWidgets('should handle quick amount chip tap', (tester) async {
      final form = TransactionFormState(
        type: TransactionType.expense,
        currency: 'BDT',
        amount: 0.0,
        dateUtc: DateTime.now().toUtc(),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [],
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            builder: (context, child) => Responsive.builder(
              child: child!,
            ),
            home: Scaffold(
              body: TransactionAmountSection(
                amountController: amountController,
                form: form,
              ),
            ),
          ),
        ),
      );

      // Tap on quick amount chip
      await tester.tap(find.text('৳100'));
      await tester.pump();

      // Verify amount was set
      expect(amountController.text, '100');
    });
  });
}
