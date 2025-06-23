part of 'leave_request_bloc.dart';

@freezed
class LeaveRequestState with _$LeaveRequestState {
  const factory LeaveRequestState.initial() = _Initial;
  const factory LeaveRequestState.loading() = _Loading;
  const factory LeaveRequestState.loaded(List<LeaveRequest> requests) = _Loaded;
  const factory LeaveRequestState.submitting() = _Submitting;
  const factory LeaveRequestState.submitted() = _Submitted;
  const factory LeaveRequestState.error(Failure failure) = _Error;
}
