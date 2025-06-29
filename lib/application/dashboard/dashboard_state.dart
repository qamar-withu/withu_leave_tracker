part of 'dashboard_bloc.dart';

@freezed
class DashboardState with _$DashboardState {
  const factory DashboardState.initial() = _Initial;
  const factory DashboardState.loading() = _Loading;
  const factory DashboardState.loaded(
    DashboardStats stats,
    List<LeaveRequest> recentRequests,
  ) = _Loaded;
  const factory DashboardState.error(Failure failure) = _Error;
}
