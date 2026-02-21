import 'package:dartz/dartz.dart';
import 'package:ghar_care/core/error/failures.dart';
import 'package:ghar_care/features/my_booking/domain/entities/my_booking_entity.dart';

abstract interface class IMyBookingRepository {
  Future<Either<Failure, List<MyBookingEntity>>> getBookingsByUser();
}
