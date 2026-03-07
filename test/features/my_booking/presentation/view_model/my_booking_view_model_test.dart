import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ghar_care/core/error/failures.dart';
import 'package:ghar_care/features/my_booking/domain/entities/my_booking_entity.dart';
import 'package:ghar_care/features/my_booking/domain/usecases/get_booking_by_user_usecase.dart';
import 'package:ghar_care/features/my_booking/presentation/state/my_booking_state.dart';
import 'package:ghar_care/features/my_booking/presentation/view_model/my_booking_view_model.dart';
import 'package:ghar_care/features/service/domain/entities/service_entity.dart';
import 'package:mocktail/mocktail.dart';

class MockGetMyBookingsByUserUsecase extends Mock
    implements GetMyBookingsByUserUsecase {}

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
  late MockGetMyBookingsByUserUsecase mockGetMyBookingsByUserUsecase;
  late ProviderContainer container;

  setUp(() {
    mockGetMyBookingsByUserUsecase = MockGetMyBookingsByUserUsecase();

    container = ProviderContainer(
      overrides: [
        getMyBookingsByUserUsecaseProvider.overrideWithValue(
          mockGetMyBookingsByUserUsecase,
        ),
      ],
    );
  });

  tearDown(() => container.dispose());

  MyBookingViewModel readNotifier() =>
      container.read(myBookingViewModelProvider.notifier);

  MyBookingState readState() => container.read(myBookingViewModelProvider);

  group('MyBookingViewModel', () {
    test('should have correct initial state', () {
      final state = readState();

      expect(state.status, MyBookingStatus.initial);
      expect(state.bookings, isEmpty);
      expect(state.selectedBooking, isNull);
      expect(state.errorMessage, isNull);
    });

    test(
      'getBookingsByUser: should emit loaded state with bookings on success',
      () async {
        when(
          () => mockGetMyBookingsByUserUsecase(),
        ).thenAnswer((_) async => const Right([tBooking]));

        await readNotifier().getBookingsByUser();

        final state = readState();
        expect(state.status, MyBookingStatus.loaded);
        expect(state.bookings, [tBooking]);
        expect(state.errorMessage, isNull);
      },
    );

    test('getBookingsByUser: should emit error state on ApiFailure', () async {
      const failure = ApiFailure(message: 'Failed to fetch bookings');
      when(
        () => mockGetMyBookingsByUserUsecase(),
      ).thenAnswer((_) async => const Left(failure));

      await readNotifier().getBookingsByUser();

      final state = readState();
      expect(state.status, MyBookingStatus.error);
      expect(state.errorMessage, 'Failed to fetch bookings');
      expect(state.bookings, isEmpty);
    });

    test(
      'getBookingsByUser: should emit error state on NetworkFailure',
      () async {
        const failure = NetworkFailure(message: 'No internet connection');
        when(
          () => mockGetMyBookingsByUserUsecase(),
        ).thenAnswer((_) async => const Left(failure));

        await readNotifier().getBookingsByUser();

        final state = readState();
        expect(state.status, MyBookingStatus.error);
        expect(state.errorMessage, 'No internet connection');
      },
    );

    test('selectBooking: should update selectedBooking in state', () {
      readNotifier().selectBooking(tBooking);

      expect(readState().selectedBooking, tBooking);
    });
  });
}
