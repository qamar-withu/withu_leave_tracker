import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:withu_leave_tracker/domain/auth/entities/user.dart';
import 'package:withu_leave_tracker/domain/profile/repository/profile_repository.dart';
import 'package:withu_leave_tracker/domain/core/errors/failures.dart';

part 'profile_bloc.freezed.dart';
part 'profile_event.dart';
part 'profile_state.dart';

@injectable
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _repository;

  ProfileBloc(this._repository) : super(const ProfileState.initial()) {
    on<_LoadProfile>(_onLoadProfile);
    on<_UpdateProfile>(_onUpdateProfile);
    on<_ChangePassword>(_onChangePassword);
  }

  Future<void> _onLoadProfile(
    _LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileState.loading());

    final result = await _repository.getProfile(event.userId);

    result.fold(
      (failure) => emit(ProfileState.error(failure)),
      (user) => emit(ProfileState.loaded(user)),
    );
  }

  Future<void> _onUpdateProfile(
    _UpdateProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileState.updating());

    final result = await _repository.updateProfile(event.user);

    result.fold(
      (failure) => emit(ProfileState.error(failure)),
      (user) => emit(ProfileState.updated(user)),
    );
  }

  Future<void> _onChangePassword(
    _ChangePassword event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileState.updating());

    final result = await _repository.changePassword(
      currentPassword: event.currentPassword,
      newPassword: event.newPassword,
    );

    result.fold(
      (failure) => emit(ProfileState.error(failure)),
      (_) => emit(const ProfileState.passwordChanged()),
    );
  }
}
