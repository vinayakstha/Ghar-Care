import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ghar_care/core/error/failures.dart';
import 'package:ghar_care/core/usecase/app_usecase.dart';
import 'package:ghar_care/features/booking/data/repository/booking_repository.dart';
import 'package:ghar_care/features/booking/domain/entities/booking_entity.dart';
import 'package:ghar_care/features/booking/domain/repository/booking_repository.dart';

/// Params for creating a booking
class CreateBookingUsecaseParams extends Equatable {
  final String serviceId;
  final String bookingDate;
  final String bookingTime;
  final String price;
  final String location;

  const CreateBookingUsecaseParams({
    required this.serviceId,
    required this.bookingDate,
    required this.bookingTime,
    required this.price,
    required this.location,
  });

  @override
  List<Object?> get props => [
    serviceId,
    bookingDate,
    bookingTime,
    price,
    location,
  ];
}

/// Provider for the usecase
final createBookingUsecaseProvider = Provider<CreateBookingUsecase>((ref) {
  final bookingRepository = ref.read(bookingRepositoryProvider);
  return CreateBookingUsecase(bookingRepository: bookingRepository);
});

/// Usecase class
class CreateBookingUsecase
    implements UsecaseWithParams<BookingEntity, CreateBookingUsecaseParams> {
  final IBookingRepository _bookingRepository;

  CreateBookingUsecase({required IBookingRepository bookingRepository})
    : _bookingRepository = bookingRepository;

  @override
  Future<Either<Failure, BookingEntity>> call(
    CreateBookingUsecaseParams params,
  ) {
    final booking = BookingEntity(
      userId: '', // backend will use token, so you can leave empty
      serviceId: params.serviceId,
      bookingDate: params.bookingDate,
      bookingTime: params.bookingTime,
      price: params.price,
      location: params.location,
    );

    return _bookingRepository.createBooking(booking);
  }
}
