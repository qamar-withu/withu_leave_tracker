part of 'team_calendar_bloc.dart';

@freezed
class TeamCalendarState with _$TeamCalendarState {
  const factory TeamCalendarState.initial() = _Initial;
  const factory TeamCalendarState.loading() = _Loading;
  const factory TeamCalendarState.loaded(List<LeaveRequest> leaveRequests) =
      _Loaded;
  const factory TeamCalendarState.creating() = _Creating;
  const factory TeamCalendarState.created() = _Created;
  const factory TeamCalendarState.error(Failure failure) = _Error;
}
