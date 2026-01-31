import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ghar_care/core/error/failures.dart';
import 'package:ghar_care/core/usecase/app_usecase.dart';
import 'package:ghar_care/features/auth/data/repositories/auth_repository.dart';
import 'package:ghar_care/features/auth/domain/repositories/auth_repository.dart';

//provider
final uploadImageUsecaseProvider = Provider<UploadImageUsecase>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return UploadImageUsecase(repository: repository);
});

class UploadImageUsecase implements UsecaseWithParams<String, File> {
  final IAuthRepository _repository;

  UploadImageUsecase({required IAuthRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, String>> call(File params) {
    return _repository.uploadImage(params);
  }
}
