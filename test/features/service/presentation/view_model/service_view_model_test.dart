import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ghar_care/core/error/failures.dart';
import 'package:ghar_care/features/service/domain/entities/service_entity.dart';
import 'package:ghar_care/features/service/domain/usercases/get_service_by_id_usecase.dart';
import 'package:ghar_care/features/service/domain/usercases/get_services_by_category_usecase.dart';
import 'package:ghar_care/features/service/presentation/state/service_state.dart';
import 'package:ghar_care/features/service/presentation/view_model/service_view_model.dart';
import 'package:mocktail/mocktail.dart';

class MockGetServicesByCategoryUsecase extends Mock
    implements GetServicesByCategoryUsecase {}

class MockGetServiceByIdUsecase extends Mock implements GetServiceByIdUsecase {}

const tService = ServiceEntity(
  serviceId: 's1',
  serviceName: 'Pipe Repair',
  serviceImage: 'pipe.png',
  serviceDescription: 'Fix broken pipes',
  categoryId: 'c1',
  price: '800',
);

final tServices = [tService];

void main() {
  late MockGetServicesByCategoryUsecase mockGetServicesByCategoryUsecase;
  late MockGetServiceByIdUsecase mockGetServiceByIdUsecase;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(
      const GetServicesByCategoryUsecaseParams(id: 'fallback'),
    );
    registerFallbackValue(const GetServiceByIdUsecaseParams(id: 'fallback'));
  });

  setUp(() {
    mockGetServicesByCategoryUsecase = MockGetServicesByCategoryUsecase();
    mockGetServiceByIdUsecase = MockGetServiceByIdUsecase();

    container = ProviderContainer(
      overrides: [
        getServicesByCategoryUsecaseProvider.overrideWithValue(
          mockGetServicesByCategoryUsecase,
        ),
        getServiceByIdUsecaseProvider.overrideWithValue(
          mockGetServiceByIdUsecase,
        ),
      ],
    );
  });

  tearDown(() => container.dispose());

  ServiceViewModel readNotifier() =>
      container.read(serviceViewModelProvider.notifier);

  ServiceState readState() => container.read(serviceViewModelProvider);

  group('ServiceViewModel', () {
    test('should have correct initial state', () {
      final state = readState();

      expect(state.status, ServiceStatus.initial);
      expect(state.services, isEmpty);
      expect(state.selectedService, isNull);
      expect(state.errorMessage, isNull);
    });

    test(
      'getServicesByCategory: should emit loaded state with services on success',
      () async {
        when(
          () => mockGetServicesByCategoryUsecase(any()),
        ).thenAnswer((_) async => Right(tServices));

        await readNotifier().getServicesByCategory('c1');

        final state = readState();
        expect(state.status, ServiceStatus.loaded);
        expect(state.services, tServices);
        expect(state.errorMessage, isNull);
      },
    );

    test('getServicesByCategory: should emit error state on failure', () async {
      const failure = ApiFailure(message: 'Failed to fetch services');
      when(
        () => mockGetServicesByCategoryUsecase(any()),
      ).thenAnswer((_) async => const Left(failure));

      await readNotifier().getServicesByCategory('c1');

      final state = readState();
      expect(state.status, ServiceStatus.error);
      expect(state.errorMessage, 'Failed to fetch services');
      expect(state.services, isEmpty);
    });

    test(
      'getServiceById: should emit loaded state with selectedService on success',
      () async {
        when(
          () => mockGetServiceByIdUsecase(any()),
        ).thenAnswer((_) async => const Right(tService));

        await readNotifier().getServiceById('s1');

        final state = readState();
        expect(state.status, ServiceStatus.loaded);
        expect(state.selectedService, tService);
        expect(state.errorMessage, isNull);
      },
    );

    test('getServiceById: should emit error state on failure', () async {
      const failure = NetworkFailure(message: 'No internet connection');
      when(
        () => mockGetServiceByIdUsecase(any()),
      ).thenAnswer((_) async => const Left(failure));

      await readNotifier().getServiceById('s1');

      final state = readState();
      expect(state.status, ServiceStatus.error);
      expect(state.errorMessage, 'No internet connection');
      expect(state.selectedService, isNull);
    });
  });
}
