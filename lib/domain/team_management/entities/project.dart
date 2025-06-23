import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:withu_leave_tracker/domain/core/value_objects/value_objects.dart';

part 'project.freezed.dart';

@freezed
class Project with _$Project {
  const Project._();

  const factory Project({
    required UniqueId id,
    required NonEmptyString name,
    required NonEmptyString description,
    required DateTime startDate,
    DateTime? endDate,
    required NonEmptyString status,
    required UniqueId managerId,
    required DateTime createdAt,
    required DateTime updatedAt,
    List<String>? technologies,
    String? clientName,
    bool? isActive,
  }) = _Project;

  factory Project.empty() => Project(
    id: const UniqueId(''),
    name: const NonEmptyString(''),
    description: const NonEmptyString(''),
    startDate: DateTime.now(),
    status: const NonEmptyString('active'),
    managerId: const UniqueId(''),
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    isActive: true,
  );

  bool get isCompleted => status.value.toLowerCase() == 'completed';
  bool get isOngoing => status.value.toLowerCase() == 'active';
}
