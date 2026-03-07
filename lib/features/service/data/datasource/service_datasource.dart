import 'package:ghar_care/features/service/data/model/service_api_model.dart';
import 'package:ghar_care/features/service/data/model/service_hive_model.dart';

abstract interface class IServiceRemoteDataSource {
  Future<List<ServiceApiModel?>> getServicesByCategory(String categoryId);
  Future<ServiceApiModel?> getServiceById(String serviceId);
}

abstract interface class IServiceLocalDataSource {
  Future<bool> addService(ServiceHiveModel model);
  Future<ServiceHiveModel?> getServiceById(String serviceId);
  Future<List<ServiceHiveModel?>> getAllServices();
  Future<bool> updateService(ServiceHiveModel model);
  Future<bool> deleteService(String serviceId);
  Future<void> cacheAllServices(List<ServiceHiveModel> services);
  Future<List<ServiceHiveModel?>> getServicesByCategoryId(String categoryId);
}
