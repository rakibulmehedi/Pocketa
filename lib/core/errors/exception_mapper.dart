import 'package:flow/core/errors/exceptions.dart';
import 'package:flow/core/errors/failure.dart';

Failure mapExceptionToFailure(Object error) {
  if (error is CacheException) {
    return CacheFailure(error.message, cause: error);
  }
  if (error is DatabaseException) {
    return DatabaseFailure(error.message, cause: error);
  }
  if (error is NetworkException) {
    return NetworkFailure(error.message, cause: error);
  }
  // default: include type to make message informative for tests/logs
  return DatabaseFailure('Database error: ${error.runtimeType}', cause: error);
}
