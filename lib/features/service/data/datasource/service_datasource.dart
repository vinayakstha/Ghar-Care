import 'package:ghar_care/features/service/data/model/service_api_model.dart';

abstract interface class IServiceRemoteDataSource {
  Future<List<ServiceApiModel?>> getServicesByCategory(String categoryId);
  Future<ServiceApiModel?> getServiceById(String serviceId);
}
