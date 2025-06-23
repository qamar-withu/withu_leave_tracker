import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:withu_leave_tracker/domain/core/errors/failures.dart';

part 'value_objects.freezed.dart';

@freezed
class EmailAddress with _$EmailAddress {
  const EmailAddress._();
  const factory EmailAddress(String value) = _EmailAddress;

  Either<Failure, EmailAddress> get failureOrValue {
    return isValid()
        ? right(this)
        : left(const Failure.validationError('Invalid email address'));
  }

  bool isValid() {
    const emailRegex = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    return RegExp(emailRegex).hasMatch(value);
  }
}

@freezed
class Password with _$Password {
  const Password._();
  const factory Password(String value) = _Password;

  Either<Failure, Password> get failureOrValue {
    return isValid()
        ? right(this)
        : left(
            const Failure.validationError(
              'Password must be at least 6 characters',
            ),
          );
  }

  bool isValid() {
    return value.length >= 6;
  }
}

@freezed
class NonEmptyString with _$NonEmptyString {
  const NonEmptyString._();
  const factory NonEmptyString(String value) = _NonEmptyString;

  Either<Failure, NonEmptyString> get failureOrValue {
    return isValid()
        ? right(this)
        : left(const Failure.validationError('Field cannot be empty'));
  }

  bool isValid() {
    return value.trim().isNotEmpty;
  }
}

@freezed
class UniqueId with _$UniqueId {
  const factory UniqueId(String value) = _UniqueId;
}
