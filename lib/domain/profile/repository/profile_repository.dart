import 'package:dartz/dartz.dart';
import 'package:withu_leave_tracker/domain/auth/entities/user.dart';
import 'package:withu_leave_tracker/domain/core/errors/failures.dart';

abstract class ProfileRepository {
  Future<Either<Failure, User>> getProfile(String userId);
  Future<Either<Failure, User>> updateProfile(User user);
  Future<Either<Failure, Unit>> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}
