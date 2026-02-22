import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ghar_care/core/error/failures.dart';
import 'package:ghar_care/core/usecase/app_usecase.dart';
import 'package:ghar_care/features/profile/data/repository/user_repository.dart';
import 'package:ghar_care/features/profile/domain/entities/user_entity.dart';
import 'package:ghar_care/features/profile/domain/repository/user_repository.dart';

// Provider
final updateProfileUsecaseProvider = Provider<UpdateProfileUsecase>((ref) {
  final repository = ref.read(userRepositoryProvider);
  return UpdateProfileUsecase(repository: repository);
});

class UpdateProfileUsecase
    implements UsecaseWithParams<UserEntity, UpdateProfileParams> {
  final IUserRepository _repository;

  UpdateProfileUsecase({required IUserRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, UserEntity>> call(UpdateProfileParams params) {
    return _repository.updateProfile(params.user, image: params.image);
  }
}

// Params class to hold user data and optional image
class UpdateProfileParams {
  final UserEntity user;
  final File? image;

  UpdateProfileParams({required this.user, this.image});
}
