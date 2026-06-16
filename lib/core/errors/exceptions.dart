class AppException implements Exception {
  final String message;
  final int? code;

  AppException({required this.message, this.code});

  @override
  String toString() => 'AppException: $message (code: $code)';
}

class ServerException extends AppException {
  ServerException({super.message = 'Server error', super.code});
}

class CacheException extends AppException {
  CacheException({super.message = 'Cache error', super.code});
}

class NetworkException extends AppException {
  NetworkException({super.message = 'Network error', super.code});
}

class AuthException extends AppException {
  AuthException({super.message = 'Auth error', super.code});
}

class ValidationException extends AppException {
  ValidationException({super.message = 'Validation error', super.code});
}

class StorageException extends AppException {
  StorageException({super.message = 'Storage error', super.code});
}
