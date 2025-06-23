import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:withu_leave_tracker/domain/core/errors/failures.dart';
import 'package:withu_leave_tracker/domain/leave_request/entities/leave_request.dart';
import 'package:withu_leave_tracker/domain/leave_request/repository/i_leave_request_repository.dart';
import 'package:withu_leave_tracker/domain/leave_request/value_objects/leave_request_status.dart';
import 'package:withu_leave_tracker/domain/core/value_objects/value_objects.dart';
import 'package:withu_leave_tracker/infrastructure/leave_request/datasource/leave_request_datasource.dart';
import 'package:withu_leave_tracker/infrastructure/leave_request/dto/leave_request_dto.dart';

@LazySingleton(as: ILeaveRequestRepository)
class ILeaveRequestRepositoryImpl implements ILeaveRequestRepository {
  final LeaveRequestDataSource _dataSource;

  ILeaveRequestRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, Unit>> createLeaveRequest(
    LeaveRequest leaveRequest,
  ) async {
    try {
      final dto = LeaveRequestDto.fromDomain(leaveRequest);
      await _dataSource.createLeaveRequest(dto);
      return right(unit);
    } catch (e) {
      return left(Failure.serverError(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<LeaveRequest>>> getLeaveRequests({
    String? userId,
    String? teamId,
  }) async {
    try {
      List<LeaveRequestDto> dtos;
      if (userId != null) {
        dtos = await _dataSource.getLeaveRequestsByUser(userId: userId);
      } else if (teamId != null) {
        dtos = await _dataSource.getLeaveRequestsByTeam(
          userIds: [],
        ); // This needs team member IDs
      } else {
        dtos = await _dataSource.getAllLeaveRequests();
      }

      final requests = dtos.map((dto) => dto.toDomain()).toList();
      return right(requests);
    } catch (e) {
      return left(Failure.serverError(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<LeaveRequest>>> getLeaveRequestsByUser({
    required UniqueId userId,
  }) async {
    try {
      final dtos = await _dataSource.getLeaveRequestsByUser(
        userId: userId.value,
      );
      final requests = dtos.map((dto) => dto.toDomain()).toList();
      return right(requests);
    } catch (e) {
      return left(Failure.serverError(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<LeaveRequest>>> getLeaveRequestsByTeam({
    required UniqueId teamId,
  }) async {
    try {
      // This would need to get team member IDs first
      final dtos = await _dataSource.getLeaveRequestsByTeam(userIds: []);
      final requests = dtos.map((dto) => dto.toDomain()).toList();
      return right(requests);
    } catch (e) {
      return left(Failure.serverError(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<LeaveRequest>>> getAllLeaveRequests({
    String? teamId,
    String? projectId,
  }) async {
    try {
      final dtos = await _dataSource.getAllLeaveRequests(
        teamId: teamId,
        projectId: projectId,
      );
      final requests = dtos.map((dto) => dto.toDomain()).toList();
      return right(requests);
    } catch (e) {
      return left(Failure.serverError(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateLeaveRequestStatus({
    required String requestId,
    required LeaveRequestStatus status,
    required String managerId,
    String? comments,
  }) async {
    try {
      final updates = <String, dynamic>{
        'status': status.value,
        'managerId': managerId,
        'updatedAt': DateTime.now(),
      };
      if (comments != null) {
        updates['managerComments'] = comments;
      }
      if (status == LeaveRequestStatus.approved ||
          status == LeaveRequestStatus.rejected) {
        updates['approvedAt'] = DateTime.now();
      }

      await _dataSource.updateLeaveRequestStatus(
        requestId: requestId,
        updates: updates,
      );
      return right(unit);
    } catch (e) {
      return left(Failure.serverError(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteLeaveRequest(String requestId) async {
    try {
      await _dataSource.deleteLeaveRequest(requestId: requestId);
      return right(unit);
    } catch (e) {
      return left(Failure.serverError(e.toString()));
    }
  }

  @override
  Future<Either<Failure, LeaveRequest>> getLeaveRequestById({
    required UniqueId requestId,
  }) async {
    try {
      final dto = await _dataSource.getLeaveRequestById(
        requestId: requestId.value,
      );
      if (dto != null) {
        return right(dto.toDomain());
      } else {
        return left(const Failure.notFound('Leave request not found'));
      }
    } catch (e) {
      return left(Failure.serverError(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, List<LeaveRequest>>> watchLeaveRequestsByUser({
    required UniqueId userId,
  }) {
    return _dataSource
        .watchLeaveRequestsByUser(userId: userId.value)
        .map(
          (dtos) =>
              Right<Failure, List<LeaveRequest>>(
                    dtos.map((dto) => dto.toDomain()).toList(),
                  )
                  as Either<Failure, List<LeaveRequest>>,
        )
        .onErrorReturn(
          const Left<Failure, List<LeaveRequest>>(
                Failure.serverError('Failed to watch leave requests'),
              )
              as Either<Failure, List<LeaveRequest>>,
        );
  }

  @override
  Stream<Either<Failure, List<LeaveRequest>>> watchPendingLeaveRequests() {
    return _dataSource
        .watchPendingLeaveRequests()
        .map(
          (dtos) =>
              Right<Failure, List<LeaveRequest>>(
                    dtos.map((dto) => dto.toDomain()).toList(),
                  )
                  as Either<Failure, List<LeaveRequest>>,
        )
        .onErrorReturn(
          const Left<Failure, List<LeaveRequest>>(
                Failure.serverError('Failed to watch pending leave requests'),
              )
              as Either<Failure, List<LeaveRequest>>,
        );
  }
}
