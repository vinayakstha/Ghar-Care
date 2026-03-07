import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ghar_care/core/error/failures.dart';
import 'package:ghar_care/features/category/domain/entities/category_entity.dart';
import 'package:ghar_care/features/category/domain/repository/category_repository.dart';
import 'package:ghar_care/features/category/domain/usecases/get_category_by_id_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockCategoryRepository extends Mock implements ICategoryRepository {}

const tCategory = CategoryEntity(
  categoryId: 'c1',
  categoryName: 'Plumbing',
  categoryImage: 'plumbing.png',
);

const tParams = GetCategoryByIdUsecaseParams(id: 'c1');

void main() {
  late MockCategoryRepository mockCategoryRepository;
  late GetCategoryByIdUsecase usecase;

  setUp(() {
    mockCategoryRepository = MockCategoryRepository();
    usecase = GetCategoryByIdUsecase(
      categoryRepository: mockCategoryRepository,
    );
  });

  group('GetCategoryByIdUsecase', () {
    test('should return CategoryEntity on success', () async {
      when(
        () => mockCategoryRepository.getCategoryById('c1'),
      ).thenAnswer((_) async => const Right(tCategory));

      final result = await usecase(tParams);

      expect(result, const Right(tCategory));
      verify(() => mockCategoryRepository.getCategoryById('c1')).called(1);
    });

    test('should pass correct id to repository', () async {
      String? capturedId;

      when(() => mockCategoryRepository.getCategoryById(any())).thenAnswer((
        invocation,
      ) {
        capturedId = invocation.positionalArguments[0] as String;
        return Future.value(const Right(tCategory));
      });

      await usecase(const GetCategoryByIdUsecaseParams(id: 'c99'));

      expect(capturedId, 'c99');
    });

    test('should return ApiFailure on api error', () async {
      const failure = ApiFailure(message: 'Category not found');
      when(
        () => mockCategoryRepository.getCategoryById('c1'),
      ).thenAnswer((_) async => const Left(failure));

      final result = await usecase(tParams);

      expect(result, const Left(failure));
    });

    test('should return NetworkFailure on network error', () async {
      const failure = NetworkFailure(message: 'No internet connection');
      when(
        () => mockCategoryRepository.getCategoryById('c1'),
      ).thenAnswer((_) async => const Left(failure));

      final result = await usecase(tParams);

      expect(result, const Left(failure));
    });

    test('should call repository exactly once per invocation', () async {
      when(
        () => mockCategoryRepository.getCategoryById('c1'),
      ).thenAnswer((_) async => const Right(tCategory));

      await usecase(tParams);

      verify(() => mockCategoryRepository.getCategoryById('c1')).called(1);
      verifyNoMoreInteractions(mockCategoryRepository);
    });
  });
}
