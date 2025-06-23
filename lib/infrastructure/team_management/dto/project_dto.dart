import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:withu_leave_tracker/domain/team_management/entities/project.dart';
import 'package:withu_leave_tracker/domain/core/value_objects/value_objects.dart';

part 'project_dto.freezed.dart';
part 'project_dto.g.dart';

@freezed
class ProjectDto with _$ProjectDto {
  const ProjectDto._();

  const factory ProjectDto({
    required String id,
    required String name,
    required String description,
    required DateTime startDate,
    DateTime? endDate,
    required String status,
    required String managerId,
    required DateTime createdAt,
    required DateTime updatedAt,
    List<String>? technologies,
    String? clientName,
    bool? isActive,
  }) = _ProjectDto;

  factory ProjectDto.fromJson(Map<String, dynamic> json) =>
      _$ProjectDtoFromJson(json);

  factory ProjectDto.fromDomain(Project project) {
    return ProjectDto(
      id: project.id.value,
      name: project.name.value,
      description: project.description.value,
      startDate: project.startDate,
      endDate: project.endDate,
      status: project.status.value,
      managerId: project.managerId.value,
      createdAt: project.createdAt,
      updatedAt: project.updatedAt,
      technologies: project.technologies,
      clientName: project.clientName,
      isActive: project.isActive,
    );
  }

  Project toDomain() {
    return Project(
      id: UniqueId(id),
      name: NonEmptyString(name),
      description: NonEmptyString(description),
      startDate: startDate,
      endDate: endDate,
      status: NonEmptyString(status),
      managerId: UniqueId(managerId),
      createdAt: createdAt,
      updatedAt: updatedAt,
      technologies: technologies,
      clientName: clientName,
      isActive: isActive,
    );
  }
}
