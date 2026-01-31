import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ghar_care/core/error/failures.dart';
import 'package:ghar_care/core/usecase/app_usecase.dart';
import 'package:ghar_care/features/auth/data/repositories/auth_repository.dart';
import 'package:ghar_care/features/auth/domain/repositories/auth_repository.dart';

class GetUserByIdUsecaseParams extends Equatable {
  final String id;

  const GetUserByIdUsecaseParams({required this.id});

  @override
  List<Object?> get props => [id];
}

final getUserByIdUsecaseProvider = Provider<GetUserByIdUsecase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return GetUserByIdUsecase(authRepository: authRepository);
});

class GetUserByIdUsecase implements UsecaseWithParams {
  final IAuthRepository _authRepository;

  GetUserByIdUsecase({required IAuthRepository authRepository})
    : _authRepository = authRepository;
  @override
  Future<Either<Failure, dynamic>> call(dynamic params) {
    final typedParams = params as GetUserByIdUsecaseParams;
    return _authRepository.getUserById(typedParams.id);
  }
}
