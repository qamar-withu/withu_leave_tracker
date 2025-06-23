import 'package:dartz/dartz.dart';
import 'package:withu_leave_tracker/domain/core/errors/failures.dart';
import 'package:withu_leave_tracker/domain/auth/entities/user.dart';
import 'package:withu_leave_tracker/domain/core/value_objects/value_objects.dart';

abstract class IAuthRepository {
  Future<Either<Failure, User>> signInWithEmailAndPassword({
    required EmailAddress email,
    required Password password,
  });

  Future<Either<Failure, User>> signUpWithEmailAndPassword({
    required EmailAddress email,
    required Password password,
    required NonEmptyString firstName,
    required NonEmptyString lastName,
    required UniqueId teamId,
    required UniqueId projectId,
  });

  Future<Either<Failure, Unit>> signOut();

  Future<Either<Failure, User?>> getCurrentUser();

  Future<Either<Failure, Unit>> resetPassword({required EmailAddress email});

  Future<Either<Failure, User>> updateUserProfile({
    required UniqueId userId,
    required Map<String, dynamic> updates,
  });

  Stream<Either<Failure, User?>> watchAuthStateChanges();
}
