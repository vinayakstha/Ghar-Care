import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ghar_care/core/error/failures.dart';
import 'package:ghar_care/core/usecase/app_usecase.dart';
import 'package:ghar_care/features/profile/data/repository/user_repository.dart';
import 'package:ghar_care/features/profile/domain/entities/user_entity.dart';
import 'package:ghar_care/features/profile/domain/repository/user_repository.dart';

final getCurrentUserUsecaseProvider = Provider<GetCurrentUserUsecase>((ref) {
  final userRepository = ref.read(userRepositoryProvider);
  return GetCurrentUserUsecase(userRepository: userRepository);
});

class GetCurrentUserUsecase implements UsecaseWithoutParams<UserEntity> {
  final IUserRepository _userRepository;

  GetCurrentUserUsecase({required IUserRepository userRepository})
    : _userRepository = userRepository;

  @override
  Future<Either<Failure, UserEntity>> call() {
    return _userRepository.getCurrentUser();
  }
}
