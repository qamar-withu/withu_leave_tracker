part of 'profile_bloc.dart';

@freezed
class ProfileEvent with _$ProfileEvent {
  const factory ProfileEvent.loadProfile({required String userId}) =
      _LoadProfile;

  const factory ProfileEvent.updateProfile({required User user}) =
      _UpdateProfile;

  const factory ProfileEvent.changePassword({
    required String currentPassword,
    required String newPassword,
  }) = _ChangePassword;
}
