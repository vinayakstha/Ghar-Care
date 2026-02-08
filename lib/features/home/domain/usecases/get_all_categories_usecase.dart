import 'package:dartz/dartz.dart';
import 'package:ghar_care/core/error/failures.dart';
import 'package:ghar_care/core/usecase/app_usecase.dart';
import 'package:ghar_care/features/home/domain/repository/category_repository.dart';

class GetAllCategoriesUsecase implements UsecaseWithoutParams {
  final ICategoryRepository _categoryRepository;

  GetAllCategoriesUsecase({required ICategoryRepository categoryRepository})
    : _categoryRepository = categoryRepository;

  @override
  Future<Either<Failure, dynamic>> call() {
    return _categoryRepository.getAllCategories();
  }
}
