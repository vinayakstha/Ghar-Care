import 'package:ghar_care/features/home/data/model/category_api_model.dart';

abstract interface class IAuthRemoteDataSource {
  Future<CategoryApiModel?> getCategoryById(String categoryId);
  Future<List<CategoryApiModel?>> getAllCategories();
}
