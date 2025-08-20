import 'package:pocketa/core/result/result.dart';

abstract class UseCase<Out, In> {
  Future<Result<Out>> call(In params);
}

class NoParams {
  const NoParams();
}
