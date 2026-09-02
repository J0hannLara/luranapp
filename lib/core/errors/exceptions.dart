class ServerException implements Exception {
  const ServerException({this.message, this.statusCode});

  final String? message;
  final int? statusCode;

  @override
  String toString() => 'ServerException: $message (code: $statusCode)';
}

class ImageException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  ImageException(this.message, {this.code, this.originalError});

  @override
  String toString() {
    final codeStr = code != null ? ' [$code]' : '';
    final errorStr = originalError != null ? ' - Original: $originalError' : '';
    return 'ImageException$codeStr: $message$errorStr';
  }
}

// Agregar a lib/core/errors/exceptions.dart
class LocationException implements Exception {
  final String message;

  LocationException(this.message);

  @override
  String toString() => 'LocationException: $message';
}

class NetworkException implements Exception {
  const NetworkException({this.message});

  final String? message;

  @override
  String toString() => 'NetworkException: $message';
}

class CacheException implements Exception {
  const CacheException({this.message});

  final String? message;

  @override
  String toString() => 'CacheException: $message';
}

class AuthException implements Exception {
  const AuthException({this.message});

  final String? message;

  @override
  String toString() => 'AuthException: $message';
}

class ValidationException implements Exception {
  const ValidationException({this.message, this.fieldErrors});

  final String? message;
  final Map<String, String>? fieldErrors;

  @override
  String toString() => 'ValidationException: $message';
}

class DatabaseException implements Exception {
  final String message;

  DatabaseException(this.message);

  @override
  String toString() => 'DatabaseException: $message';
}

class PermissionException implements Exception {
  final String message;

  PermissionException(this.message);

  @override
  String toString() => 'PermissionException: $message';
}

class AppAuthException implements Exception {
  final String message;

  AppAuthException(this.message);

  @override
  String toString() => 'AppAuthException: $message';
}
