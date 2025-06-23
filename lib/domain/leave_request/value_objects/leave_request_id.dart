import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:withu_leave_tracker/domain/core/value_objects/value_objects.dart';

part 'leave_request_id.freezed.dart';

@freezed
class LeaveRequestId with _$LeaveRequestId {
  const factory LeaveRequestId(String value) = _LeaveRequestId;

  factory LeaveRequestId.generate() {
    return LeaveRequestId(const Uuid().v4());
  }
}
