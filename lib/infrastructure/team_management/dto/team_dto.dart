import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:withu_leave_tracker/domain/team_management/entities/team.dart';
import 'package:withu_leave_tracker/domain/core/value_objects/value_objects.dart';

part 'team_dto.freezed.dart';
part 'team_dto.g.dart';

@freezed
class TeamDto with _$TeamDto {
  const TeamDto._();

  const factory TeamDto({
    required String id,
    required String name,
    required String description,
    required String projectId,
    required String managerId,
    required List<String> memberIds,
    required DateTime createdAt,
    required DateTime updatedAt,
    int? maxMembers,
    bool? isActive,
  }) = _TeamDto;

  factory TeamDto.fromJson(Map<String, dynamic> json) =>
      _$TeamDtoFromJson(json);

  factory TeamDto.fromDomain(Team team) {
    return TeamDto(
      id: team.id.value,
      name: team.name.value,
      description: team.description.value,
      projectId: team.projectId.value,
      managerId: team.managerId.value,
      memberIds: team.memberIds,
      createdAt: team.createdAt,
      updatedAt: team.updatedAt,
      maxMembers: team.maxMembers,
      isActive: team.isActive,
    );
  }

  Team toDomain() {
    return Team(
      id: UniqueId(id),
      name: NonEmptyString(name),
      description: NonEmptyString(description),
      projectId: UniqueId(projectId),
      managerId: UniqueId(managerId),
      memberIds: memberIds,
      createdAt: createdAt,
      updatedAt: updatedAt,
      maxMembers: maxMembers,
      isActive: isActive,
    );
  }
}
