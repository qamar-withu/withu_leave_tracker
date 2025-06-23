import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:withu_leave_tracker/domain/auth/entities/user.dart' as domain;
import 'package:withu_leave_tracker/infrastructure/auth/dto/user_dto.dart';

@injectable
class ProfileRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  ProfileRemoteDataSource(this._firestore, this._auth);

  Future<domain.User> getProfile(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();

      if (!userDoc.exists) {
        throw Exception('User not found');
      }

      final data = userDoc.data()!;
      final userDto = UserDto.fromJson({'id': userDoc.id, ...data});

      return userDto.toDomain();
    } catch (e) {
      throw Exception('Failed to get profile: $e');
    }
  }

  Future<domain.User> updateProfile(domain.User user) async {
    try {
      final userDto = UserDto.fromDomain(user);

      await _firestore.collection('users').doc(user.id.value).update({
        ...userDto.toJson(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Return updated user
      return await getProfile(user.id.value);
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('No authenticated user');
      }

      // Re-authenticate with current password
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);

      // Update password
      await user.updatePassword(newPassword);
    } catch (e) {
      throw Exception('Failed to change password: $e');
    }
  }
}
