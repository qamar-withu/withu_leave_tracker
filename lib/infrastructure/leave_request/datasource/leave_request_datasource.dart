import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:withu_leave_tracker/core/constants/app_constants.dart';
import 'package:withu_leave_tracker/infrastructure/leave_request/dto/leave_request_dto.dart';

@lazySingleton
class LeaveRequestDataSource {
  final FirebaseFirestore _firestore;

  LeaveRequestDataSource(this._firestore);

  Future<void> createLeaveRequest(LeaveRequestDto leaveRequestDto) async {
    await _firestore
        .collection(AppConstants.leaveRequestsCollection)
        .doc(leaveRequestDto.id)
        .set(leaveRequestDto.toJson());
  }

  Future<List<LeaveRequestDto>> getLeaveRequestsByUser({
    required String userId,
  }) async {
    final querySnapshot = await _firestore
        .collection(AppConstants.leaveRequestsCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();

    return querySnapshot.docs
        .map((doc) => LeaveRequestDto.fromJson(doc.data()))
        .toList();
  }

  Future<List<LeaveRequestDto>> getLeaveRequestsByTeam({
    required List<String> userIds,
  }) async {
    if (userIds.isEmpty) return [];

    final querySnapshot = await _firestore
        .collection(AppConstants.leaveRequestsCollection)
        .where('userId', whereIn: userIds)
        .orderBy('createdAt', descending: true)
        .get();

    return querySnapshot.docs
        .map((doc) => LeaveRequestDto.fromJson(doc.data()))
        .toList();
  }

  Future<List<LeaveRequestDto>> getAllLeaveRequests({
    String? teamId,
    String? projectId,
  }) async {
    Query query = _firestore.collection(AppConstants.leaveRequestsCollection);

    // Apply filters if provided
    if (teamId != null) {
      query = query.where('teamId', isEqualTo: teamId);
    }

    // Note: If projectId filtering is needed, we would need to add projectId field to LeaveRequestDto
    // For now, we'll filter by teamId since teams belong to projects

    final querySnapshot = await query
        .orderBy('createdAt', descending: true)
        .get();

    return querySnapshot.docs
        .map(
          (doc) => LeaveRequestDto.fromJson(doc.data() as Map<String, dynamic>),
        )
        .toList();
  }

  Future<void> updateLeaveRequestStatus({
    required String requestId,
    required Map<String, dynamic> updates,
  }) async {
    await _firestore
        .collection(AppConstants.leaveRequestsCollection)
        .doc(requestId)
        .update(updates);
  }

  Future<LeaveRequestDto?> getLeaveRequestById({
    required String requestId,
  }) async {
    final doc = await _firestore
        .collection(AppConstants.leaveRequestsCollection)
        .doc(requestId)
        .get();

    if (doc.exists) {
      return LeaveRequestDto.fromJson(doc.data()!);
    }
    return null;
  }

  Stream<List<LeaveRequestDto>> watchLeaveRequestsByUser({
    required String userId,
  }) {
    return _firestore
        .collection(AppConstants.leaveRequestsCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => LeaveRequestDto.fromJson(doc.data()))
              .toList(),
        );
  }

  Stream<List<LeaveRequestDto>> watchPendingLeaveRequests() {
    return _firestore
        .collection(AppConstants.leaveRequestsCollection)
        .where('status', isEqualTo: 'pending')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => LeaveRequestDto.fromJson(doc.data()))
              .toList(),
        );
  }

  Future<void> deleteLeaveRequest({required String requestId}) async {
    await _firestore
        .collection(AppConstants.leaveRequestsCollection)
        .doc(requestId)
        .delete();
  }
}
