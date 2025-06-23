import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:withu_leave_tracker/core/constants/app_constants.dart';
import 'package:withu_leave_tracker/infrastructure/team_management/dto/team_dto.dart';
import 'package:withu_leave_tracker/infrastructure/team_management/dto/project_dto.dart';
import 'package:withu_leave_tracker/infrastructure/auth/dto/user_dto.dart';

@injectable
class TeamManagementRemoteDataSource {
  final FirebaseFirestore _firestore;

  TeamManagementRemoteDataSource(this._firestore);

  // Team operations
  Future<void> createTeam(TeamDto teamDto) async {
    await _firestore.collection('teams').doc(teamDto.id).set(teamDto.toJson());
  }

  Future<List<TeamDto>> getTeams() async {
    final querySnapshot = await _firestore
        .collection('teams')
        .where('isActive', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .get();

    return querySnapshot.docs
        .map((doc) => TeamDto.fromJson({'id': doc.id, ...doc.data()}))
        .toList();
  }

  Future<TeamDto> getTeamById(String teamId) async {
    final docSnapshot = await _firestore.collection('teams').doc(teamId).get();

    if (!docSnapshot.exists) {
      throw Exception('Team not found');
    }

    return TeamDto.fromJson({'id': docSnapshot.id, ...docSnapshot.data()!});
  }

  Future<List<UserDto>> getTeamMembers(String teamId) async {
    final teamDoc = await _firestore.collection('teams').doc(teamId).get();

    if (!teamDoc.exists) {
      throw Exception('Team not found');
    }

    final teamData = teamDoc.data()!;
    final memberIds = List<String>.from(teamData['memberIds'] ?? []);

    if (memberIds.isEmpty) {
      return [];
    }

    final usersSnapshot = await _firestore
        .collection(AppConstants.usersCollection)
        .where(FieldPath.documentId, whereIn: memberIds)
        .get();

    return usersSnapshot.docs
        .map((doc) => UserDto.fromJson({'id': doc.id, ...doc.data()}))
        .toList();
  }

  Future<void> updateTeam(String teamId, Map<String, dynamic> updates) async {
    await _firestore.collection('teams').doc(teamId).update({
      ...updates,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteTeam(String teamId) async {
    await _firestore.collection('teams').doc(teamId).update({
      'isActive': false,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> addTeamMember(String teamId, String userId) async {
    await _firestore.collection('teams').doc(teamId).update({
      'memberIds': FieldValue.arrayUnion([userId]),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> removeTeamMember(String teamId, String userId) async {
    await _firestore.collection('teams').doc(teamId).update({
      'memberIds': FieldValue.arrayRemove([userId]),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Project operations
  Future<void> createProject(ProjectDto projectDto) async {
    await _firestore
        .collection('projects')
        .doc(projectDto.id)
        .set(projectDto.toJson());
  }

  Future<List<ProjectDto>> getProjects() async {
    final querySnapshot = await _firestore
        .collection('projects')
        .where('isActive', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .get();

    return querySnapshot.docs
        .map((doc) => ProjectDto.fromJson({'id': doc.id, ...doc.data()}))
        .toList();
  }

  Future<ProjectDto> getProjectById(String projectId) async {
    final docSnapshot = await _firestore
        .collection('projects')
        .doc(projectId)
        .get();

    if (!docSnapshot.exists) {
      throw Exception('Project not found');
    }

    return ProjectDto.fromJson({'id': docSnapshot.id, ...docSnapshot.data()!});
  }

  Future<void> updateProject(
    String projectId,
    Map<String, dynamic> updates,
  ) async {
    await _firestore.collection('projects').doc(projectId).update({
      ...updates,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteProject(String projectId) async {
    await _firestore.collection('projects').doc(projectId).update({
      'isActive': false,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
