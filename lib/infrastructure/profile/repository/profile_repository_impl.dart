import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:withu_leave_tracker/domain/profile/repository/profile_repository.dart';
import 'package:withu_leave_tracker/domain/auth/entities/user.dart';
import 'package:withu_leave_tracker/domain/core/errors/failures.dart';
import 'package:withu_leave_tracker/infrastructure/profile/datasources/profile_remote_data_source.dart';

@LazySingleton(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, User>> getProfile(String userId) async {
    try {
      final user = await _remoteDataSource.getProfile(userId);
      return right(user);
    } catch (e) {
      return left(Failure.serverError(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> updateProfile(User user) async {
    try {
      final updatedUser = await _remoteDataSource.updateProfile(user);
      return right(updatedUser);
    } catch (e) {
      return left(Failure.serverError(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _remoteDataSource.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      return const Right(unit);
    } catch (e) {
      return left(Failure.serverError(e.toString()));
    }
  }
}
