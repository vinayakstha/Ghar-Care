import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ghar_care/core/error/failures.dart';
import 'package:ghar_care/core/usecase/app_usecase.dart';
import 'package:ghar_care/features/my_booking/data/repository/my_booking_repository.dart';
import 'package:ghar_care/features/my_booking/domain/entities/my_booking_entity.dart';
import 'package:ghar_care/features/my_booking/domain/repository/my_booking_repository.dart';

/// Provider for the MyBooking usecase
final getMyBookingsByUserUsecaseProvider = Provider<GetMyBookingsByUserUsecase>(
  (ref) {
    final repository = ref.read(myBookingRepositoryProvider);
    return GetMyBookingsByUserUsecase(myBookingRepository: repository);
  },
);

/// Usecase class for fetching MyBookings
class GetMyBookingsByUserUsecase
    implements UsecaseWithoutParams<List<MyBookingEntity>> {
  final IMyBookingRepository _myBookingRepository;

  GetMyBookingsByUserUsecase({
    required IMyBookingRepository myBookingRepository,
  }) : _myBookingRepository = myBookingRepository;

  @override
  Future<Either<Failure, List<MyBookingEntity>>> call() {
    return _myBookingRepository.getBookingsByUser();
  }
}
