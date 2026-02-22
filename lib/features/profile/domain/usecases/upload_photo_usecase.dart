import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ghar_care/core/error/failures.dart';
import 'package:ghar_care/core/usecase/app_usecase.dart';
import 'package:ghar_care/features/profile/data/repository/user_repository.dart';
import 'package:ghar_care/features/profile/domain/repository/user_repository.dart';

// Provider
final uploadUserImageUsecaseProvider = Provider<UploadUserImageUsecase>((ref) {
  final repository = ref.read(userRepositoryProvider);
  return UploadUserImageUsecase(repository: repository);
});

class UploadUserImageUsecase implements UsecaseWithParams<String, File> {
  final IUserRepository _repository;

  UploadUserImageUsecase({required IUserRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, String>> call(File params) {
    return _repository.uploadImage(params);
  }
}
