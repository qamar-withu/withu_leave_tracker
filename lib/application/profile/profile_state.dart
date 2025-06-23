part of 'profile_bloc.dart';

@freezed
class ProfileState with _$ProfileState {
  const factory ProfileState.initial() = _Initial;
  const factory ProfileState.loading() = _Loading;
  const factory ProfileState.loaded(User user) = _Loaded;
  const factory ProfileState.updating() = _Updating;
  const factory ProfileState.updated(User user) = _Updated;
  const factory ProfileState.passwordChanged() = _PasswordChanged;
  const factory ProfileState.error(Failure failure) = _Error;
}
