import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa/core/responsive/responsive.dart';
import 'package:pocketa/features/transaction/data/models/transaction_model.dart';
import 'package:pocketa/features/transaction/presentation/viewmodels/transaction_form_state.dart';
import 'package:pocketa/features/transaction/presentation/widgets/transaction_form/transaction_amount_section.dart';
import 'package:pocketa/shared/widgets/input/app_amount_field.dart';
import 'package:pocketa/l10n/app_localizations.dart';

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

    Widget buildTestWidget(TransactionFormState form) {
      return ProviderScope(
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
      );
    }

    TransactionFormState defaultForm() => TransactionFormState(
          type: TransactionType.expense,
          currency: 'BDT',
          amount: 0.0,
          dateUtc: DateTime.now().toUtc(),
        );

    testWidgets('should display amount field', (tester) async {
      await tester.pumpWidget(buildTestWidget(defaultForm()));

      expect(find.byType(AmountField), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('should display quick amount chips for expense', (tester) async {
      await tester.pumpWidget(buildTestWidget(defaultForm()));

      expect(find.byType(ActionChip), findsWidgets);
      expect(find.text('৳100'), findsOneWidget);
      expect(find.text('৳500'), findsOneWidget);
    });

    testWidgets('should call onChanged when amount is entered', (tester) async {
      await tester.pumpWidget(buildTestWidget(defaultForm()));

      await tester.enterText(find.byType(TextFormField), '1000');
      await tester.pump();

      // Indian grouping formatter adds commas
      expect(amountController.text, '1,000');
    });

    testWidgets('should validate required amount', (tester) async {
      final formKey = GlobalKey<FormState>();
      final form = defaultForm();

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
              body: Form(
                key: formKey,
                child: Column(
                  children: [
                    TransactionAmountSection(
                      amountController: amountController,
                      form: form,
                    ),
                    Builder(
                      builder: (context) => ElevatedButton(
                        onPressed: () => formKey.currentState!.validate(),
                        child: const Text('validate'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      // Leave amount empty and trigger validation
      await tester.tap(find.text('validate'));
      await tester.pump();

      expect(find.text('Required'), findsOneWidget);
    });

    testWidgets('should validate positive amount', (tester) async {
      final formKey = GlobalKey<FormState>();
      final form = defaultForm();

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
              body: Form(
                key: formKey,
                child: Column(
                  children: [
                    TransactionAmountSection(
                      amountController: amountController,
                      form: form,
                    ),
                    Builder(
                      builder: (context) => ElevatedButton(
                        onPressed: () => formKey.currentState!.validate(),
                        child: const Text('validate'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      // Enter 0 (not positive)
      await tester.enterText(find.byType(TextFormField), '0');
      await tester.tap(find.text('validate'));
      await tester.pump();

      expect(find.text('Amount must be positive'), findsOneWidget);
    });

    testWidgets('should handle quick amount chip tap', (tester) async {
      await tester.pumpWidget(buildTestWidget(defaultForm()));

      await tester.tap(find.text('৳100'));
      await tester.pump();

      expect(amountController.text, '100');
    });
  });
}
