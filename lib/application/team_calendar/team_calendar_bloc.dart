import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:withu_leave_tracker/application/auth/auth_bloc.dart';
import 'package:withu_leave_tracker/domain/leave_request/entities/leave_request.dart';
import 'package:withu_leave_tracker/domain/leave_request/repository/i_leave_request_repository.dart';
import 'package:withu_leave_tracker/domain/core/errors/failures.dart';

part 'team_calendar_bloc.freezed.dart';
part 'team_calendar_event.dart';
part 'team_calendar_state.dart';

@injectable
class TeamCalendarBloc extends Bloc<TeamCalendarEvent, TeamCalendarState> {
  final ILeaveRequestRepository _iLeaveRequestRepository;
  final AuthBloc _authBloc;

  TeamCalendarBloc(this._iLeaveRequestRepository, this._authBloc)
    : super(const TeamCalendarState.initial()) {
    on<_LoadTeamCalendar>(_onLoadTeamCalendar);
    on<_CreateLeave>(_onCreateLeave);
    on<_RefreshCalendar>(_onRefreshCalendar);
  }

  Future<void> _onLoadTeamCalendar(
    _LoadTeamCalendar event,
    Emitter<TeamCalendarState> emit,
  ) async {
    emit(const TeamCalendarState.loading());

    // Get user context from auth state, or use provided parameters
    String? teamId = event.teamId;
    String? projectId = event.projectId;

    final authState = _authBloc.state;
    authState.whenOrNull(
      authenticated: (user) {
        teamId ??= user.teamId.value;
        projectId ??= user.projectId.value;
      },
    );

    debugPrint(
      'Loading team calendar for teamId: $teamId, projectId: $projectId',
    );

    final result = await _iLeaveRequestRepository.getAllLeaveRequests(
      teamId: teamId,
      projectId: projectId,
    );

    result.fold(
      (failure) => emit(TeamCalendarState.error(failure)),
      (leaveRequests) => emit(TeamCalendarState.loaded(leaveRequests)),
    );
  }

  Future<void> _onCreateLeave(
    _CreateLeave event,
    Emitter<TeamCalendarState> emit,
  ) async {
    emit(const TeamCalendarState.creating());

    final result = await _iLeaveRequestRepository.createLeaveRequest(
      event.leaveRequest,
    );

    result.fold((failure) => emit(TeamCalendarState.error(failure)), (_) {
      emit(const TeamCalendarState.created());
      // Refresh the calendar after creating leave
      add(const TeamCalendarEvent.refreshCalendar());
    });
  }

  Future<void> _onRefreshCalendar(
    _RefreshCalendar event,
    Emitter<TeamCalendarState> emit,
  ) async {
    // Get user context from auth state, or use provided parameters
    String? teamId = event.teamId;
    String? projectId = event.projectId;

    final authState = _authBloc.state;
    authState.whenOrNull(
      authenticated: (user) {
        teamId ??= user.teamId.value;
        projectId ??= user.projectId.value;
      },
    );

    final result = await _iLeaveRequestRepository.getAllLeaveRequests(
      teamId: teamId,
      projectId: projectId,
    );

    result.fold(
      (failure) => emit(TeamCalendarState.error(failure)),
      (leaveRequests) => emit(TeamCalendarState.loaded(leaveRequests)),
    );
  }
}
