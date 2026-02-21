import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ghar_care/core/api/api_client.dart';
import 'package:ghar_care/core/api/api_endpoints.dart';
import 'package:ghar_care/features/favourite/data/datasource/favourite_datasource.dart';
import 'package:ghar_care/features/favourite/data/model/favourite_api_model.dart';

final favouriteRemoteDataSourceProvider = Provider<IFavouriteRemoteDataSource>((
  ref,
) {
  return FavouriteRemoteDatasource(apiClient: ref.read(apiClientProvider));
});

class FavouriteRemoteDatasource implements IFavouriteRemoteDataSource {
  final ApiClient _apiClient;

  FavouriteRemoteDatasource({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  Future<bool> createFavourite(String serviceId) async {
    final response = await _apiClient.post(
      ApiEndpoints.createFavourite,
      data: {"serviceId": serviceId},
    );

    return response.statusCode == 200 || response.statusCode == 201;
  }

  @override
  Future<bool> deleteFavourite(String favouriteId) async {
    final response = await _apiClient.delete(
      ApiEndpoints.deleteFavourite(favouriteId),
    );

    return response.statusCode == 200;
  }

  @override
  Future<List<FavouriteApiModel?>> getFavouritesByUser() async {
    final response = await _apiClient.get(ApiEndpoints.getFavouritesByUser);

    if (response.data == null) return [];

    final Map<String, dynamic> resMap = response.data as Map<String, dynamic>;

    final List<dynamic> data = resMap['data'] as List<dynamic>? ?? [];

    return data
        .map((json) => FavouriteApiModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
