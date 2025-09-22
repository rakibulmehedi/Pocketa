import 'package:flow/core/errors/failure.dart';

sealed class Result<T> {
  const Result();
  R when<R>({required R Function(T) ok, required R Function(Failure) err});
}

class Ok<T> extends Result<T> {
  final T value;
  const Ok(this.value);

  @override
  R when<R>({required R Function(T) ok, required R Function(Failure) err}) =>
      ok(value);
}

class Err<T> extends Result<T> {
  final Failure failure;
  const Err(this.failure);

  @override
  R when<R>({required R Function(T) ok, required R Function(Failure) err}) =>
      err(failure);
}
