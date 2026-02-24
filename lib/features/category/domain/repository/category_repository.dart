import 'package:dartz/dartz.dart';
import 'package:ghar_care/core/error/failures.dart';
import 'package:ghar_care/features/category/domain/entities/category_entity.dart';

abstract interface class ICategoryRepository {
  Future<Either<Failure, CategoryEntity>> getCategoryById(String id);
  Future<Either<Failure, List<CategoryEntity>>> getAllCategories();
}
