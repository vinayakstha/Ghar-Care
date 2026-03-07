import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ghar_care/core/error/failures.dart';
import 'package:ghar_care/core/usecase/app_usecase.dart';
import 'package:ghar_care/features/category/data/repository/category_repository.dart';
import 'package:ghar_care/features/category/domain/repository/category_repository.dart';

final getAllCategoriesUsecaseProvider = Provider<GetAllCategoriesUsecase>((
  ref,
) {
  final categoryRepository = ref.read(categoryRepositoryProvider);
  return GetAllCategoriesUsecase(categoryRepository: categoryRepository);
});

class GetAllCategoriesUsecase implements UsecaseWithoutParams {
  final ICategoryRepository _categoryRepository;

  GetAllCategoriesUsecase({required ICategoryRepository categoryRepository})
    : _categoryRepository = categoryRepository;

  @override
  Future<Either<Failure, dynamic>> call() {
    return _categoryRepository.getAllCategories();
  }
}
