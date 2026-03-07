import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ghar_care/core/error/failures.dart';
import 'package:ghar_care/core/services/connectivity/network_info.dart';
import 'package:ghar_care/features/my_booking/data/datasource/local/my_booking_local_datasource.dart';
import 'package:ghar_care/features/my_booking/data/datasource/my_booking_datasource.dart';
import 'package:ghar_care/features/my_booking/data/datasource/remote/my_booking_remote_datasource.dart';
import 'package:ghar_care/features/my_booking/data/model/my_booking_api_model.dart';
import 'package:ghar_care/features/my_booking/data/model/my_booking_hive_model.dart';
import 'package:ghar_care/features/my_booking/domain/entities/my_booking_entity.dart';
import 'package:ghar_care/features/my_booking/domain/repository/my_booking_repository.dart';

final myBookingRepositoryProvider = Provider<IMyBookingRepository>((ref) {
  final remoteDataSource = ref.read(myBookingRemoteDataSourceProvider);
  final localDataSource = ref.read(myBookingLocalDatasourceProvider);
  final networkInfo = ref.read(networkInfoProvider);

  return MyBookingRepository(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
    networkInfo: networkInfo,
  );
});

class MyBookingRepository implements IMyBookingRepository {
  final IMyBookingRemoteDataSource _remoteDataSource;
  final IMyBookingLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  MyBookingRepository({
    required IMyBookingRemoteDataSource remoteDataSource,
    required IMyBookingLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource,
       _networkInfo = networkInfo;

  Future<Either<Failure, List<MyBookingEntity>>> _getCachedBookings() async {
    try {
      final localModels = await _localDataSource.getAllBookingsByUser();
      final nonNullModels = localModels
          .whereType<MyBookingHiveModel>()
          .toList()
          .reversed
          .toList();
      return Right(MyBookingHiveModel.toEntityList(nonNullModels));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MyBookingEntity>>> getBookingsByUser() async {
    if (await _networkInfo.isConnected) {
      try {
        final List<MyBookingApiModel?> results = await _remoteDataSource
            .getAllBookingsByUser();

        final nonNullModels = results.whereType<MyBookingApiModel>().toList();

        // Cache to local
        final hiveModels = nonNullModels
            .map((model) => MyBookingHiveModel.fromApiModel(model))
            .toList();
        await _localDataSource.cacheAllBookings(hiveModels);

        final bookings = nonNullModels.map((e) => e.toEntity()).toList();
        return Right(bookings);
      } catch (e) {
        return await _getCachedBookings();
      }
    } else {
      return await _getCachedBookings();
    }
  }
}
