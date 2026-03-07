import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ghar_care/core/services/hive/hive_service.dart';
import 'package:ghar_care/features/category/data/datasource/category_datasource.dart';
import 'package:ghar_care/features/category/data/model/category_hive_model.dart';

// Provider
final categoryLocalDatasourceProvider = Provider<CategoryLocalDatasource>((
  ref,
) {
  final hiveService = ref.read(hiveServiceProvider);
  return CategoryLocalDatasource(hiveService: hiveService);
});

class CategoryLocalDatasource implements ICategoryLocalDataSource {
  final HiveService _hiveService;

  CategoryLocalDatasource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<bool> addCategory(CategoryHiveModel model) async {
    try {
      await _hiveService.addCategory(model);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<CategoryHiveModel?> getCategoryById(String categoryId) async {
    try {
      final category = await _hiveService.getCategoryById(categoryId);
      return category;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<CategoryHiveModel?>> getAllCategories() async {
    try {
      final categories = await _hiveService.getAllCategories();
      return categories;
    } catch (e) {
      return [];
    }
  }

  Future<void> cacheAllCategories(List<CategoryHiveModel> bookings) async {
    await _hiveService.cacheAllCategories(bookings);
  }

  @override
  Future<bool> updateCategory(CategoryHiveModel model) async {
    try {
      await _hiveService.updateCategory(model);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteCategory(String categoryId) async {
    try {
      await _hiveService.deleteCategory(categoryId);
      return true;
    } catch (e) {
      return false;
    }
  }
}
