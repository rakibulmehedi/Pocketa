import 'package:pocketa/core/errors/exceptions.dart';
import 'package:pocketa/core/errors/failure.dart';

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
  // default
  return DatabaseFailure(error.toString(), cause: error);
}

