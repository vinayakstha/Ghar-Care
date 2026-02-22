import 'dart:io';

import 'package:ghar_care/features/profile/domain/entities/user_entity.dart';

abstract class IUserRemoteDatasource {
  /// Get the currently logged-in user
  Future<UserEntity> getCurrentUser();

  /// Upload a profile image and return the updated image URL
  Future<String> uploadImage(String filePath);

  /// Update the user's profile and return the updated UserEntity
  Future<UserEntity> updateProfile(UserEntity updatedUser, {File? image});
}
