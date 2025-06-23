part of 'dashboard_bloc.dart';

@freezed
class DashboardEvent with _$DashboardEvent {
  const factory DashboardEvent.loadDashboardData({required String userId}) =
      _LoadDashboardData;

  const factory DashboardEvent.refreshDashboard({required String userId}) =
      _RefreshDashboard;
}
