import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:injectable/injectable.dart';
import 'package:withu_leave_tracker/domain/auth/repository/i_auth_repository.dart';
import 'package:withu_leave_tracker/domain/core/errors/failures.dart';
import 'package:withu_leave_tracker/domain/auth/entities/user.dart' as domain;
import 'package:withu_leave_tracker/domain/core/value_objects/value_objects.dart';
import 'package:withu_leave_tracker/infrastructure/auth/datasource/auth_datasource.dart';
import 'package:withu_leave_tracker/infrastructure/auth/dto/user_dto.dart';

@LazySingleton(as: IAuthRepository)
class AuthRepository implements IAuthRepository {
  final AuthDataSource _authDataSource;

  AuthRepository(this._authDataSource);

  @override
  Future<Either<Failure, domain.User>> signInWithEmailAndPassword({
    required EmailAddress email,
    required Password password,
  }) async {
    try {
      final userCredential = await _authDataSource.signInWithEmailAndPassword(
        email: email.value,
        password: password.value,
      );

      final userDto = await _authDataSource.getUserDocument(
        uid: userCredential.user!.uid,
      );

      if (userDto != null) {
        return right(userDto.toDomain());
      } else {
        return left(const Failure.notFound('User data not found'));
      }
    } on auth.FirebaseAuthException catch (e) {
      return left(_handleAuthException(e));
    } catch (e) {
      return left(Failure.unknownError(e.toString()));
    }
  }

  @override
  Future<Either<Failure, domain.User>> signUpWithEmailAndPassword({
    required EmailAddress email,
    required Password password,
    required NonEmptyString firstName,
    required NonEmptyString lastName,
    required UniqueId teamId,
    required UniqueId projectId,
  }) async {
    try {
      final userCredential = await _authDataSource.signUpWithEmailAndPassword(
        email: email.value,
        password: password.value,
      );

      final userDto = UserDto(
        id: userCredential.user!.uid,
        firstName: firstName.value,
        lastName: lastName.value,
        email: email.value,
        role: 'employee',
        teamId: teamId.value,
        projectId: projectId.value,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _authDataSource.createUserDocument(
        uid: userCredential.user!.uid,
        userDto: userDto,
      );

      return right(userDto.toDomain());
    } on auth.FirebaseAuthException catch (e) {
      return left(_handleAuthException(e));
    } catch (e) {
      return left(Failure.unknownError(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      await _authDataSource.signOut();
      return right(unit);
    } catch (e) {
      return left(Failure.unknownError(e.toString()));
    }
  }

  @override
  Future<Either<Failure, domain.User?>> getCurrentUser() async {
    try {
      final firebaseUser = _authDataSource.getCurrentUser();
      if (firebaseUser != null) {
        final userDto = await _authDataSource.getUserDocument(
          uid: firebaseUser.uid,
        );
        return right(userDto?.toDomain());
      }
      return right(null);
    } catch (e) {
      return left(Failure.unknownError(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> resetPassword({
    required EmailAddress email,
  }) async {
    try {
      await _authDataSource.resetPassword(email: email.value);
      return right(unit);
    } on auth.FirebaseAuthException catch (e) {
      return left(_handleAuthException(e));
    } catch (e) {
      return left(Failure.unknownError(e.toString()));
    }
  }

  @override
  Future<Either<Failure, domain.User>> updateUserProfile({
    required UniqueId userId,
    required Map<String, dynamic> updates,
  }) async {
    try {
      await _authDataSource.updateUserDocument(
        uid: userId.value,
        updates: {...updates, 'updatedAt': DateTime.now()},
      );

      final userDto = await _authDataSource.getUserDocument(uid: userId.value);
      if (userDto != null) {
        return right(userDto.toDomain());
      } else {
        return left(const Failure.notFound('User not found'));
      }
    } catch (e) {
      return left(Failure.unknownError(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, domain.User?>> watchAuthStateChanges() {
    return _authDataSource.watchAuthStateChanges().asyncMap((
      firebaseUser,
    ) async {
      try {
        if (firebaseUser != null) {
          final userDto = await _authDataSource.getUserDocument(
            uid: firebaseUser.uid,
          );
          return right(userDto?.toDomain());
        }
        return right(null);
      } catch (e) {
        return left(Failure.unknownError(e.toString()));
      }
    });
  }

  Failure _handleAuthException(auth.FirebaseAuthException exception) {
    switch (exception.code) {
      case 'user-not-found':
      case 'wrong-password':
        return const Failure.authenticationFailure('Invalid email or password');
      case 'email-already-in-use':
        return const Failure.authenticationFailure('Email already in use');
      case 'weak-password':
        return const Failure.authenticationFailure('Password is too weak');
      case 'invalid-email':
        return const Failure.authenticationFailure('Invalid email address');
      case 'user-disabled':
        return const Failure.authenticationFailure('User account is disabled');
      case 'too-many-requests':
        return const Failure.authenticationFailure(
          'Too many requests. Try again later',
        );
      default:
        return Failure.authenticationFailure(exception.message);
    }
  }
}
