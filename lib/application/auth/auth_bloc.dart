import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:withu_leave_tracker/domain/auth/repository/i_auth_repository.dart';
import 'package:withu_leave_tracker/domain/auth/entities/user.dart';
import 'package:withu_leave_tracker/domain/core/errors/failures.dart';
import 'package:withu_leave_tracker/domain/core/value_objects/value_objects.dart';

part 'auth_event.dart';
part 'auth_state.dart';
part 'auth_bloc.freezed.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final IAuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(const AuthState.initial()) {
    on<AuthEvent>((event, emit) async {
      await event.when(
        signInRequested: (email, password) =>
            _onSignInRequested(emit, email, password),
        signUpRequested:
            (email, password, firstName, lastName, teamId, projectId) =>
                _onSignUpRequested(
                  emit,
                  email,
                  password,
                  firstName,
                  lastName,
                  teamId,
                  projectId,
                ),
        signOutRequested: () => _onSignOutRequested(emit),
        authStateChanged: () => _onAuthStateChanged(emit),
        resetPasswordRequested: (email) =>
            _onResetPasswordRequested(emit, email),
      );
    });

    // Listen to auth state changes
    _authRepository.watchAuthStateChanges().listen((either) {
      either.fold(
        (failure) => add(const AuthEvent.authStateChanged()),
        (user) => add(const AuthEvent.authStateChanged()),
      );
    });
  }

  Future<void> _onSignInRequested(
    Emitter<AuthState> emit,
    String email,
    String password,
  ) async {
    emit(const AuthState.loading());

    final emailAddress = EmailAddress(email);
    final passwordValue = Password(password);

    final emailValidation = emailAddress.failureOrValue;
    final passwordValidation = passwordValue.failureOrValue;

    if (emailValidation.isLeft() || passwordValidation.isLeft()) {
      emit(
        AuthState.failure(
          failure: emailValidation.isLeft()
              ? emailValidation.fold(
                  (l) => l,
                  (r) => const Failure.validationError(''),
                )
              : passwordValidation.fold(
                  (l) => l,
                  (r) => const Failure.validationError(''),
                ),
        ),
      );
      return;
    }

    final result = await _authRepository.signInWithEmailAndPassword(
      email: emailAddress,
      password: passwordValue,
    );

    result.fold(
      (failure) => emit(AuthState.failure(failure: failure)),
      (user) => emit(AuthState.authenticated(user: user)),
    );
  }

  Future<void> _onSignUpRequested(
    Emitter<AuthState> emit,
    String email,
    String password,
    String firstName,
    String lastName,
    String teamId,
    String projectId,
  ) async {
    emit(const AuthState.loading());

    final emailAddress = EmailAddress(email);
    final passwordValue = Password(password);
    final firstNameValue = NonEmptyString(firstName);
    final lastNameValue = NonEmptyString(lastName);
    final teamIdValue = UniqueId(teamId);
    final projectIdValue = UniqueId(projectId);

    // Validate all fields
    final validations = [
      emailAddress.failureOrValue,
      passwordValue.failureOrValue,
      firstNameValue.failureOrValue,
      lastNameValue.failureOrValue,
    ];

    for (final validation in validations) {
      if (validation.isLeft()) {
        emit(
          AuthState.failure(
            failure: validation.fold(
              (l) => l,
              (r) => const Failure.validationError(''),
            ),
          ),
        );
        return;
      }
    }

    final result = await _authRepository.signUpWithEmailAndPassword(
      email: emailAddress,
      password: passwordValue,
      firstName: firstNameValue,
      lastName: lastNameValue,
      teamId: teamIdValue,
      projectId: projectIdValue,
    );

    result.fold(
      (failure) => emit(AuthState.failure(failure: failure)),
      (user) => emit(AuthState.authenticated(user: user)),
    );
  }

  Future<void> _onSignOutRequested(Emitter<AuthState> emit) async {
    emit(const AuthState.loading());

    final result = await _authRepository.signOut();

    result.fold(
      (failure) => emit(AuthState.failure(failure: failure)),
      (_) => emit(const AuthState.unauthenticated()),
    );
  }

  Future<void> _onAuthStateChanged(Emitter<AuthState> emit) async {
    final result = await _authRepository.getCurrentUser();

    result.fold(
      (failure) => emit(AuthState.failure(failure: failure)),
      (user) => user != null
          ? emit(AuthState.authenticated(user: user))
          : emit(const AuthState.unauthenticated()),
    );
  }

  Future<void> _onResetPasswordRequested(
    Emitter<AuthState> emit,
    String email,
  ) async {
    final emailAddress = EmailAddress(email);
    final emailValidation = emailAddress.failureOrValue;

    if (emailValidation.isLeft()) {
      emit(
        AuthState.failure(
          failure: emailValidation.fold(
            (l) => l,
            (r) => const Failure.validationError(''),
          ),
        ),
      );
      return;
    }

    final result = await _authRepository.resetPassword(email: emailAddress);

    result.fold((failure) => emit(AuthState.failure(failure: failure)), (_) {
      // Could add a success state here if needed
    });
  }
}
