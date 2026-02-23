import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ghar_care/core/error/failures.dart';
import 'package:ghar_care/core/services/connectivity/network_info.dart';
import 'package:ghar_care/features/home/data/datasource/category_datasource.dart';
import 'package:ghar_care/features/home/data/datasource/local/category_local_datasource.dart';
import 'package:ghar_care/features/home/data/datasource/remote/category_remote_datasource.dart';
import 'package:ghar_care/features/home/data/model/category_api_model.dart';
import 'package:ghar_care/features/home/data/model/category_hive_model.dart';
import 'package:ghar_care/features/home/domain/entities/category_entity.dart';
import 'package:ghar_care/features/home/domain/repository/category_repository.dart';

final categoryRepositoryProvider = Provider<ICategoryRepository>((ref) {
  final categoryRemoteDataSource = ref.read(categoryRemoteDataSourceProvider);
  final categoryLocalDataSource = ref.read(categoryLocalDatasourceProvider);
  final networkInfo = ref.read(networkInfoProvider);

  return CategoryRepository(
    categoryRemoteDataSource: categoryRemoteDataSource,
    categoryLocalDatasource: categoryLocalDataSource,
    networkInfo: networkInfo,
  );
});

class CategoryRepository implements ICategoryRepository {
  final ICategoryRemoteDataSource _categoryRemoteDataSource;
  final ICategoryLocalDataSource _categoryLocalDataSource;
  final NetworkInfo _networkInfo;

  CategoryRepository({
    required ICategoryRemoteDataSource categoryRemoteDataSource,
    required ICategoryLocalDataSource categoryLocalDatasource,
    required NetworkInfo networkInfo,
  }) : _categoryRemoteDataSource = categoryRemoteDataSource,
       _categoryLocalDataSource = categoryLocalDatasource,
       _networkInfo = networkInfo;

  Future<Either<Failure, List<CategoryEntity>>> _getCachedCategories() async {
    try {
      final localModels = await _categoryLocalDataSource.getAllCategories();

      // Remove null values safely
      final nonNullModels = localModels.whereType<CategoryHiveModel>().toList();

      return Right(CategoryHiveModel.toEntityList(nonNullModels));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CategoryEntity>>> getAllCategories() async {
    if (await _networkInfo.isConnected) {
      try {
        final categories = await _categoryRemoteDataSource.getAllCategories();

        if (categories.isEmpty) {
          return Left(ApiFailure(message: "No categories found"));
        }

        // final hiveModels = CategoryHiveModel.fromApiModelList(categories);
        // await _categoryLocalDataSource.cacheAllCategories(hiveModels);
        final nonNullCategories = categories
            .whereType<CategoryApiModel>()
            .toList();

        if (nonNullCategories.isEmpty) {
          return Left(ApiFailure(message: "No categories found"));
        }

        final hiveModels = CategoryHiveModel.fromApiModelList(
          nonNullCategories,
        );

        await _categoryLocalDataSource.cacheAllCategories(hiveModels);

        final categoryEntities = categories
            .map((model) => model!.toEntity())
            .toList();

        return Right(categoryEntities);
      } catch (e) {
        // return Left(ApiFailure(message: e.toString()));
        return await _getCachedCategories();
      }
    } else {
      // return Left(ApiFailure(message: "No internet connected"));
      return await _getCachedCategories();
    }
  }

  @override
  Future<Either<Failure, CategoryEntity>> getCategoryById(String id) async {
    if (await _networkInfo.isConnected) {
      try {
        final category = await _categoryRemoteDataSource.getCategoryById(id);
        if (category == null) {
          return Left(ApiFailure(message: "category not found"));
        }
        return Right(category.toEntity());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return Left(ApiFailure(message: "No internet connected"));
    }
  }
}
