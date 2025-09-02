import 'package:flutter_test/flutter_test.dart';
import 'package:pocketa/core/errors/exception_mapper.dart';
import 'package:pocketa/core/errors/exceptions.dart';
import 'package:pocketa/core/errors/failure.dart';

void main() {
  group('mapExceptionToFailure', () {
    test('maps CacheException to CacheFailure', () {
      final f = mapExceptionToFailure(CacheException('boom'));
      expect(f, isA<CacheFailure>());
      expect(f.message, 'boom');
    });

    test('maps DatabaseException to DatabaseFailure', () {
      final f = mapExceptionToFailure(DatabaseException('db'));
      expect(f, isA<DatabaseFailure>());
      expect(f.message, 'db');
    });

    test('maps NetworkException to NetworkFailure', () {
      final f = mapExceptionToFailure(NetworkException('net'));
      expect(f, isA<NetworkFailure>());
      expect(f.message, 'net');
    });

    test('maps unknown error to DatabaseFailure by default', () {
      final f = mapExceptionToFailure(StateError('x'));
      expect(f, isA<DatabaseFailure>());
      expect(f.message, contains('StateError'));
    });
  });
}

