import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ghar_care/core/error/failures.dart';
import 'package:ghar_care/core/services/connectivity/network_info.dart';
import 'package:ghar_care/features/home/data/datasource/category_datasource.dart';
import 'package:ghar_care/features/home/data/datasource/remote/category_remote_datasource.dart';
import 'package:ghar_care/features/home/domain/entities/category_entity.dart';
import 'package:ghar_care/features/home/domain/repository/category_repository.dart';

final categoryRepositoryProvider = Provider<ICategoryRepository>((ref) {
  final categoryRemoteDataSource = ref.read(categoryRemoteDataSourceProvider);
  final networkInfo = ref.read(networkInfoProvider);

  return CategoryRepository(
    categoryRemoteDataSource: categoryRemoteDataSource,
    networkInfo: networkInfo,
  );
});

class CategoryRepository implements ICategoryRepository {
  final ICategoryRemoteDataSource _categoryRemoteDataSource;
  final NetworkInfo _networkInfo;

  CategoryRepository({
    required ICategoryRemoteDataSource categoryRemoteDataSource,
    required NetworkInfo networkInfo,
  }) : _categoryRemoteDataSource = categoryRemoteDataSource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, List<CategoryEntity>>> getAllCategories() async {
    if (await _networkInfo.isConnected) {
      try {
        final categories = await _categoryRemoteDataSource.getAllCategories();

        if (categories.isEmpty) {
          return Left(ApiFailure(message: "No categories found"));
        }

        final categoryEntities = categories
            .map((model) => model!.toEntity())
            .toList();

        return Right(categoryEntities);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return Left(ApiFailure(message: "No internet connected"));
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
