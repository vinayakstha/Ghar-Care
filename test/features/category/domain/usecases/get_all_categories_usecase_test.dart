import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ghar_care/core/error/failures.dart';
import 'package:ghar_care/features/category/domain/entities/category_entity.dart';
import 'package:ghar_care/features/category/domain/repository/category_repository.dart';
import 'package:ghar_care/features/category/domain/usecases/get_all_categories_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockCategoryRepository extends Mock implements ICategoryRepository {}

final tCategories = [
  const CategoryEntity(
    categoryId: 'c1',
    categoryName: 'Plumbing',
    categoryImage: 'plumbing.png',
  ),
  const CategoryEntity(
    categoryId: 'c2',
    categoryName: 'Electrical',
    categoryImage: 'electrical.png',
  ),
];

void main() {
  late MockCategoryRepository mockCategoryRepository;
  late GetAllCategoriesUsecase usecase;

  setUp(() {
    mockCategoryRepository = MockCategoryRepository();
    usecase = GetAllCategoriesUsecase(
      categoryRepository: mockCategoryRepository,
    );
  });

  group('GetAllCategoriesUsecase', () {
    test('should return list of categories on success', () async {
      when(
        () => mockCategoryRepository.getAllCategories(),
      ).thenAnswer((_) async => Right(tCategories));

      final result = await usecase();

      expect(result, Right(tCategories));
      verify(() => mockCategoryRepository.getAllCategories()).called(1);
    });

    test('should return ApiFailure on api error', () async {
      const failure = ApiFailure(message: 'Failed to fetch categories');
      when(
        () => mockCategoryRepository.getAllCategories(),
      ).thenAnswer((_) async => const Left(failure));

      final result = await usecase();

      expect(result, const Left(failure));
    });

    test('should return NetworkFailure on network error', () async {
      const failure = NetworkFailure(message: 'No internet connection');
      when(
        () => mockCategoryRepository.getAllCategories(),
      ).thenAnswer((_) async => const Left(failure));

      final result = await usecase();

      expect(result, const Left(failure));
    });

    test('should call repository exactly once per invocation', () async {
      when(
        () => mockCategoryRepository.getAllCategories(),
      ).thenAnswer((_) async => Right(tCategories));

      await usecase();

      verify(() => mockCategoryRepository.getAllCategories()).called(1);
      verifyNoMoreInteractions(mockCategoryRepository);
    });
  });
}
