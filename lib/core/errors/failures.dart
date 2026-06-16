import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final int? code;

  const Failure({required this.message, this.code});

  @override
  List<Object?> get props => [message, code];
}

class ServerFailure extends Failure {
  const ServerFailure({super.message = 'Server error occurred', super.code});
}

class CacheFailure extends Failure {
  const CacheFailure({super.message = 'Cache error occurred', super.code});
}

class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'Network error occurred', super.code});
}

class AuthFailure extends Failure {
  const AuthFailure({super.message = 'Authentication error', super.code});
}

class ValidationFailure extends Failure {
  const ValidationFailure({super.message = 'Validation error', super.code});
}

class StorageFailure extends Failure {
  const StorageFailure({super.message = 'Storage error occurred', super.code});
}
