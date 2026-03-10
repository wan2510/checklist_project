/// Base class cho tất cả UseCase có params
abstract class UseCase<Type, Params> {
  Future<Type> call(Params params);
}

/// Base class cho UseCase không có params
abstract class UseCaseNoParams<Type> {
  Future<Type> call();
}

/// Base class cho Stream UseCase có params
abstract class StreamUseCase<Type, Params> {
  Stream<Type> call(Params params);
}

/// Base class cho Stream UseCase không có params
abstract class StreamUseCaseNoParams<Type> {
  Stream<Type> call();
}