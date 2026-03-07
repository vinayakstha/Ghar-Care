import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:ghar_care/core/error/failures.dart';
import 'package:ghar_care/features/profile/domain/entities/user_entity.dart';

abstract interface class IUserRepository {
  /// Get the currently logged-in user
  Future<Either<Failure, UserEntity>> getCurrentUser();

  /// Upload a profile image and return the URL of the uploaded image
  Future<Either<Failure, String>> uploadImage(File image);

  /// Update the user's profile and return the updated user entity
  Future<Either<Failure, UserEntity>> updateProfile(
    UserEntity updatedUser, {
    File? image,
  });
}
