import 'package:equatable/equatable.dart';
import 'package:ghar_care/features/booking/domain/entities/booking_entity.dart';

enum BookingStatus { initial, loading, loaded, error }

class BookingState extends Equatable {
  final BookingStatus status;
  final List<BookingEntity> bookings;
  final BookingEntity? selectedBooking;
  final String? errorMessage;

  const BookingState({
    this.status = BookingStatus.initial,
    this.bookings = const [],
    this.selectedBooking,
    this.errorMessage,
  });

  BookingState copyWith({
    BookingStatus? status,
    List<BookingEntity>? bookings,
    BookingEntity? selectedBooking,
    String? errorMessage,
  }) {
    return BookingState(
      status: status ?? this.status,
      bookings: bookings ?? this.bookings,
      selectedBooking: selectedBooking ?? this.selectedBooking,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, bookings, selectedBooking, errorMessage];
}
