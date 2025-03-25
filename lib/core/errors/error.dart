abstract class Failure {
  final String message;

  Failure({required this.message});

  @override
  String toString() => message;
}

class ServerFailure extends Failure {
  ServerFailure({required super.message});
}

class ServerExecption extends Failure {
  ServerExecption({required super.message});
}

class CacheFailure extends Failure {
  CacheFailure({required super.message});
}

class NetworkFailure extends Failure {
  NetworkFailure({required super.message});
}

class ValidationFailure extends Failure {
  ValidationFailure({required super.message});
}
