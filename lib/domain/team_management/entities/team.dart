import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:withu_leave_tracker/domain/core/value_objects/value_objects.dart';

part 'team.freezed.dart';

@freezed
class Team with _$Team {
  const Team._();

  const factory Team({
    required UniqueId id,
    required NonEmptyString name,
    required NonEmptyString description,
    required UniqueId projectId,
    required UniqueId managerId,
    required List<String> memberIds,
    required DateTime createdAt,
    required DateTime updatedAt,
    int? maxMembers,
    bool? isActive,
  }) = _Team;

  factory Team.empty() => Team(
    id: const UniqueId(''),
    name: const NonEmptyString(''),
    description: const NonEmptyString(''),
    projectId: const UniqueId(''),
    managerId: const UniqueId(''),
    memberIds: const [],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    isActive: true,
  );

  int get memberCount => memberIds.length;
  bool get hasMaxMembers => maxMembers != null && memberCount >= maxMembers!;
}
