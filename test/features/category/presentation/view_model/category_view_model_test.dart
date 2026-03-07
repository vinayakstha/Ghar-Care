import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ghar_care/core/error/failures.dart';
import 'package:ghar_care/features/category/domain/entities/category_entity.dart';
import 'package:ghar_care/features/category/domain/usecases/get_all_categories_usecase.dart';
import 'package:ghar_care/features/category/domain/usecases/get_category_by_id_usecase.dart';
import 'package:ghar_care/features/category/presentation/state/category_state.dart';
import 'package:ghar_care/features/category/presentation/view_model/category_view_model.dart';
import 'package:mocktail/mocktail.dart';

class MockGetAllCategoriesUsecase extends Mock
    implements GetAllCategoriesUsecase {}

class MockGetCategoryByIdUsecase extends Mock
    implements GetCategoryByIdUsecase {}

const tCategory = CategoryEntity(
  categoryId: '1',
  categoryName: 'Plumbing',
  categoryImage: 'plumbing.png',
);

final tCategories = [
  tCategory,
  const CategoryEntity(
    categoryId: '2',
    categoryName: 'Electrical',
    categoryImage: 'electrical.png',
  ),
];

void main() {
  late MockGetAllCategoriesUsecase mockGetAllCategoriesUsecase;
  late MockGetCategoryByIdUsecase mockGetCategoryByIdUsecase;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(const GetCategoryByIdUsecaseParams(id: 'fallback'));
  });

  setUp(() {
    mockGetAllCategoriesUsecase = MockGetAllCategoriesUsecase();
    mockGetCategoryByIdUsecase = MockGetCategoryByIdUsecase();

    container = ProviderContainer(
      overrides: [
        getAllCategoriesUsecaseProvider.overrideWithValue(
          mockGetAllCategoriesUsecase,
        ),
        getCategoryByIdUsecaseProvider.overrideWithValue(
          mockGetCategoryByIdUsecase,
        ),
      ],
    );
  });

  tearDown(() => container.dispose());

  CategoryViewModel readNotifier() =>
      container.read(categoryViewModelProvider.notifier);

  CategoryState readState() => container.read(categoryViewModelProvider);

  group('CategoryViewModel', () {
    test('should have correct initial state', () {
      final state = readState();

      expect(state.status, CategoryStatus.initial);
      expect(state.categories, isEmpty);
      expect(state.selectedCategory, isNull);
      expect(state.errorMessage, isNull);
    });

    test(
      'getAllCategories: should emit loaded state with categories on success',
      () async {
        when(
          () => mockGetAllCategoriesUsecase(),
        ).thenAnswer((_) async => Right(tCategories));

        await readNotifier().getAllCategories();

        final state = readState();
        expect(state.status, CategoryStatus.loaded);
        expect(state.categories, tCategories);
        expect(state.errorMessage, isNull);
      },
    );

    test('getAllCategories: should emit error state on failure', () async {
      const failure = ApiFailure(message: 'Failed to fetch categories');
      when(
        () => mockGetAllCategoriesUsecase(),
      ).thenAnswer((_) async => const Left(failure));

      await readNotifier().getAllCategories();

      final state = readState();
      expect(state.status, CategoryStatus.error);
      expect(state.errorMessage, 'Failed to fetch categories');
      expect(state.categories, isEmpty);
    });

    test(
      'getCategoryById: should emit loaded state with selectedCategory on success',
      () async {
        when(
          () => mockGetCategoryByIdUsecase(any()),
        ).thenAnswer((_) async => const Right(tCategory));

        await readNotifier().getCategoryById('1');

        final state = readState();
        expect(state.status, CategoryStatus.loaded);
        expect(state.selectedCategory, tCategory);
        expect(state.errorMessage, isNull);
      },
    );

    test('getCategoryById: should emit error state on failure', () async {
      const failure = NetworkFailure(message: 'No internet connection');
      when(
        () => mockGetCategoryByIdUsecase(any()),
      ).thenAnswer((_) async => const Left(failure));

      await readNotifier().getCategoryById('1');

      final state = readState();
      expect(state.status, CategoryStatus.error);
      expect(state.errorMessage, 'No internet connection');
      expect(state.selectedCategory, isNull);
    });
  });
}
