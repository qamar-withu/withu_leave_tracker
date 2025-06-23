part of 'team_calendar_bloc.dart';

@freezed
class TeamCalendarEvent with _$TeamCalendarEvent {
  const factory TeamCalendarEvent.loadTeamCalendar({
    String? teamId,
    String? projectId,
  }) = _LoadTeamCalendar;
  const factory TeamCalendarEvent.createLeave({
    required LeaveRequest leaveRequest,
  }) = _CreateLeave;
  const factory TeamCalendarEvent.refreshCalendar({
    String? teamId,
    String? projectId,
  }) = _RefreshCalendar;
}
