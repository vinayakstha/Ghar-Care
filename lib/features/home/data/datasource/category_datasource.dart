import 'package:ghar_care/features/home/data/model/category_api_model.dart';
import 'package:ghar_care/features/home/data/model/category_hive_model.dart';

abstract interface class ICategoryRemoteDataSource {
  Future<CategoryApiModel?> getCategoryById(String categoryId);
  Future<List<CategoryApiModel?>> getAllCategories();
}

abstract interface class ICategoryLocalDataSource {
  Future<bool> addCategory(CategoryHiveModel model);
  Future<CategoryHiveModel?> getCategoryById(String categoryId);
  Future<List<CategoryHiveModel?>> getAllCategories();
  Future<bool> updateCategory(CategoryHiveModel model);
  Future<bool> deleteCategory(String categoryId);
  Future<void> cacheAllCategories(List<CategoryHiveModel> categories);
}
