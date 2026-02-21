import 'package:equatable/equatable.dart';
import 'package:ghar_care/features/my_booking/domain/entities/my_booking_entity.dart';

enum MyBookingStatus { initial, loading, loaded, error }

class MyBookingState extends Equatable {
  final MyBookingStatus status;
  final List<MyBookingEntity> bookings;
  final MyBookingEntity? selectedBooking;
  final String? errorMessage;

  const MyBookingState({
    this.status = MyBookingStatus.initial,
    this.bookings = const [],
    this.selectedBooking,
    this.errorMessage,
  });

  MyBookingState copyWith({
    MyBookingStatus? status,
    List<MyBookingEntity>? bookings,
    MyBookingEntity? selectedBooking,
    String? errorMessage,
  }) {
    return MyBookingState(
      status: status ?? this.status,
      bookings: bookings ?? this.bookings,
      selectedBooking: selectedBooking ?? this.selectedBooking,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, bookings, selectedBooking, errorMessage];
}
