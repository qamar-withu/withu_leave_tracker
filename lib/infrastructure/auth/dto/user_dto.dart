import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:withu_leave_tracker/domain/auth/entities/user.dart';
import 'package:withu_leave_tracker/domain/auth/value_objects/user_role.dart';
import 'package:withu_leave_tracker/domain/core/value_objects/value_objects.dart';

part 'user_dto.freezed.dart';
part 'user_dto.g.dart';

@freezed
class UserDto with _$UserDto {
  const UserDto._();

  const factory UserDto({
    required String id,
    required String firstName,
    required String lastName,
    required String email,
    required String role,
    required String teamId,
    required String projectId,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? profileImageUrl,
    String? phoneNumber,
    String? address,
    DateTime? dateOfJoining,
    @Default(true) bool isActive,
  }) = _UserDto;

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);

  factory UserDto.fromDomain(User user) {
    return UserDto(
      id: user.id.value,
      firstName: user.firstName.value,
      lastName: user.lastName.value,
      email: user.email.value,
      role: user.role.name,
      teamId: user.teamId.value,
      projectId: user.projectId.value,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
      profileImageUrl: user.profileImageUrl,
      phoneNumber: user.phoneNumber,
      address: user.address,
      dateOfJoining: user.dateOfJoining,
      isActive: user.isActive ?? true,
    );
  }

  User toDomain() {
    return User(
      id: UniqueId(id),
      firstName: NonEmptyString(firstName),
      lastName: NonEmptyString(lastName),
      email: EmailAddress(email),
      role: UserRole.fromString(role),
      teamId: UniqueId(teamId),
      projectId: UniqueId(projectId),
      createdAt: createdAt,
      updatedAt: updatedAt,
      profileImageUrl: profileImageUrl,
      phoneNumber: phoneNumber,
      address: address,
      dateOfJoining: dateOfJoining,
      isActive: isActive,
    );
  }
}
