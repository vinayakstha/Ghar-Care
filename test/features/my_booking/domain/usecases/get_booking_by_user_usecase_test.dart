import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ghar_care/core/error/failures.dart';
import 'package:ghar_care/features/my_booking/domain/entities/my_booking_entity.dart';
import 'package:ghar_care/features/my_booking/domain/repository/my_booking_repository.dart';
import 'package:ghar_care/features/my_booking/domain/usecases/get_booking_by_user_usecase.dart';
import 'package:ghar_care/features/service/domain/entities/service_entity.dart';
import 'package:mocktail/mocktail.dart';

class MockMyBookingRepository extends Mock implements IMyBookingRepository {}

const tService = ServiceEntity(
  serviceId: 's1',
  serviceName: 'Pipe Repair',
  serviceImage: 'pipe.png',
  serviceDescription: 'Fix broken pipes',
  categoryId: 'c1',
  price: '800',
);

const tBooking = MyBookingEntity(
  bookingId: 'b1',
  userId: 'u1',
  service: tService,
  bookingDate: '2024-01-15',
  bookingTime: '10:00 AM',
  price: '800',
  location: 'Kathmandu',
  status: 'pending',
);

void main() {
  late MockMyBookingRepository mockMyBookingRepository;
  late GetMyBookingsByUserUsecase usecase;

  setUp(() {
    mockMyBookingRepository = MockMyBookingRepository();
    usecase = GetMyBookingsByUserUsecase(
      myBookingRepository: mockMyBookingRepository,
    );
  });

  group('GetMyBookingsByUserUsecase', () {
    test('should return list of bookings on success', () async {
      when(
        () => mockMyBookingRepository.getBookingsByUser(),
      ).thenAnswer((_) async => const Right([tBooking]));

      final result = await usecase();

      expect(result, const Right([tBooking]));
      verify(() => mockMyBookingRepository.getBookingsByUser()).called(1);
    });

    test('should return ApiFailure on api error', () async {
      const failure = ApiFailure(message: 'Failed to fetch bookings');
      when(
        () => mockMyBookingRepository.getBookingsByUser(),
      ).thenAnswer((_) async => const Left(failure));

      final result = await usecase();

      expect(result, const Left(failure));
    });

    test('should return NetworkFailure on network error', () async {
      const failure = NetworkFailure(message: 'No internet connection');
      when(
        () => mockMyBookingRepository.getBookingsByUser(),
      ).thenAnswer((_) async => const Left(failure));

      final result = await usecase();

      expect(result, const Left(failure));
    });

    test('should call repository exactly once per invocation', () async {
      when(
        () => mockMyBookingRepository.getBookingsByUser(),
      ).thenAnswer((_) async => const Right([tBooking]));

      await usecase();

      verify(() => mockMyBookingRepository.getBookingsByUser()).called(1);
      verifyNoMoreInteractions(mockMyBookingRepository);
    });
  });
}
