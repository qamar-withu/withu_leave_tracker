import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:withu_leave_tracker/domain/core/value_objects/value_objects.dart';
import 'package:withu_leave_tracker/domain/auth/value_objects/user_role.dart';

part 'user.freezed.dart';

@freezed
class User with _$User {
  const User._();

  const factory User({
    required UniqueId id,
    required NonEmptyString firstName,
    required NonEmptyString lastName,
    required EmailAddress email,
    required UserRole role,
    required UniqueId teamId,
    required UniqueId projectId,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? profileImageUrl,
    String? phoneNumber,
    String? address,
    DateTime? dateOfJoining,
    bool? isActive,
  }) = _User;

  factory User.empty() => User(
    id: const UniqueId(''),
    firstName: const NonEmptyString(''),
    lastName: const NonEmptyString(''),
    email: const EmailAddress(''),
    role: UserRole.employee,
    teamId: const UniqueId(''),
    projectId: const UniqueId(''),
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    isActive: true,
  );

  String get fullName => '${firstName.value} ${lastName.value}';
  String get name => fullName;

  bool get isAdmin => role == UserRole.admin;
  bool get isManager => role == UserRole.manager;
  bool get isEmployee => role == UserRole.employee;
}
