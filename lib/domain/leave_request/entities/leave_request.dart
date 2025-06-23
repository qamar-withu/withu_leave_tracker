import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:withu_leave_tracker/domain/core/value_objects/value_objects.dart';
import 'package:withu_leave_tracker/domain/leave_request/value_objects/leave_request_status.dart';
import 'package:withu_leave_tracker/domain/leave_request/value_objects/leave_request_type.dart';

part 'leave_request.freezed.dart';

@freezed
class LeaveRequest with _$LeaveRequest {
  const LeaveRequest._();

  const factory LeaveRequest({
    required UniqueId id,
    required UniqueId userId,
    String? userName,
    required UniqueId teamId,
    UniqueId? projectId,
    required LeaveRequestType type,
    required DateTime startDate,
    required DateTime endDate,
    required String reason,
    String? comments,
    required LeaveRequestStatus status,
    required DateTime requestedAt,
    UniqueId? managerId,
    String? managerComments,
    DateTime? approvedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isHalfDay,
    int? totalDays,
    List<String>? attachments,
  }) = _LeaveRequest;

  factory LeaveRequest.empty() => LeaveRequest(
    id: const UniqueId(''),
    userId: const UniqueId(''),
    teamId: const UniqueId(''),
    type: LeaveRequestType.annual,
    startDate: DateTime.now(),
    endDate: DateTime.now(),
    reason: '',
    status: LeaveRequestStatus.pending,
    requestedAt: DateTime.now(),
    totalDays: 1,
    isHalfDay: false,
  );

  bool get isPending => status == LeaveRequestStatus.pending;
  bool get isApproved => status == LeaveRequestStatus.approved;
  bool get isRejected => status == LeaveRequestStatus.rejected;

  int get calculatedDays {
    if (isHalfDay == true) return 1;
    return endDate.difference(startDate).inDays + 1;
  }
}
