import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ghar_care/core/error/failures.dart';
import 'package:ghar_care/core/usecase/app_usecase.dart';
import 'package:ghar_care/features/booking/data/repository/booking_repository.dart';
import 'package:ghar_care/features/booking/domain/repository/booking_repository.dart';

class DeleteBookingParams extends Equatable {
  final String bookingId;

  const DeleteBookingParams({required this.bookingId});

  @override
  List<Object?> get props => [bookingId];
}

final deleteBookingUsecaseProvider = Provider<DeleteBookingUsecase>((ref) {
  return DeleteBookingUsecase(
    bookingRepository: ref.read(bookingRepositoryProvider),
  );
});

class DeleteBookingUsecase
    implements UsecaseWithParams<bool, DeleteBookingParams> {
  final IBookingRepository _bookingRepository;

  DeleteBookingUsecase({required IBookingRepository bookingRepository})
    : _bookingRepository = bookingRepository;

  @override
  Future<Either<Failure, bool>> call(DeleteBookingParams params) {
    return _bookingRepository.deleteBooking(params.bookingId);
  }
}
