import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ghar_care/features/profile/domain/entities/user_entity.dart';
import 'package:ghar_care/features/profile/domain/usecases/get_current_user_usecase.dart';
import 'package:ghar_care/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:ghar_care/features/profile/domain/usecases/upload_photo_usecase.dart';
import 'package:ghar_care/features/profile/presentation/state/user_state.dart';

final userViewModelProvider = NotifierProvider<UserViewModel, UserState>(
  () => UserViewModel(),
);

class UserViewModel extends Notifier<UserState> {
  late final GetCurrentUserUsecase _getCurrentUserUsecase;
  late final UploadUserImageUsecase _uploadImageUsecase;
  late final UpdateProfileUsecase _updateProfileUsecase;

  @override
  UserState build() {
    _getCurrentUserUsecase = ref.read(getCurrentUserUsecaseProvider);
    _uploadImageUsecase = ref.read(uploadUserImageUsecaseProvider);
    _updateProfileUsecase = ref.read(updateProfileUsecaseProvider);
    return const UserState();
  }

  /// Get current user profile
  Future<void> getCurrentUser() async {
    state = state.copyWith(status: UserStatus.loading);

    final result = await _getCurrentUserUsecase();

    result.fold(
      (failure) {
        state = state.copyWith(
          status: UserStatus.error,
          errorMessage: failure.message,
        );
      },
      (user) {
        state = state.copyWith(status: UserStatus.loaded, user: user);
      },
    );
  }

  /// Upload profile image
  Future<void> uploadImage(File image) async {
    state = state.copyWith(status: UserStatus.loading);

    final result = await _uploadImageUsecase(image);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: UserStatus.error,
          errorMessage: failure.message,
        );
      },
      (imageName) async {
        state = state.copyWith(
          status: UserStatus.loaded,
          uploadPhotoName: imageName,
        );
        await getCurrentUser(); // refresh profile after image upload
      },
    );
  }

  /// Update user profile
  Future<void> updateProfile(UserEntity updatedUser, {File? image}) async {
    state = state.copyWith(status: UserStatus.loading);

    final result = await _updateProfileUsecase(
      UpdateProfileParams(user: updatedUser, image: image),
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          status: UserStatus.error,
          errorMessage: failure.message,
        );
      },
      (user) {
        state = state.copyWith(status: UserStatus.updated, user: user);
      },
    );
  }
}
