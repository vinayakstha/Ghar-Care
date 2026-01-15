import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ghar_care/core/error/failures.dart';
import 'package:ghar_care/core/usecase/app_usecase.dart';
import 'package:ghar_care/features/auth/data/repositories/auth_repository.dart';
import 'package:ghar_care/features/auth/domain/entities/auth_entity.dart';
import 'package:ghar_care/features/auth/domain/repositories/auth_repository.dart';

class RegisterUsecaseParams extends Equatable {
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String phoneNumber;
  final String password;
  final String confirmPassword;

  const RegisterUsecaseParams({
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.password,
    required this.confirmPassword,
  });
  @override
  List<Object?> get props => [
    firstName,
    lastName,
    username,
    email,
    phoneNumber,
    password,
    confirmPassword,
  ];
}

//provider
final registerUsecaseProvider = Provider<RegisterUsecase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return RegisterUsecase(authRepository: authRepository);
});

class RegisterUsecase
    implements UsecaseWithParams<bool, RegisterUsecaseParams> {
  final IAuthRepository _authRepository;
  RegisterUsecase({required IAuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<Failure, bool>> call(RegisterUsecaseParams params) {
    final entity = AuthEntity(
      firstName: params.firstName,
      lastName: params.lastName,
      username: params.username,
      email: params.email,
      phoneNumber: params.phoneNumber,
      password: params.password,
      confirmPassword: params.confirmPassword,
    );
    return _authRepository.register(entity);
  }
}
