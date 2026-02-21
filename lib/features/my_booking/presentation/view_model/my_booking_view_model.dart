import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ghar_care/features/my_booking/domain/usecases/get_booking_by_user_usecase.dart';
import 'package:ghar_care/features/my_booking/domain/entities/my_booking_entity.dart';
import 'package:ghar_care/features/my_booking/presentation/state/my_booking_state.dart';

final myBookingViewModelProvider =
    NotifierProvider<MyBookingViewModel, MyBookingState>(
      () => MyBookingViewModel(),
    );

class MyBookingViewModel extends Notifier<MyBookingState> {
  late final GetMyBookingsByUserUsecase _getMyBookingsByUserUsecase;

  @override
  MyBookingState build() {
    _getMyBookingsByUserUsecase = ref.read(getMyBookingsByUserUsecaseProvider);
    return const MyBookingState();
  }

  /// Fetch all bookings for the current user
  Future<void> getBookingsByUser() async {
    state = state.copyWith(status: MyBookingStatus.loading);

    final result = await _getMyBookingsByUserUsecase();

    result.fold(
      (failure) {
        state = state.copyWith(
          status: MyBookingStatus.error,
          errorMessage: failure.message,
        );
      },
      (bookings) {
        state = state.copyWith(
          status: MyBookingStatus.loaded,
          bookings: bookings,
        );
      },
    );
  }

  /// Optionally select a single booking
  void selectBooking(MyBookingEntity booking) {
    state = state.copyWith(selectedBooking: booking);
  }
}
