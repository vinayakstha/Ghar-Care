import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ghar_care/core/error/failures.dart';
import 'package:ghar_care/core/services/connectivity/network_info.dart';
import 'package:ghar_care/features/service/data/datasource/local/service_local_datasource.dart';
import 'package:ghar_care/features/service/data/datasource/remote/service_remote_datasource.dart';
import 'package:ghar_care/features/service/data/datasource/service_datasource.dart';
import 'package:ghar_care/features/service/data/model/service_api_model.dart';
import 'package:ghar_care/features/service/data/model/service_hive_model.dart';
import 'package:ghar_care/features/service/domain/entities/service_entity.dart';
import 'package:ghar_care/features/service/domain/repository/service_repository.dart';

final serviceRepositoryProvider = Provider<IServiceRepository>((ref) {
  final serviceRemoteDataSource = ref.read(serviceRemoteDataSourceProvider);
  final serviceLocalDataSource = ref.read(serviceLocalDatasourceProvider);
  final networkInfo = ref.read(networkInfoProvider);

  return ServiceRepository(
    serviceRemoteDataSource: serviceRemoteDataSource,
    serviceLocalDatasource: serviceLocalDataSource,
    networkInfo: networkInfo,
  );
});

class ServiceRepository implements IServiceRepository {
  final IServiceRemoteDataSource _serviceRemoteDataSource;
  final IServiceLocalDataSource _serviceLocalDataSource;
  final NetworkInfo _networkInfo;

  ServiceRepository({
    required IServiceRemoteDataSource serviceRemoteDataSource,
    required IServiceLocalDataSource serviceLocalDatasource,
    required NetworkInfo networkInfo,
  }) : _serviceRemoteDataSource = serviceRemoteDataSource,
       _serviceLocalDataSource = serviceLocalDatasource,
       _networkInfo = networkInfo;

  Future<Either<Failure, List<ServiceEntity>>> _getCachedServicesByCategory(
    String categoryId,
  ) async {
    try {
      final localModels = await _serviceLocalDataSource.getServicesByCategoryId(
        categoryId,
      );

      final nonNullModels = localModels.whereType<ServiceHiveModel>().toList();

      return Right(ServiceHiveModel.toEntityList(nonNullModels));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ServiceEntity>>> getServicesByCategory(
    String id,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final services = await _serviceRemoteDataSource.getServicesByCategory(
          id,
        );

        final nonNullServices = services.whereType<ServiceApiModel>().toList();

        if (nonNullServices.isEmpty) {
          return Left(ApiFailure(message: "No service found"));
        }

        final hiveModels = ServiceHiveModel.fromApiModelList(nonNullServices);

        await _serviceLocalDataSource.cacheAllServices(hiveModels);

        final serviceEntities = nonNullServices
            .map((model) => model.toEntity())
            .toList();

        return Right(serviceEntities);
      } catch (e) {
        return await _getCachedServicesByCategory(id);
      }
    } else {
      return await _getCachedServicesByCategory(id);
    }
  }

  @override
  Future<Either<Failure, ServiceEntity>> getServiceById(String id) async {
    if (await _networkInfo.isConnected) {
      try {
        final service = await _serviceRemoteDataSource.getServiceById(id);
        if (service == null) {
          return Left(ApiFailure(message: "service not found"));
        }
        return Right(service.toEntity());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return Left(ApiFailure(message: "No internet connected"));
    }
  }

  // @override
  // Future<Either<Failure, List<ServiceEntity>>> getServicesByCategory(
  //   String id,
  // ) async {
  //   if (await _networkInfo.isConnected) {
  //     try {
  //       final services = await _serviceRemoteDataSource.getServicesByCategory(
  //         id,
  //       );
  //       if (services.isEmpty) {
  //         return Left(ApiFailure(message: "No service found"));
  //       }
  //       final serviceEntities = services
  //           .map((model) => model!.toEntity())
  //           .toList();
  //       return Right(serviceEntities);
  //     } catch (e) {
  //       return Left(ApiFailure(message: e.toString()));
  //     }
  //   } else {
  //     return Left(ApiFailure(message: "No internet connected"));
  //   }
  // }
}
