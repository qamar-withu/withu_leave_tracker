part of 'team_management_bloc.dart';

@freezed
class TeamManagementState with _$TeamManagementState {
  const factory TeamManagementState.initial() = _Initial;
  const factory TeamManagementState.loading() = _Loading;
  const factory TeamManagementState.teamsLoaded(List<Team> teams) =
      _TeamsLoaded;
  const factory TeamManagementState.projectsLoaded(List<Project> projects) =
      _ProjectsLoaded;
  const factory TeamManagementState.teamMembersLoaded(List<User> members) =
      _TeamMembersLoaded;
  const factory TeamManagementState.submitting() = _Submitting;
  const factory TeamManagementState.submitted() = _Submitted;
  const factory TeamManagementState.error(Failure failure) = _Error;
}
