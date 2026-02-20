import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:ghar_care/core/error/failures.dart';
import 'package:ghar_care/core/usecase/app_usecase.dart';
import 'package:ghar_care/features/service/domain/repository/service_repository.dart';

class GetServicesByCategoryUsecaseParams extends Equatable {
  final String id;
  const GetServicesByCategoryUsecaseParams({required this.id});
  @override
  List<Object?> get props => [id];
}

class GetServicesByCategoryUsecase implements UsecaseWithParams {
  final IServiceRepository _serviceRepository;
  GetServicesByCategoryUsecase({required IServiceRepository serviceRepository})
    : _serviceRepository = serviceRepository;

  @override
  Future<Either<Failure, dynamic>> call(params) {
    final typedParams = params as GetServicesByCategoryUsecaseParams;
    return _serviceRepository.getServicesByCategory(typedParams.id);
  }
}
