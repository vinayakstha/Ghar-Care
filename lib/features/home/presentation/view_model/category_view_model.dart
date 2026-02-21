import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ghar_care/features/home/domain/usecases/get_all_categories_usecase.dart';
import 'package:ghar_care/features/home/domain/usecases/get_category_by_id_usecase.dart';
import 'package:ghar_care/features/home/presentation/state/category_state.dart';

final categoryViewModelProvider =
    NotifierProvider<CategoryViewModel, CategoryState>(
      () => CategoryViewModel(),
    );

class CategoryViewModel extends Notifier<CategoryState> {
  late final GetAllCategoriesUsecase _getAllCategoriesUsecase;
  late final GetCategoryByIdUsecase _getCategoryByIdUsecase;

  @override
  CategoryState build() {
    _getAllCategoriesUsecase = ref.read(getAllCategoriesUsecaseProvider);
    _getCategoryByIdUsecase = ref.read(getCategoryByIdUsecaseProvider);
    return const CategoryState();
  }

  // Get All Categories
  Future<void> getAllCategories() async {
    state = state.copyWith(status: CategoryStatus.loading);

    final result = await _getAllCategoriesUsecase();

    result.fold(
      (failure) {
        state = state.copyWith(
          status: CategoryStatus.error,
          errorMessage: failure.message,
        );
      },
      (categories) {
        state = state.copyWith(
          status: CategoryStatus.loaded,
          categories: categories,
        );
      },
    );
  }

  //Get Category By Id
  Future<void> getCategoryById(String categoryId) async {
    state = state.copyWith(status: CategoryStatus.loading);

    final result = await _getCategoryByIdUsecase(
      GetCategoryByIdUsecaseParams(id: categoryId),
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          status: CategoryStatus.error,
          errorMessage: failure.message,
        );
      },
      (category) {
        state = state.copyWith(
          status: CategoryStatus.loaded,
          selectedCategory: category,
        );
      },
    );
  }
}
