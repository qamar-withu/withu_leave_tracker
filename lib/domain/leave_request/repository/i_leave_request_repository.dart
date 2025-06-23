import 'package:dartz/dartz.dart';
import 'package:withu_leave_tracker/domain/core/errors/failures.dart';
import 'package:withu_leave_tracker/domain/leave_request/entities/leave_request.dart';
import 'package:withu_leave_tracker/domain/core/value_objects/value_objects.dart';
import 'package:withu_leave_tracker/domain/leave_request/value_objects/leave_request_status.dart';

abstract class ILeaveRequestRepository {
  Future<Either<Failure, Unit>> createLeaveRequest(LeaveRequest leaveRequest);

  Future<Either<Failure, List<LeaveRequest>>> getLeaveRequests({
    String? userId,
    String? teamId,
  });

  Future<Either<Failure, List<LeaveRequest>>> getLeaveRequestsByUser({
    required UniqueId userId,
  });

  Future<Either<Failure, List<LeaveRequest>>> getLeaveRequestsByTeam({
    required UniqueId teamId,
  });

  Future<Either<Failure, List<LeaveRequest>>> getAllLeaveRequests({
    String? teamId,
    String? projectId,
  });

  Future<Either<Failure, Unit>> updateLeaveRequestStatus({
    required String requestId,
    required LeaveRequestStatus status,
    required String managerId,
    String? comments,
  });

  Future<Either<Failure, Unit>> deleteLeaveRequest(String requestId);

  Future<Either<Failure, LeaveRequest>> getLeaveRequestById({
    required UniqueId requestId,
  });

  Stream<Either<Failure, List<LeaveRequest>>> watchLeaveRequestsByUser({
    required UniqueId userId,
  });

  Stream<Either<Failure, List<LeaveRequest>>> watchPendingLeaveRequests();
}
