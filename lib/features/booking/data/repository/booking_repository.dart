import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ghar_care/core/error/failures.dart';
import 'package:ghar_care/core/services/connectivity/network_info.dart';
import 'package:ghar_care/features/booking/data/datasource/booking_datasource.dart';
import 'package:ghar_care/features/booking/data/datasource/remote/booking_remote_datasource.dart';
import 'package:ghar_care/features/booking/data/model/booking_api_model.dart';
import 'package:ghar_care/features/booking/domain/entities/booking_entity.dart';
import 'package:ghar_care/features/booking/domain/repository/booking_repository.dart';

final bookingRepositoryProvider = Provider<IBookingRepository>((ref) {
  final bookingRemoteDataSource = ref.read(bookingRemoteDataSourceProvider);
  final networkInfo = ref.read(networkInfoProvider);

  return BookingRepository(
    bookingRemoteDataSource: bookingRemoteDataSource,
    networkInfo: networkInfo,
  );
});

class BookingRepository implements IBookingRepository {
  final IBookingRemoteDataSource _bookingRemoteDataSource;
  final NetworkInfo _networkInfo;

  BookingRepository({
    required IBookingRemoteDataSource bookingRemoteDataSource,
    required NetworkInfo networkInfo,
  }) : _bookingRemoteDataSource = bookingRemoteDataSource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, BookingEntity>> createBooking(
    BookingEntity booking,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final BookingApiModel? result = await _bookingRemoteDataSource
            .createBooking(BookingApiModel.fromEntity(booking));

        if (result == null) {
          return Left(ApiFailure(message: "Failed to create booking"));
        }

        return Right(result.toEntity());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return Left(ApiFailure(message: "No internet connection"));
    }
  }

  @override
  Future<Either<Failure, List<BookingEntity>>> getBookingsByUser() async {
    if (await _networkInfo.isConnected) {
      try {
        final List<BookingApiModel?> results = await _bookingRemoteDataSource
            .getAllBookingsByUser();

        final bookings = results
            .whereType<BookingApiModel>()
            .map((e) => e.toEntity())
            .toList();

        return Right(bookings);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return Left(ApiFailure(message: "No internet connection"));
    }
  }
}
