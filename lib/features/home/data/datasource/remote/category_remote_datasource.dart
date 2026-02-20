import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ghar_care/core/api/api_client.dart';
import 'package:ghar_care/core/api/api_endpoints.dart';
import 'package:ghar_care/core/services/storage/token_service.dart';
import 'package:ghar_care/features/home/data/datasource/category_datasource.dart';
import 'package:ghar_care/features/home/data/model/category_api_model.dart';

final categoryRemoteDataSourceProvider = Provider<ICategoryRemoteDataSource>((
  ref,
) {
  return CategoryRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
    tokenService: ref.read(tokenServiceProvider),
  );
});

class CategoryRemoteDatasource implements ICategoryRemoteDataSource {
  final ApiClient _apiClient;
  final TokenService _tokenService;

  CategoryRemoteDatasource({
    required ApiClient apiClient,
    required TokenService tokenService,
  }) : _apiClient = apiClient,
       _tokenService = tokenService;

  @override
  Future<List<CategoryApiModel>> getAllCategories() async {
    final response = await _apiClient.get(ApiEndpoints.getAllCategories);

    if (response.data == null) {
      return [];
    }

    final List data = response.data;

    return data.map((json) => CategoryApiModel.fromJson(json)).toList();
  }

  @override
  Future<CategoryApiModel?> getCategoryById(String categoryId) async {
    final response = await _apiClient.get(
      "${ApiEndpoints.getCategoryById}/$categoryId",
    );
    if (response.data == null) {
      return null;
    }
    final category = CategoryApiModel.fromJson(response.data);
    return category;
  }
}
