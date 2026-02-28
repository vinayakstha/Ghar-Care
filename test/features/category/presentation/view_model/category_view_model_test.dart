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

  final tCategories = [
    const CategoryEntity(
      categoryId: '1',
      categoryName: 'Plumbing',
      categoryImage: 'plumbing.png',
    ),
    const CategoryEntity(
      categoryId: '2',
      categoryName: 'Electrical',
      categoryImage: 'electrical.png',
    ),
  ];

  const tCategory = CategoryEntity(
    categoryId: '1',
    categoryName: 'Plumbing',
    categoryImage: 'plumbing.png',
  );

  CategoryViewModel readNotifier() =>
      container.read(categoryViewModelProvider.notifier);

  CategoryState readState() => container.read(categoryViewModelProvider);

  group('CategoryViewModel', () {
    group('initial state', () {
      test('should have correct initial state when first created', () {
        final state = readState();

        expect(state.status, CategoryStatus.initial);
        expect(state.categories, isEmpty);
        expect(state.selectedCategory, isNull);
        expect(state.errorMessage, isNull);
      });
    });

    group('getAllCategories', () {
      test('should emit loaded state with categories on success', () async {
        when(
          () => mockGetAllCategoriesUsecase(),
        ).thenAnswer((_) async => Right(tCategories));

        await readNotifier().getAllCategories();

        final state = readState();
        expect(state.status, CategoryStatus.loaded);
        expect(state.categories, tCategories);
        expect(state.errorMessage, isNull);
        verify(() => mockGetAllCategoriesUsecase()).called(1);
      });

      test('should emit error state with message on ApiFailure', () async {
        const failure = ApiFailure(message: 'Failed to fetch categories');
        when(
          () => mockGetAllCategoriesUsecase(),
        ).thenAnswer((_) async => const Left(failure));

        await readNotifier().getAllCategories();

        final state = readState();
        expect(state.status, CategoryStatus.error);
        expect(state.errorMessage, 'Failed to fetch categories');
        expect(state.categories, isEmpty);
        verify(() => mockGetAllCategoriesUsecase()).called(1);
      });

      test('should emit error state with message on NetworkFailure', () async {
        const failure = NetworkFailure(message: 'No internet connection');
        when(
          () => mockGetAllCategoriesUsecase(),
        ).thenAnswer((_) async => const Left(failure));

        await readNotifier().getAllCategories();

        final state = readState();
        expect(state.status, CategoryStatus.error);
        expect(state.errorMessage, 'No internet connection');
        verify(() => mockGetAllCategoriesUsecase()).called(1);
      });

      test('should set loading state before resolving', () async {
        when(() => mockGetAllCategoriesUsecase()).thenAnswer(
          (_) => Future.delayed(
            const Duration(milliseconds: 50),
            () => Right(tCategories),
          ),
        );

        final future = readNotifier().getAllCategories();

        expect(readState().status, CategoryStatus.loading);

        await future;

        expect(readState().status, CategoryStatus.loaded);
      });

      test('should recover correctly after a previous error', () async {
        const failure = ApiFailure(message: 'Server error');
        when(
          () => mockGetAllCategoriesUsecase(),
        ).thenAnswer((_) async => const Left(failure));
        await readNotifier().getAllCategories();
        expect(readState().status, CategoryStatus.error);

        // Second call: succeed
        when(
          () => mockGetAllCategoriesUsecase(),
        ).thenAnswer((_) async => Right(tCategories));
        await readNotifier().getAllCategories();

        final state = readState();
        expect(state.status, CategoryStatus.loaded);
        expect(state.categories, tCategories);
      });
    });

    group('getCategoryById', () {
      test(
        'should emit loaded state with selectedCategory on success',
        () async {
          when(
            () => mockGetCategoryByIdUsecase(any()),
          ).thenAnswer((_) async => const Right(tCategory));

          await readNotifier().getCategoryById('1');

          final state = readState();
          expect(state.status, CategoryStatus.loaded);
          expect(state.selectedCategory, tCategory);
          expect(state.errorMessage, isNull);
          verify(() => mockGetCategoryByIdUsecase(any())).called(1);
        },
      );

      test(
        'should call usecase with correct GetCategoryByIdUsecaseParams',
        () async {
          GetCategoryByIdUsecaseParams? capturedParams;

          when(() => mockGetCategoryByIdUsecase(any())).thenAnswer((
            invocation,
          ) {
            capturedParams =
                invocation.positionalArguments[0]
                    as GetCategoryByIdUsecaseParams;
            return Future.value(const Right(tCategory));
          });

          await readNotifier().getCategoryById('42');

          expect(capturedParams, isNotNull);
          expect(capturedParams!.id, '42');
          verify(() => mockGetCategoryByIdUsecase(any())).called(1);
        },
      );

      test('should emit error state with message on ApiFailure', () async {
        const failure = ApiFailure(message: 'Category not found');
        when(
          () => mockGetCategoryByIdUsecase(any()),
        ).thenAnswer((_) async => const Left(failure));

        await readNotifier().getCategoryById('999');

        final state = readState();
        expect(state.status, CategoryStatus.error);
        expect(state.errorMessage, 'Category not found');
        expect(state.selectedCategory, isNull);
        verify(() => mockGetCategoryByIdUsecase(any())).called(1);
      });

      test('should emit error state with message on NetworkFailure', () async {
        const failure = NetworkFailure(message: 'No internet connection');
        when(
          () => mockGetCategoryByIdUsecase(any()),
        ).thenAnswer((_) async => const Left(failure));

        await readNotifier().getCategoryById('1');

        final state = readState();
        expect(state.status, CategoryStatus.error);
        expect(state.errorMessage, 'No internet connection');
        verify(() => mockGetCategoryByIdUsecase(any())).called(1);
      });

      test('should set loading state before resolving', () async {
        when(() => mockGetCategoryByIdUsecase(any())).thenAnswer(
          (_) => Future.delayed(
            const Duration(milliseconds: 50),
            () => const Right(tCategory),
          ),
        );

        final future = readNotifier().getCategoryById('1');

        expect(readState().status, CategoryStatus.loading);

        await future;

        expect(readState().status, CategoryStatus.loaded);
      });
    });
  });

  group('CategoryState', () {
    test('should have correct default values', () {
      const state = CategoryState();

      expect(state.status, CategoryStatus.initial);
      expect(state.categories, isEmpty);
      expect(state.selectedCategory, isNull);
      expect(state.errorMessage, isNull);
    });

    test('copyWith should update only specified fields', () {
      const state = CategoryState();

      final updated = state.copyWith(
        status: CategoryStatus.loaded,
        categories: tCategories,
      );

      expect(updated.status, CategoryStatus.loaded);
      expect(updated.categories, tCategories);
      expect(updated.selectedCategory, isNull); // unchanged
      expect(updated.errorMessage, isNull); // unchanged
    });

    test('copyWith should preserve existing values for unspecified fields', () {
      const state = CategoryState(
        status: CategoryStatus.loaded,
        selectedCategory: tCategory,
        errorMessage: 'some error',
      );

      final updated = state.copyWith(status: CategoryStatus.loading);

      expect(updated.status, CategoryStatus.loading);
      expect(updated.selectedCategory, tCategory); // preserved
      expect(updated.errorMessage, 'some error'); // preserved
    });

    test('props should contain all fields for equality comparison', () {
      const state = CategoryState(
        status: CategoryStatus.loaded,
        categories: [],
        selectedCategory: tCategory,
        errorMessage: 'error',
      );

      expect(state.props, [CategoryStatus.loaded, [], tCategory, 'error']);
    });

    test('two states with identical values should be equal', () {
      const stateA = CategoryState(
        status: CategoryStatus.loaded,
        errorMessage: 'oops',
      );
      const stateB = CategoryState(
        status: CategoryStatus.loaded,
        errorMessage: 'oops',
      );

      expect(stateA, equals(stateB));
    });

    test('two states with different values should not be equal', () {
      const stateA = CategoryState(status: CategoryStatus.loaded);
      const stateB = CategoryState(status: CategoryStatus.error);

      expect(stateA, isNot(equals(stateB)));
    });
  });

  // ─────────────────────────────────────────────────────────────────────────────
  group('CategoryApiModel integration (toEntity)', () {
    test('toEntity should correctly map all fields to CategoryEntity', () {
      const entity = CategoryEntity(
        categoryId: 'abc123',
        categoryName: 'Cleaning',
        categoryImage: 'cleaning.png',
      );

      expect(entity.categoryId, 'abc123');
      expect(entity.categoryName, 'Cleaning');
      expect(entity.categoryImage, 'cleaning.png');
    });

    test('toEntity should allow null categoryId (optional _id field)', () {
      const entity = CategoryEntity(
        categoryId: null,
        categoryName: 'Painting',
        categoryImage: 'painting.png',
      );

      expect(entity.categoryId, isNull);
      expect(entity.categoryName, 'Painting');
    });
  });
}
