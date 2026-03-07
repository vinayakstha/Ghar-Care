import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ghar_care/core/error/failures.dart';
import 'package:ghar_care/features/booking/domain/entities/booking_entity.dart';
import 'package:ghar_care/features/booking/domain/repository/booking_repository.dart';
import 'package:ghar_care/features/booking/domain/usecases/create_booking_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockBookingRepository extends Mock implements IBookingRepository {}

const tParams = CreateBookingUsecaseParams(
  serviceId: 's1',
  bookingDate: '2024-01-15',
  bookingTime: '10:00 AM',
  price: '500',
  location: 'Kathmandu',
);

const tBooking = BookingEntity(
  bookingId: 'b1',
  userId: '',
  serviceId: 's1',
  bookingDate: '2024-01-15',
  bookingTime: '10:00 AM',
  price: '500',
  location: 'Kathmandu',
);

void main() {
  late MockBookingRepository mockBookingRepository;
  late CreateBookingUsecase usecase;

  setUpAll(() {
    registerFallbackValue(
      const BookingEntity(
        userId: '',
        serviceId: 'fallback',
        bookingDate: 'fallback',
        bookingTime: 'fallback',
        price: 'fallback',
        location: 'fallback',
      ),
    );
  });

  setUp(() {
    mockBookingRepository = MockBookingRepository();
    usecase = CreateBookingUsecase(bookingRepository: mockBookingRepository);
  });

  group('CreateBookingUsecase', () {
    test('should return BookingEntity on success', () async {
      when(
        () => mockBookingRepository.createBooking(any()),
      ).thenAnswer((_) async => const Right(tBooking));

      final result = await usecase(tParams);

      expect(result, const Right(tBooking));
      verify(() => mockBookingRepository.createBooking(any())).called(1);
    });

    test('should pass correct BookingEntity fields to repository', () async {
      BookingEntity? capturedBooking;

      when(() => mockBookingRepository.createBooking(any())).thenAnswer((
        invocation,
      ) {
        capturedBooking = invocation.positionalArguments[0] as BookingEntity;
        return Future.value(const Right(tBooking));
      });

      await usecase(tParams);

      expect(capturedBooking?.serviceId, 's1');
      expect(capturedBooking?.bookingDate, '2024-01-15');
      expect(capturedBooking?.bookingTime, '10:00 AM');
      expect(capturedBooking?.price, '500');
      expect(capturedBooking?.location, 'Kathmandu');
    });

    test('should return ApiFailure on api error', () async {
      const failure = ApiFailure(message: 'Failed to create booking');
      when(
        () => mockBookingRepository.createBooking(any()),
      ).thenAnswer((_) async => const Left(failure));

      final result = await usecase(tParams);

      expect(result, const Left(failure));
    });

    test('should return NetworkFailure on network error', () async {
      const failure = NetworkFailure(message: 'No internet connection');
      when(
        () => mockBookingRepository.createBooking(any()),
      ).thenAnswer((_) async => const Left(failure));

      final result = await usecase(tParams);

      expect(result, const Left(failure));
    });

    test('should call repository exactly once per invocation', () async {
      when(
        () => mockBookingRepository.createBooking(any()),
      ).thenAnswer((_) async => const Right(tBooking));

      await usecase(tParams);

      verify(() => mockBookingRepository.createBooking(any())).called(1);
      verifyNoMoreInteractions(mockBookingRepository);
    });
  });
}
