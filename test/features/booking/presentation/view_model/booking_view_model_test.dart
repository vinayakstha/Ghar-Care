import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ghar_care/core/error/failures.dart';
import 'package:ghar_care/features/booking/domain/entities/booking_entity.dart';
import 'package:ghar_care/features/booking/domain/usecases/create_booking_usecase.dart';
import 'package:ghar_care/features/booking/domain/usecases/delete_booking_usecase.dart';
import 'package:ghar_care/features/booking/domain/usecases/get_booking_by_user_usecase.dart';
import 'package:ghar_care/features/booking/presentation/state/booking_state.dart';
import 'package:ghar_care/features/booking/presentation/view_model/booking_view_model.dart';
import 'package:mocktail/mocktail.dart';

class MockCreateBookingUsecase extends Mock implements CreateBookingUsecase {}

class MockGetBookingsByUserUsecase extends Mock
    implements GetBookingsByUserUsecase {}

class MockDeleteBookingUsecase extends Mock implements DeleteBookingUsecase {}

const tBooking = BookingEntity(
  bookingId: 'b1',
  userId: 'u1',
  serviceId: 's1',
  bookingDate: '2024-01-15',
  bookingTime: '10:00 AM',
  price: '500',
  location: 'Kathmandu',
  status: 'pending',
);

void main() {
  late MockCreateBookingUsecase mockCreateBookingUsecase;
  late MockGetBookingsByUserUsecase mockGetBookingsByUserUsecase;
  late MockDeleteBookingUsecase mockDeleteBookingUsecase;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(
      const CreateBookingUsecaseParams(
        serviceId: 'fallback',
        bookingDate: 'fallback',
        bookingTime: 'fallback',
        price: 'fallback',
        location: 'fallback',
      ),
    );
    registerFallbackValue(const DeleteBookingParams(bookingId: 'fallback'));
  });

  setUp(() {
    mockCreateBookingUsecase = MockCreateBookingUsecase();
    mockGetBookingsByUserUsecase = MockGetBookingsByUserUsecase();
    mockDeleteBookingUsecase = MockDeleteBookingUsecase();

    container = ProviderContainer(
      overrides: [
        createBookingUsecaseProvider.overrideWithValue(
          mockCreateBookingUsecase,
        ),
        getBookingsByUserUsecaseProvider.overrideWithValue(
          mockGetBookingsByUserUsecase,
        ),
        deleteBookingUsecaseProvider.overrideWithValue(
          mockDeleteBookingUsecase,
        ),
      ],
    );
  });

  tearDown(() => container.dispose());

  BookingViewModel readNotifier() =>
      container.read(bookingViewModelProvider.notifier);

  BookingState readState() => container.read(bookingViewModelProvider);

  group('BookingViewModel', () {
    test('should have correct initial state', () {
      final state = readState();

      expect(state.status, BookingStatus.initial);
      expect(state.bookings, isEmpty);
      expect(state.selectedBooking, isNull);
      expect(state.errorMessage, isNull);
    });

    test(
      'createBooking: should append booking and emit loaded on success',
      () async {
        when(
          () => mockCreateBookingUsecase(any()),
        ).thenAnswer((_) async => const Right(tBooking));

        await readNotifier().createBooking(
          serviceId: 's1',
          bookingDate: '2024-01-15',
          bookingTime: '10:00 AM',
          price: '500',
          location: 'Kathmandu',
        );

        final state = readState();
        expect(state.status, BookingStatus.loaded);
        expect(state.bookings, contains(tBooking));
        expect(state.errorMessage, isNull);
      },
    );

    test('getBookingsByUser: should emit error state on failure', () async {
      const failure = ApiFailure(message: 'Failed to fetch bookings');
      when(
        () => mockGetBookingsByUserUsecase(),
      ).thenAnswer((_) async => const Left(failure));

      await readNotifier().getBookingsByUser();

      final state = readState();
      expect(state.status, BookingStatus.error);
      expect(state.errorMessage, 'Failed to fetch bookings');
      expect(state.bookings, isEmpty);
    });

    test(
      'deleteBooking: should remove booking from list and return true',
      () async {
        when(
          () => mockGetBookingsByUserUsecase(),
        ).thenAnswer((_) async => const Right([tBooking]));
        await readNotifier().getBookingsByUser();

        when(
          () => mockDeleteBookingUsecase(any()),
        ).thenAnswer((_) async => const Right(true));

        final result = await readNotifier().deleteBooking('b1');

        expect(result, isTrue);
        expect(readState().status, BookingStatus.loaded);
        expect(readState().bookings.any((b) => b.bookingId == 'b1'), isFalse);
      },
    );

    test(
      'deleteBooking: should return false and emit error on failure',
      () async {
        const failure = ApiFailure(message: 'Delete failed');
        when(
          () => mockDeleteBookingUsecase(any()),
        ).thenAnswer((_) async => const Left(failure));

        final result = await readNotifier().deleteBooking('b1');

        expect(result, isFalse);
        expect(readState().status, BookingStatus.error);
        expect(readState().errorMessage, 'Delete failed');
      },
    );
  });
}
