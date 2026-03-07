import 'package:dartz/dartz.dart';
import 'package:ghar_care/core/error/failures.dart';
import 'package:ghar_care/features/booking/domain/entities/booking_entity.dart';

abstract interface class IBookingRepository {
  Future<Either<Failure, BookingEntity>> createBooking(BookingEntity booking);
  Future<Either<Failure, List<BookingEntity>>> getBookingsByUser();
  Future<Either<Failure, bool>> deleteBooking(String bookingId);
}
