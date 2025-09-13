import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pocketa/core/error_handling/error_handler.dart';
import 'package:pocketa/core/errors/failure.dart';
import 'package:pocketa/core/result/result.dart';
import 'package:pocketa/l10n/app_localizations.dart';

void main() {
  group('ErrorHandler', () {
    testWidgets('should handle Failure errors correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Builder(
              builder: (context) {
                // Schedule error handling after build
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  // Test cache failure
                  ErrorHandler.handleError(
                    context,
                    const CacheFailure('Cache error'),
                  );
                  
                  // Test database failure
                  ErrorHandler.handleError(
                    context,
                    const DatabaseFailure('Database error'),
                  );
                  
                  // Test network failure
                  ErrorHandler.handleError(
                    context,
                    const NetworkFailure('Network error'),
                  );
                  
                  // Test validation failure
                  ErrorHandler.handleError(
                    context,
                    const CacheFailure('Invalid input'),
                  );
                  
                  // Test unknown failure
                  ErrorHandler.handleError(
                    context,
                    const DatabaseFailure('Something went wrong'),
                  );
                });
                
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      await tester.pump();
      expect(tester.takeException(), isNull);
    });

    testWidgets('should handle Result errors correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Builder(
              builder: (context) {
                // Test error result
                final errorResult = Err(const NetworkFailure('Network error'));
                ErrorHandler.handleResultError(
                  context,
                  errorResult,
                );
                
                // Test success result (should do nothing)
                final successResult = Ok('success');
                ErrorHandler.handleResultError(
                  context,
                  successResult,
                );
                
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      await tester.pump();
      expect(tester.takeException(), isNull);
    });

    testWidgets('should handle async operations correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Builder(
              builder: (context) {
                // Test successful async operation
                ErrorHandler.handleAsync(
                  context,
                  () async => 'success',
                );
                
                // Test failed async operation
                ErrorHandler.handleAsync(
                  context,
                  () async => throw Exception('Test error'),
                );
                
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      await tester.pump();
      expect(tester.takeException(), isNull);
    });

    test('should get correct error messages for different error types', () {
      final l10n = AppLocalizations.of(const MaterialApp().createElement());
      
      // Test that error handler can handle different error types
      expect(l10n.errorCache, isA<String>());
      expect(l10n.errorDatabase, isA<String>());
      expect(l10n.errorNetwork, isA<String>());
      expect(l10n.errorValidation, isA<String>());
      expect(l10n.errorGeneric, isA<String>());
    });
  });

  group('ErrorHandlingMixin', () {
    testWidgets('should handle errors in widget', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: _TestWidget(),
          ),
        ),
      );

      await tester.pump();
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
  void initState() {
    super.initState();
    // Test error handling after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      handleError(
        const NetworkFailure('Network error'),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
