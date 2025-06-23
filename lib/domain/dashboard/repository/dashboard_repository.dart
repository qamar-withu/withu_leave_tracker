import 'package:dartz/dartz.dart';
import 'package:withu_leave_tracker/domain/dashboard/entities/dashboard_stats.dart';
import 'package:withu_leave_tracker/domain/leave_request/entities/leave_request.dart';
import 'package:withu_leave_tracker/domain/core/errors/failures.dart';

abstract class DashboardRepository {
  Future<Either<Failure, DashboardStats>> getDashboardStats(String userId);
  Future<Either<Failure, List<LeaveRequest>>> getRecentLeaveRequests(
    String userId,
  );

  // Real-time streams
  Stream<Either<Failure, DashboardStats>> watchDashboardStats(String userId);
  Stream<Either<Failure, List<LeaveRequest>>> watchRecentLeaveRequests(
    String userId,
  );
}
