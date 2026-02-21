import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ghar_care/core/error/failures.dart';
import 'package:ghar_care/core/usecase/app_usecase.dart';
import 'package:ghar_care/features/service/data/repository/service_repository.dart';
import 'package:ghar_care/features/service/domain/repository/service_repository.dart';

class GetServiceByIdUsecaseParams extends Equatable {
  final String id;
  const GetServiceByIdUsecaseParams({required this.id});
  @override
  List<Object?> get props => [id];
}

final getServiceByIdUsecaseProvider = Provider<GetServiceByIdUsecase>((ref) {
  final serviceRepository = ref.read(serviceRepositoryProvider);
  return GetServiceByIdUsecase(serviceRepository: serviceRepository);
});

class GetServiceByIdUsecase implements UsecaseWithParams {
  final IServiceRepository _serviceRepository;
  GetServiceByIdUsecase({required IServiceRepository serviceRepository})
    : _serviceRepository = serviceRepository;

  @override
  Future<Either<Failure, dynamic>> call(params) {
    final typedParams = params as GetServiceByIdUsecaseParams;
    return _serviceRepository.getServiceById(typedParams.id);
  }
}
