import 'package:equatable/equatable.dart';

class BookingEntity extends Equatable {
  final String? bookingId;
  final String userId;
  final String serviceId;
  final String bookingDate;
  final String bookingTime;
  final String price;
  final String location;
  final String? status;

  const BookingEntity({
    this.bookingId,
    required this.userId,
    required this.serviceId,
    required this.bookingDate,
    required this.bookingTime,
    required this.price,
    required this.location,
    this.status,
  });
  @override
  List<Object?> get props => [
    bookingId,
    userId,
    serviceId,
    bookingDate,
    bookingTime,
    price,
    location,
  ];
}
