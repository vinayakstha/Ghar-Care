import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ghar_care/core/error/failures.dart';
import 'package:ghar_care/features/service/domain/entities/service_entity.dart';
import 'package:ghar_care/features/service/domain/repository/service_repository.dart';
import 'package:ghar_care/features/service/domain/usercases/get_services_by_category_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockServiceRepository extends Mock implements IServiceRepository {}

const tParams = GetServicesByCategoryUsecaseParams(id: 'c1');

final tServices = [
  const ServiceEntity(
    serviceId: 's1',
    serviceName: 'Pipe Repair',
    serviceImage: 'pipe.png',
    serviceDescription: 'Fix broken pipes',
    categoryId: 'c1',
    price: '800',
  ),
  const ServiceEntity(
    serviceId: 's2',
    serviceName: 'Drain Cleaning',
    serviceImage: 'drain.png',
    serviceDescription: 'Clean blocked drains',
    categoryId: 'c1',
    price: '600',
  ),
];

void main() {
  late MockServiceRepository mockServiceRepository;
  late GetServicesByCategoryUsecase usecase;

  setUp(() {
    mockServiceRepository = MockServiceRepository();
    usecase = GetServicesByCategoryUsecase(
      serviceRepository: mockServiceRepository,
    );
  });

  group('GetServicesByCategoryUsecase', () {
    test('should return list of services on success', () async {
      when(
        () => mockServiceRepository.getServicesByCategory('c1'),
      ).thenAnswer((_) async => Right(tServices));

      final result = await usecase(tParams);

      expect(result, Right(tServices));
      verify(() => mockServiceRepository.getServicesByCategory('c1')).called(1);
    });

    test('should pass correct categoryId to repository', () async {
      String? capturedId;

      when(() => mockServiceRepository.getServicesByCategory(any())).thenAnswer(
        (invocation) {
          capturedId = invocation.positionalArguments[0] as String;
          return Future.value(Right(tServices));
        },
      );

      await usecase(const GetServicesByCategoryUsecaseParams(id: 'c99'));

      expect(capturedId, 'c99');
    });

    test('should return ApiFailure on api error', () async {
      const failure = ApiFailure(message: 'Failed to fetch services');
      when(
        () => mockServiceRepository.getServicesByCategory('c1'),
      ).thenAnswer((_) async => const Left(failure));

      final result = await usecase(tParams);

      expect(result, const Left(failure));
    });

    test('should return NetworkFailure on network error', () async {
      const failure = NetworkFailure(message: 'No internet connection');
      when(
        () => mockServiceRepository.getServicesByCategory('c1'),
      ).thenAnswer((_) async => const Left(failure));

      final result = await usecase(tParams);

      expect(result, const Left(failure));
    });
  });
}
