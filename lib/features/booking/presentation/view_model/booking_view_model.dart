import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ghar_care/features/booking/domain/usecases/create_booking_usecase.dart';
import 'package:ghar_care/features/booking/domain/usecases/get_booking_by_user_usecase.dart';
import 'package:ghar_care/features/booking/presentation/state/booking_state.dart';
import 'package:ghar_care/features/booking/domain/entities/booking_entity.dart';

final bookingViewModelProvider =
    NotifierProvider<BookingViewModel, BookingState>(() => BookingViewModel());

class BookingViewModel extends Notifier<BookingState> {
  late final CreateBookingUsecase _createBookingUsecase;
  late final GetBookingsByUserUsecase _getBookingsByUserUsecase;

  @override
  BookingState build() {
    _createBookingUsecase = ref.read(createBookingUsecaseProvider);
    _getBookingsByUserUsecase = ref.read(getBookingsByUserUsecaseProvider);
    return const BookingState();
  }

  /// Create a new booking
  Future<void> createBooking({
    required String serviceId,
    required String bookingDate,
    required String bookingTime,
    required String price,
    required String location,
  }) async {
    state = state.copyWith(status: BookingStatus.loading);

    final result = await _createBookingUsecase(
      CreateBookingUsecaseParams(
        serviceId: serviceId,
        bookingDate: bookingDate,
        bookingTime: bookingTime,
        price: price,
        location: location,
      ),
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          status: BookingStatus.error,
          errorMessage: failure.message,
        );
      },
      (booking) {
        // Add the newly created booking to the list
        final updatedBookings = List<BookingEntity>.from(state.bookings)
          ..add(booking);

        state = state.copyWith(
          status: BookingStatus.loaded,
          bookings: updatedBookings,
        );
      },
    );
  }

  /// Fetch all bookings for the current user
  Future<void> getBookingsByUser() async {
    state = state.copyWith(status: BookingStatus.loading);

    final result = await _getBookingsByUserUsecase();

    result.fold(
      (failure) {
        state = state.copyWith(
          status: BookingStatus.error,
          errorMessage: failure.message,
        );
      },
      (bookings) {
        state = state.copyWith(
          status: BookingStatus.loaded,
          bookings: bookings,
        );
      },
    );
  }

  /// Optionally select a single booking
  void selectBooking(BookingEntity booking) {
    state = state.copyWith(selectedBooking: booking);
  }
}
