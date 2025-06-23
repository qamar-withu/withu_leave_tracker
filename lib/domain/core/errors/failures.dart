import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

@freezed
class Failure with _$Failure {
  const factory Failure.serverError([String? message]) = _ServerError;
  const factory Failure.networkError([String? message]) = _NetworkError;
  const factory Failure.authenticationFailure([String? message]) = _AuthenticationFailure;
  const factory Failure.permissionDenied([String? message]) = _PermissionDenied;
  const factory Failure.notFound([String? message]) = _NotFound;
  const factory Failure.validationError(String message) = _ValidationError;
  const factory Failure.unknownError([String? message]) = _UnknownError;
}
