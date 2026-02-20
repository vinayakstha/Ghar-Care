import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ghar_care/core/error/failures.dart';
import 'package:ghar_care/core/services/connectivity/network_info.dart';
import 'package:ghar_care/features/service/data/datasource/remote/service_remote_datasource.dart';
import 'package:ghar_care/features/service/data/datasource/service_datasource.dart';
import 'package:ghar_care/features/service/domain/entities/service_entity.dart';
import 'package:ghar_care/features/service/domain/repository/service_repository.dart';

final serviceRepositoryProvider = Provider<IServiceRepository>((ref) {
  final serviceRemoteDataSource = ref.read(serviceRemoteDataSourceProvider);
  final networkInfo = ref.read(networkInfoProvider);

  return ServiceRepository(
    serviceRemoteDataSource: serviceRemoteDataSource,
    networkInfo: networkInfo,
  );
});

class ServiceRepository implements IServiceRepository {
  final IServiceRemoteDataSource _serviceRemoteDataSource;
  final NetworkInfo _networkInfo;

  ServiceRepository({
    required IServiceRemoteDataSource serviceRemoteDataSource,
    required NetworkInfo networkInfo,
  }) : _serviceRemoteDataSource = serviceRemoteDataSource,
       _networkInfo = networkInfo;
  @override
  Future<Either<Failure, List<ServiceEntity>>> getServicesByCategory(
    String id,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final services = await _serviceRemoteDataSource.getServicesByCategory(
          id,
        );
        if (services.isEmpty) {
          return Left(ApiFailure(message: "No service found"));
        }

        final serviceEntities = services
            .map((model) => model!.toEntity())
            .toList();
        return Right(serviceEntities);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return Left(ApiFailure(message: "No internet connected"));
    }
  }
}
