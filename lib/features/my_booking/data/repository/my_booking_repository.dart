import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ghar_care/core/error/failures.dart';
import 'package:ghar_care/core/services/connectivity/network_info.dart';
import 'package:ghar_care/features/my_booking/data/datasource/my_booking_datasource.dart';
import 'package:ghar_care/features/my_booking/data/datasource/remote/my_booking_remote_datasource.dart';
import 'package:ghar_care/features/my_booking/data/model/my_booking_api_model.dart';
import 'package:ghar_care/features/my_booking/domain/entities/my_booking_entity.dart';
import 'package:ghar_care/features/my_booking/domain/repository/my_booking_repository.dart';

final myBookingRepositoryProvider = Provider<IMyBookingRepository>((ref) {
  final remoteDataSource = ref.read(myBookingRemoteDataSourceProvider);
  final networkInfo = ref.read(networkInfoProvider);

  return MyBookingRepository(
    remoteDataSource: remoteDataSource,
    networkInfo: networkInfo,
  );
});

class MyBookingRepository implements IMyBookingRepository {
  final IMyBookingRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  MyBookingRepository({
    required IMyBookingRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, List<MyBookingEntity>>> getBookingsByUser() async {
    if (await _networkInfo.isConnected) {
      try {
        final List<MyBookingApiModel?> results = await _remoteDataSource
            .getAllBookingsByUser();

        // Convert API models to entities, ignoring nulls
        final bookings = results
            .whereType<MyBookingApiModel>()
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
