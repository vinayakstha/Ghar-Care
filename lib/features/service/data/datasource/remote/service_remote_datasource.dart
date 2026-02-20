import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ghar_care/core/api/api_client.dart';
import 'package:ghar_care/core/api/api_endpoints.dart';
import 'package:ghar_care/features/service/data/datasource/service_datasource.dart';
import 'package:ghar_care/features/service/data/model/service_api_model.dart';

final serviceRemoteDataSourceProvider = Provider<IServiceRemoteDataSource>((
  ref,
) {
  return ServiceRemoteDatasource(apiClient: ref.read(apiClientProvider));
});

class ServiceRemoteDatasource implements IServiceRemoteDataSource {
  final ApiClient _apiClient;
  ServiceRemoteDatasource({required ApiClient apiClient})
    : _apiClient = apiClient;
  @override
  Future<List<ServiceApiModel?>> getServicesByCategory(
    String categoryId,
  ) async {
    final response = await _apiClient.get(
      ApiEndpoints.getServicesByCategory(categoryId),
    );
    if (response.data == null) return [];
    final Map<String, dynamic> resMap = response.data as Map<String, dynamic>;
    final List<dynamic> data = resMap['data'] as List<dynamic>? ?? [];
    return data
        .map((json) => ServiceApiModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
