enum LeaveRequestStatus { pending, approved, rejected }

extension LeaveRequestStatusExtension on LeaveRequestStatus {
  String get value {
    switch (this) {
      case LeaveRequestStatus.pending:
        return 'pending';
      case LeaveRequestStatus.approved:
        return 'approved';
      case LeaveRequestStatus.rejected:
        return 'rejected';
    }
  }

  static LeaveRequestStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return LeaveRequestStatus.pending;
      case 'approved':
        return LeaveRequestStatus.approved;
      case 'rejected':
        return LeaveRequestStatus.rejected;
      default:
        return LeaveRequestStatus.pending;
    }
  }
}
