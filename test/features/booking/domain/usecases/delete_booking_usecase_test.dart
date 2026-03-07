import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ghar_care/core/error/failures.dart';
import 'package:ghar_care/features/booking/domain/repository/booking_repository.dart';
import 'package:ghar_care/features/booking/domain/usecases/delete_booking_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockBookingRepository extends Mock implements IBookingRepository {}

const tParams = DeleteBookingParams(bookingId: 'b1');

void main() {
  late MockBookingRepository mockBookingRepository;
  late DeleteBookingUsecase usecase;

  setUp(() {
    mockBookingRepository = MockBookingRepository();
    usecase = DeleteBookingUsecase(bookingRepository: mockBookingRepository);
  });

  group('DeleteBookingUsecase', () {
    test('should return true on success', () async {
      when(
        () => mockBookingRepository.deleteBooking('b1'),
      ).thenAnswer((_) async => const Right(true));

      final result = await usecase(tParams);

      expect(result, const Right(true));
      verify(() => mockBookingRepository.deleteBooking('b1')).called(1);
    });

    test('should pass correct bookingId to repository', () async {
      String? capturedId;

      when(() => mockBookingRepository.deleteBooking(any())).thenAnswer((
        invocation,
      ) {
        capturedId = invocation.positionalArguments[0] as String;
        return Future.value(const Right(true));
      });

      await usecase(const DeleteBookingParams(bookingId: 'b99'));

      expect(capturedId, 'b99');
    });

    test('should return ApiFailure on api error', () async {
      const failure = ApiFailure(message: 'Failed to delete booking');
      when(
        () => mockBookingRepository.deleteBooking('b1'),
      ).thenAnswer((_) async => const Left(failure));

      final result = await usecase(tParams);

      expect(result, const Left(failure));
    });

    test('should return NetworkFailure on network error', () async {
      const failure = NetworkFailure(message: 'No internet connection');
      when(
        () => mockBookingRepository.deleteBooking('b1'),
      ).thenAnswer((_) async => const Left(failure));

      final result = await usecase(tParams);

      expect(result, const Left(failure));
    });

    test('should call repository exactly once per invocation', () async {
      when(
        () => mockBookingRepository.deleteBooking('b1'),
      ).thenAnswer((_) async => const Right(true));

      await usecase(tParams);

      verify(() => mockBookingRepository.deleteBooking('b1')).called(1);
      verifyNoMoreInteractions(mockBookingRepository);
    });
  });
}
