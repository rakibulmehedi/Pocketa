sealed class Failure {
  final String message;
  final Object? cause;
  const Failure(this.message, {this.cause});

  @override
  String toString() => '${runtimeType.toString()}($message)';
}

class CacheFailure extends Failure {
  const CacheFailure(String message, {Object? cause})
      : super(message, cause: cause);
}

class DatabaseFailure extends Failure {
  const DatabaseFailure(String message, {Object? cause})
      : super(message, cause: cause);
}

class NetworkFailure extends Failure {
  const NetworkFailure(String message, {Object? cause})
      : super(message, cause: cause);
}
