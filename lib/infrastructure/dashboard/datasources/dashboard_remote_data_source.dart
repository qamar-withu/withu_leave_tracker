import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:withu_leave_tracker/domain/dashboard/entities/dashboard_stats.dart';
import 'package:withu_leave_tracker/domain/leave_request/entities/leave_request.dart';
import 'package:withu_leave_tracker/infrastructure/leave_request/dto/leave_request_dto.dart';

@injectable
class DashboardRemoteDataSource {
  final FirebaseFirestore _firestore;

  DashboardRemoteDataSource(this._firestore);

  Stream<DashboardStats> watchDashboardStats(String userId) {
    try {
      return _firestore.collection('users').doc(userId).snapshots().asyncMap((
        userSnapshot,
      ) async {
        if (!userSnapshot.exists) {
          throw Exception('User not found');
        }

        final userData = userSnapshot.data()!;
        final teamId = userData['teamId'] as String?;
        final userRole = userData['role'] as String?;

        // Get user's leave requests in real-time
        final requestsSnapshot = await _firestore
            .collection('leave_requests')
            .where('userId', isEqualTo: userId)
            .get();

        int pendingRequests = 0;
        int approvedRequests = 0;
        int rejectedRequests = 0;
        int usedLeaveDays = 0;

        final currentYear = DateTime.now().year;

        for (var doc in requestsSnapshot.docs) {
          final data = doc.data();
          final status = data['status'] as String;

          switch (status) {
            case 'pending':
              pendingRequests++;
              break;
            case 'approved':
              approvedRequests++;
              // Calculate used days for current year
              final startDate = (data['startDate'] as Timestamp).toDate();
              final endDate = (data['endDate'] as Timestamp).toDate();
              if (startDate.year == currentYear) {
                usedLeaveDays += endDate.difference(startDate).inDays + 1;
              }
              break;
            case 'rejected':
              rejectedRequests++;
              break;
          }
        }

        // Get team pending requests for managers/admins
        int teamPendingRequests = 0;
        if (teamId != null && (userRole == 'manager' || userRole == 'admin')) {
          final teamRequestsSnapshot = await _firestore
              .collection('leave_requests')
              .where('teamId', isEqualTo: teamId)
              .where('status', isEqualTo: 'pending')
              .get();

          teamPendingRequests = teamRequestsSnapshot.docs.length;
        }

        const totalLeaveDays = 30;
        final remainingLeaveDays = (totalLeaveDays - usedLeaveDays).clamp(
          0,
          totalLeaveDays,
        );

        return DashboardStats(
          pendingRequests: pendingRequests,
          approvedRequests: approvedRequests,
          rejectedRequests: rejectedRequests,
          remainingLeaveDays: remainingLeaveDays,
          teamPendingRequests: teamPendingRequests,
          totalLeaveDays: totalLeaveDays,
          usedLeaveDays: usedLeaveDays,
        );
      });
    } catch (e) {
      // Handle errors gracefully
      return Stream.error('Failed to fetch dashboard stats: $e');
    }
  }

  Stream<List<LeaveRequest>> watchRecentLeaveRequests(String userId) {
    return _firestore
        .collection('leave_requests')
        .where('userId', isEqualTo: userId)
        .orderBy('requestedAt', descending: true)
        .limit(5)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            final dto = LeaveRequestDto.fromJson({'id': doc.id, ...data});
            return dto.toDomain();
          }).toList();
        });
  }

  Future<DashboardStats> getDashboardStats(String userId) async {
    return await watchDashboardStats(userId).first;
  }

  Future<List<LeaveRequest>> getRecentLeaveRequests(String userId) async {
    return await watchRecentLeaveRequests(userId).first;
  }
}
