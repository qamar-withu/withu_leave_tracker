import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_stats.freezed.dart';

@freezed
class DashboardStats with _$DashboardStats {
  const factory DashboardStats({
    required int pendingRequests,
    required int approvedRequests,
    required int rejectedRequests,
    required int remainingLeaveDays,
    required int teamPendingRequests,
    required int totalLeaveDays,
    required int usedLeaveDays,
  }) = _DashboardStats;
}
