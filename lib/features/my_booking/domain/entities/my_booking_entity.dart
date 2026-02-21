import 'package:equatable/equatable.dart';
import 'package:ghar_care/features/service/domain/entities/service_entity.dart';

class MyBookingEntity extends Equatable {
  final String? bookingId;
  final String userId;
  final ServiceEntity service;
  final String bookingDate;
  final String bookingTime;
  final String price;
  final String location;
  final String? status;

  const MyBookingEntity({
    this.bookingId,
    required this.userId,
    required this.service,
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
    service,
    bookingDate,
    bookingTime,
    price,
    location,
    status,
  ];
}
