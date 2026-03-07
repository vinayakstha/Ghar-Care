import 'package:dartz/dartz.dart';
import 'package:ghar_care/core/error/failures.dart';
import 'package:ghar_care/features/service/domain/entities/service_entity.dart';

abstract interface class IServiceRepository {
  Future<Either<Failure, List<ServiceEntity>>> getServicesByCategory(String id);
  Future<Either<Failure, ServiceEntity>> getServiceById(String id);
}
