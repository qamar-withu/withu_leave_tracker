import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:withu_leave_tracker/domain/leave_request/entities/leave_request.dart';
import 'package:withu_leave_tracker/domain/leave_request/repository/i_leave_request_repository.dart';
import 'package:withu_leave_tracker/domain/leave_request/value_objects/leave_request_status.dart';
import 'package:withu_leave_tracker/domain/core/errors/failures.dart';

part 'leave_request_bloc.freezed.dart';
part 'leave_request_event.dart';
part 'leave_request_state.dart';

@injectable
class LeaveRequestBloc extends Bloc<LeaveRequestEvent, LeaveRequestState> {
  final ILeaveRequestRepository _repository;

  LeaveRequestBloc(this._repository)
    : super(const LeaveRequestState.initial()) {
    on<_LoadLeaveRequests>(_onLoadLeaveRequests);
    on<_CreateLeaveRequest>(_onCreateLeaveRequest);
    on<_UpdateLeaveRequestStatus>(_onUpdateLeaveRequestStatus);
    on<_DeleteLeaveRequest>(_onDeleteLeaveRequest);
  }

  Future<void> _onLoadLeaveRequests(
    _LoadLeaveRequests event,
    Emitter<LeaveRequestState> emit,
  ) async {
    emit(const LeaveRequestState.loading());

    final result = await _repository.getLeaveRequests(
      userId: event.userId,
      teamId: event.teamId,
    );

    result.fold(
      (failure) => emit(LeaveRequestState.error(failure)),
      (requests) => emit(LeaveRequestState.loaded(requests)),
    );
  }

  Future<void> _onCreateLeaveRequest(
    _CreateLeaveRequest event,
    Emitter<LeaveRequestState> emit,
  ) async {
    emit(const LeaveRequestState.submitting());

    final result = await _repository.createLeaveRequest(event.request);

    result.fold(
      (failure) => emit(LeaveRequestState.error(failure)),
      (_) => emit(const LeaveRequestState.submitted()),
    );
  }

  Future<void> _onUpdateLeaveRequestStatus(
    _UpdateLeaveRequestStatus event,
    Emitter<LeaveRequestState> emit,
  ) async {
    emit(const LeaveRequestState.submitting());

    final result = await _repository.updateLeaveRequestStatus(
      requestId: event.requestId,
      status: event.status,
      managerId: event.managerId,
      comments: event.comments,
    );

    result.fold(
      (failure) => emit(LeaveRequestState.error(failure)),
      (_) => emit(const LeaveRequestState.submitted()),
    );
  }

  Future<void> _onDeleteLeaveRequest(
    _DeleteLeaveRequest event,
    Emitter<LeaveRequestState> emit,
  ) async {
    emit(const LeaveRequestState.submitting());

    final result = await _repository.deleteLeaveRequest(event.requestId);

    result.fold(
      (failure) => emit(LeaveRequestState.error(failure)),
      (_) => emit(const LeaveRequestState.submitted()),
    );
  }
}
