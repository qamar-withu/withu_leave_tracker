import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:withu_leave_tracker/domain/dashboard/repository/dashboard_repository.dart';
import 'package:withu_leave_tracker/domain/dashboard/entities/dashboard_stats.dart';
import 'package:withu_leave_tracker/domain/leave_request/entities/leave_request.dart';
import 'package:withu_leave_tracker/domain/core/errors/failures.dart';
import 'package:withu_leave_tracker/infrastructure/dashboard/datasources/dashboard_remote_data_source.dart';

@LazySingleton(as: DashboardRepository)
class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource _remoteDataSource;

  DashboardRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, DashboardStats>> getDashboardStats(
    String userId,
  ) async {
    try {
      final stats = await _remoteDataSource.getDashboardStats(userId);
      return right(stats);
    } catch (e) {
      return left(Failure.serverError(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<LeaveRequest>>> getRecentLeaveRequests(
    String userId,
  ) async {
    try {
      final requests = await _remoteDataSource.getRecentLeaveRequests(userId);
      return right(requests);
    } catch (e) {
      return left(Failure.serverError(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, DashboardStats>> watchDashboardStats(String userId) {
    return _remoteDataSource
        .watchDashboardStats(userId)
        .map((stats) => right<Failure, DashboardStats>(stats))
        .handleError(
          (error) => left<Failure, DashboardStats>(
            Failure.serverError(error.toString()),
          ),
        );
  }

  @override
  Stream<Either<Failure, List<LeaveRequest>>> watchRecentLeaveRequests(
    String userId,
  ) {
    return _remoteDataSource
        .watchRecentLeaveRequests(userId)
        .map((requests) => right<Failure, List<LeaveRequest>>(requests))
        .handleError(
          (error) => left<Failure, List<LeaveRequest>>(
            Failure.serverError(error.toString()),
          ),
        );
  }
}
