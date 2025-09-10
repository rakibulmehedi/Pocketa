sealed class Failure {
  final String message;
  final Object? cause;
  const Failure(this.message, {this.cause});

  @override
  String toString() => '${runtimeType.toString()}($message)';
}

class CacheFailure extends Failure {
  const CacheFailure(super.message, {super.cause});
}

class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message, {super.cause});
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message, {super.cause});
}
