import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure({this.message});

  final String? message;

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure({super.message, this.statusCode});

  final int? statusCode;

  @override
  List<Object?> get props => [message, statusCode];
}

class NetworkFailure extends Failure {
  const NetworkFailure({super.message});
}

class CacheFailure extends Failure {
  const CacheFailure({super.message});
}

class AuthFailure extends Failure {
  const AuthFailure({super.message});
}

class ValidationFailure extends Failure {
  const ValidationFailure({super.message, this.fieldErrors});

  final Map<String, String>? fieldErrors;

  @override
  List<Object?> get props => [message, fieldErrors];
}

class UnknownFailure extends Failure {
  const UnknownFailure({super.message});
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({super.message});
}

class PermissionFailure extends Failure {
  const PermissionFailure({super.message});
}
