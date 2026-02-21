import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ghar_care/core/error/failures.dart';
import 'package:ghar_care/core/usecase/app_usecase.dart';
import 'package:ghar_care/features/booking/data/repository/booking_repository.dart';
import 'package:ghar_care/features/booking/domain/entities/booking_entity.dart';
import 'package:ghar_care/features/booking/domain/repository/booking_repository.dart';

/// Provider for the usecase
final getBookingsByUserUsecaseProvider = Provider<GetBookingsByUserUsecase>((
  ref,
) {
  final bookingRepository = ref.read(bookingRepositoryProvider);
  return GetBookingsByUserUsecase(bookingRepository: bookingRepository);
});

/// Usecase class
class GetBookingsByUserUsecase
    implements UsecaseWithoutParams<List<BookingEntity>> {
  final IBookingRepository _bookingRepository;

  GetBookingsByUserUsecase({required IBookingRepository bookingRepository})
    : _bookingRepository = bookingRepository;

  @override
  Future<Either<Failure, List<BookingEntity>>> call() {
    return _bookingRepository.getBookingsByUser();
  }
}
