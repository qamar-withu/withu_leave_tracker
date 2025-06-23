part of 'team_management_bloc.dart';

@freezed
class TeamManagementEvent with _$TeamManagementEvent {
  const factory TeamManagementEvent.loadTeams() = _LoadTeams;

  const factory TeamManagementEvent.loadProjects() = _LoadProjects;

  const factory TeamManagementEvent.loadTeamMembers({required String teamId}) =
      _LoadTeamMembers;

  const factory TeamManagementEvent.createTeam({required Team team}) =
      _CreateTeam;

  const factory TeamManagementEvent.updateTeam({required Team team}) =
      _UpdateTeam;

  const factory TeamManagementEvent.deleteTeam({required String teamId}) =
      _DeleteTeam;

  const factory TeamManagementEvent.addTeamMember({
    required String teamId,
    required String userId,
  }) = _AddTeamMember;

  const factory TeamManagementEvent.removeTeamMember({
    required String teamId,
    required String userId,
  }) = _RemoveTeamMember;
}
