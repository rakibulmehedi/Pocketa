import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pocketa/core/error_handling/error_handler.dart';
import 'package:pocketa/core/errors/failure.dart';
import 'package:pocketa/core/responsive/responsive.dart';
import 'package:pocketa/core/result/result.dart';
import 'package:pocketa/l10n/app_localizations.dart';

Widget _testApp({required Widget child}) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    builder: (context, widget) => Responsive.builder(child: widget!),
    home: Scaffold(body: child),
  );
}

void main() {
  group('ErrorHandler', () {
    testWidgets('should handle Failure errors without throwing', (tester) async {
      await tester.pumpWidget(
        _testApp(
          child: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  ErrorHandler.handleError(
                    context,
                    const CacheFailure('Cache error'),
                    showSnackbar: false,
                  );
                  ErrorHandler.handleError(
                    context,
                    const DatabaseFailure('Database error'),
                    showSnackbar: false,
                  );
                  ErrorHandler.handleError(
                    context,
                    const NetworkFailure('Network error'),
                    showSnackbar: false,
                  );
                },
                child: const Text('trigger'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('trigger'));
      await tester.pump();
      expect(tester.takeException(), isNull);
    });

    testWidgets('should handle Result errors without throwing', (tester) async {
      await tester.pumpWidget(
        _testApp(
          child: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  final errorResult = Err(const NetworkFailure('Network error'));
                  ErrorHandler.handleResultError(
                    context,
                    errorResult,
                    showSnackbar: false,
                  );

                  final successResult = Ok('success');
                  ErrorHandler.handleResultError(
                    context,
                    successResult,
                    showSnackbar: false,
                  );
                },
                child: const Text('trigger'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('trigger'));
      await tester.pump();
      expect(tester.takeException(), isNull);
    });

    testWidgets('should handle async operations without throwing', (tester) async {
      await tester.pumpWidget(
        _testApp(
          child: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  ErrorHandler.handleAsync(
                    context,
                    () async => 'success',
                    showLoading: false,
                  );
                },
                child: const Text('trigger'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('trigger'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('should get correct error messages for different error types',
        (tester) async {
      late AppLocalizations l10n;

      await tester.pumpWidget(
        _testApp(
          child: Builder(
            builder: (context) {
              l10n = AppLocalizations.of(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(l10n.errorCache, isA<String>());
      expect(l10n.errorDatabase, isA<String>());
      expect(l10n.errorNetwork, isA<String>());
      expect(l10n.errorValidation, isA<String>());
      expect(l10n.errorGeneric, isA<String>());
    });
  });

  group('ErrorHandlingMixin', () {
    testWidgets('should handle errors in widget without throwing', (tester) async {
      await tester.pumpWidget(
        _testApp(child: _TestWidget()),
      );

      await tester.tap(find.text('trigger'));
      await tester.pump();
      // SnackBar timer — advance past it
      await tester.pump(const Duration(seconds: 5));
      expect(tester.takeException(), isNull);
    });
  });
}

class _TestWidget extends StatefulWidget {
  @override
  State<_TestWidget> createState() => _TestWidgetState();
}

class _TestWidgetState extends State<_TestWidget> with ErrorHandlingMixin {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        handleError(
          const NetworkFailure('Network error'),
        );
      },
      child: const Text('trigger'),
    );
  }
}
