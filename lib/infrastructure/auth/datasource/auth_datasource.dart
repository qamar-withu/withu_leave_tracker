import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:injectable/injectable.dart';
import 'package:withu_leave_tracker/core/constants/app_constants.dart';
import 'package:withu_leave_tracker/infrastructure/auth/dto/user_dto.dart';

@lazySingleton
class AuthDataSource {
  final auth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthDataSource(this._firebaseAuth, this._firestore);

  Future<auth.UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<auth.UserCredential> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  auth.User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  Future<void> resetPassword({required String email}) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> createUserDocument({
    required String uid,
    required UserDto userDto,
  }) async {
    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(uid)
        .set(userDto.toJson());
  }

  Future<UserDto?> getUserDocument({required String uid}) async {
    final doc = await _firestore
        .collection(AppConstants.usersCollection)
        .doc(uid)
        .get();

    if (doc.exists) {
      return UserDto.fromJson(doc.data()!);
    }
    return null;
  }

  Future<void> updateUserDocument({
    required String uid,
    required Map<String, dynamic> updates,
  }) async {
    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(uid)
        .update(updates);
  }

  Stream<auth.User?> watchAuthStateChanges() {
    return _firebaseAuth.authStateChanges();
  }
}
