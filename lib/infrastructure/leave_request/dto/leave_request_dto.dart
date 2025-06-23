import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:withu_leave_tracker/domain/leave_request/entities/leave_request.dart';
import 'package:withu_leave_tracker/domain/leave_request/value_objects/leave_request_status.dart';
import 'package:withu_leave_tracker/domain/leave_request/value_objects/leave_request_type.dart';
import 'package:withu_leave_tracker/domain/core/value_objects/value_objects.dart';

part 'leave_request_dto.freezed.dart';
part 'leave_request_dto.g.dart';

@freezed
class LeaveRequestDto with _$LeaveRequestDto {
  const LeaveRequestDto._();

  const factory LeaveRequestDto({
    required String id,
    required String userId,
    String? userName,
    required String teamId,
    String? projectId,
    required String leaveType,
    required DateTime startDate,
    required DateTime endDate,
    required String reason,
    String? comments,
    required String status,
    required DateTime requestedAt,
    String? managerId,
    String? managerComments,
    DateTime? approvedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    @Default(false) bool isHalfDay,
    @Default(1) int totalDays,
    @Default([]) List<String> attachments,
  }) = _LeaveRequestDto;

  factory LeaveRequestDto.fromJson(Map<String, dynamic> json) =>
      _$LeaveRequestDtoFromJson(json);

  factory LeaveRequestDto.fromDomain(LeaveRequest leaveRequest) {
    return LeaveRequestDto(
      id: leaveRequest.id.value,
      userId: leaveRequest.userId.value,
      userName: leaveRequest.userName,
      teamId: leaveRequest.teamId.value,
      projectId: leaveRequest.projectId?.value,
      leaveType: leaveRequest.type.value,
      startDate: leaveRequest.startDate,
      endDate: leaveRequest.endDate,
      reason: leaveRequest.reason,
      comments: leaveRequest.comments,
      status: leaveRequest.status.value,
      requestedAt: leaveRequest.requestedAt,
      managerId: leaveRequest.managerId?.value,
      managerComments: leaveRequest.managerComments,
      approvedAt: leaveRequest.approvedAt,
      createdAt: leaveRequest.createdAt ?? DateTime.now(),
      updatedAt: leaveRequest.updatedAt ?? DateTime.now(),
      isHalfDay: leaveRequest.isHalfDay ?? false,
      totalDays: leaveRequest.totalDays ?? 1,
      attachments: leaveRequest.attachments ?? [],
    );
  }

  LeaveRequest toDomain() {
    return LeaveRequest(
      id: UniqueId(id),
      userId: UniqueId(userId),
      userName: userName,
      teamId: UniqueId(teamId),
      projectId: projectId != null ? UniqueId(projectId!) : null,
      type: LeaveRequestTypeExtension.fromString(leaveType),
      startDate: startDate,
      endDate: endDate,
      reason: reason,
      comments: comments,
      status: LeaveRequestStatusExtension.fromString(status),
      requestedAt: requestedAt,
      managerId: managerId != null ? UniqueId(managerId!) : null,
      managerComments: managerComments,
      approvedAt: approvedAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isHalfDay: isHalfDay,
      totalDays: totalDays,
      attachments: attachments,
    );
  }
}
