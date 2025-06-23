part of 'leave_request_bloc.dart';

@freezed
class LeaveRequestEvent with _$LeaveRequestEvent {
  const factory LeaveRequestEvent.loadLeaveRequests({
    String? userId,
    String? teamId,
  }) = _LoadLeaveRequests;

  const factory LeaveRequestEvent.createLeaveRequest({
    required LeaveRequest request,
  }) = _CreateLeaveRequest;

  const factory LeaveRequestEvent.updateLeaveRequestStatus({
    required String requestId,
    required LeaveRequestStatus status,
    required String managerId,
    String? comments,
  }) = _UpdateLeaveRequestStatus;

  const factory LeaveRequestEvent.deleteLeaveRequest({
    required String requestId,
  }) = _DeleteLeaveRequest;
}
