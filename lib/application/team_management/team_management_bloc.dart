import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:withu_leave_tracker/domain/team_management/entities/team.dart';
import 'package:withu_leave_tracker/domain/team_management/entities/project.dart';
import 'package:withu_leave_tracker/domain/auth/entities/user.dart';
import 'package:withu_leave_tracker/domain/team_management/repository/team_management_repository.dart';
import 'package:withu_leave_tracker/domain/core/errors/failures.dart';
import 'package:withu_leave_tracker/domain/core/value_objects/value_objects.dart';

part 'team_management_bloc.freezed.dart';
part 'team_management_event.dart';
part 'team_management_state.dart';

@injectable
class TeamManagementBloc
    extends Bloc<TeamManagementEvent, TeamManagementState> {
  final TeamManagementRepository _repository;

  TeamManagementBloc(this._repository)
    : super(const TeamManagementState.initial()) {
    on<_LoadTeams>(_onLoadTeams);
    on<_LoadProjects>(_onLoadProjects);
    on<_LoadTeamMembers>(_onLoadTeamMembers);
    on<_CreateTeam>(_onCreateTeam);
    on<_UpdateTeam>(_onUpdateTeam);
    on<_DeleteTeam>(_onDeleteTeam);
    on<_AddTeamMember>(_onAddTeamMember);
    on<_RemoveTeamMember>(_onRemoveTeamMember);
  }

  Future<void> _onLoadTeams(
    _LoadTeams event,
    Emitter<TeamManagementState> emit,
  ) async {
    emit(const TeamManagementState.loading());

    final result = await _repository.getTeams();

    result.fold(
      (failure) => emit(TeamManagementState.error(failure)),
      (teams) => emit(TeamManagementState.teamsLoaded(teams)),
    );
  }

  Future<void> _onLoadProjects(
    _LoadProjects event,
    Emitter<TeamManagementState> emit,
  ) async {
    emit(const TeamManagementState.loading());

    final result = await _repository.getProjects();

    result.fold(
      (failure) => emit(TeamManagementState.error(failure)),
      (projects) => emit(TeamManagementState.projectsLoaded(projects)),
    );
  }

  Future<void> _onLoadTeamMembers(
    _LoadTeamMembers event,
    Emitter<TeamManagementState> emit,
  ) async {
    emit(const TeamManagementState.loading());

    final result = await _repository.getTeamMembers(
      teamId: UniqueId(event.teamId),
    );

    result.fold(
      (failure) => emit(TeamManagementState.error(failure)),
      (members) => emit(TeamManagementState.teamMembersLoaded(members)),
    );
  }

  Future<void> _onCreateTeam(
    _CreateTeam event,
    Emitter<TeamManagementState> emit,
  ) async {
    emit(const TeamManagementState.submitting());

    final result = await _repository.createTeam(event.team);

    result.fold(
      (failure) => emit(TeamManagementState.error(failure)),
      (_) => emit(const TeamManagementState.submitted()),
    );
  }

  Future<void> _onUpdateTeam(
    _UpdateTeam event,
    Emitter<TeamManagementState> emit,
  ) async {
    emit(const TeamManagementState.submitting());

    final result = await _repository.updateTeam(
      teamId: event.team.id,
      updates: {
        'name': event.team.name.value,
        'description': event.team.description?.value,
        'updatedAt': DateTime.now().toIso8601String(),
      },
    );

    result.fold(
      (failure) => emit(TeamManagementState.error(failure)),
      (_) => emit(const TeamManagementState.submitted()),
    );
  }

  Future<void> _onDeleteTeam(
    _DeleteTeam event,
    Emitter<TeamManagementState> emit,
  ) async {
    emit(const TeamManagementState.submitting());

    final result = await _repository.deleteTeam(teamId: UniqueId(event.teamId));

    result.fold(
      (failure) => emit(TeamManagementState.error(failure)),
      (_) => emit(const TeamManagementState.submitted()),
    );
  }

  Future<void> _onAddTeamMember(
    _AddTeamMember event,
    Emitter<TeamManagementState> emit,
  ) async {
    emit(const TeamManagementState.submitting());

    final result = await _repository.addTeamMember(
      teamId: UniqueId(event.teamId),
      userId: UniqueId(event.userId),
    );

    result.fold(
      (failure) => emit(TeamManagementState.error(failure)),
      (_) => emit(const TeamManagementState.submitted()),
    );
  }

  Future<void> _onRemoveTeamMember(
    _RemoveTeamMember event,
    Emitter<TeamManagementState> emit,
  ) async {
    emit(const TeamManagementState.submitting());

    final result = await _repository.removeTeamMember(
      teamId: UniqueId(event.teamId),
      userId: UniqueId(event.userId),
    );

    result.fold(
      (failure) => emit(TeamManagementState.error(failure)),
      (_) => emit(const TeamManagementState.submitted()),
    );
  }
}
