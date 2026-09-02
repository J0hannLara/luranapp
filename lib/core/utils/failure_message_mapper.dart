import 'package:luranapp/core/constants/app_strings.dart';
import 'package:luranapp/core/errors/failures.dart';

class FailureMessageMapper {
  FailureMessageMapper._();

  static String toUserMessage(Failure failure) {
    return switch (failure) {
      NetworkFailure() => AppStrings.networkError,
      ServerFailure() => AppStrings.serverError,
      AuthFailure() => AppStrings.authError,
      ValidationFailure(:final message) =>
        message ?? AppStrings.validationError,
      NotFoundFailure(:final message) =>
        message ?? AppStrings.notFoundError,
      PermissionFailure(:final message) =>
        message ?? 'No tienes permiso para realizar esta acción.',
      CacheFailure() => AppStrings.genericError,
      UnknownFailure(:final message) => message ?? AppStrings.genericError,
      _ => AppStrings.genericError,
    };
  }
}
