import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ghar_care/core/error/failures.dart';
import 'package:ghar_care/core/services/connectivity/network_info.dart';
import 'package:ghar_care/features/favourite/data/datasource/favourite_datasource.dart';
import 'package:ghar_care/features/favourite/data/datasource/remote/favourite_remote_datasource.dart';
import 'package:ghar_care/features/favourite/data/model/favourite_api_model.dart';
import 'package:ghar_care/features/favourite/domain/entities/favourite_entity.dart';
import 'package:ghar_care/features/favourite/domain/repository/favourite_repository.dart';

final favouriteRepositoryProvider = Provider<IFavouriteRepository>((ref) {
  final favouriteRemoteDataSource = ref.read(favouriteRemoteDataSourceProvider);
  final networkInfo = ref.read(networkInfoProvider);

  return FavouriteRepository(
    favouriteRemoteDataSource: favouriteRemoteDataSource,
    networkInfo: networkInfo,
  );
});

class FavouriteRepository implements IFavouriteRepository {
  final IFavouriteRemoteDataSource _favouriteRemoteDataSource;
  final NetworkInfo _networkInfo;

  FavouriteRepository({
    required IFavouriteRemoteDataSource favouriteRemoteDataSource,
    required NetworkInfo networkInfo,
  }) : _favouriteRemoteDataSource = favouriteRemoteDataSource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, bool>> createFavourite(String serviceId) async {
    if (await _networkInfo.isConnected) {
      try {
        final result = await _favouriteRemoteDataSource.createFavourite(
          serviceId,
        );

        return Right(result);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return Left(ApiFailure(message: "No internet connection"));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteFavourite(String favouriteId) async {
    if (await _networkInfo.isConnected) {
      try {
        final result = await _favouriteRemoteDataSource.deleteFavourite(
          favouriteId,
        );

        return Right(result);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return Left(ApiFailure(message: "No internet connection"));
    }
  }

  @override
  Future<Either<Failure, List<FavouriteEntity>>> getFavouritesByUser() async {
    if (await _networkInfo.isConnected) {
      try {
        final List<FavouriteApiModel?> results =
            await _favouriteRemoteDataSource.getFavouritesByUser();

        final favourites = results
            .whereType<FavouriteApiModel>()
            .map((e) => e.toEntity())
            .toList();

        return Right(favourites);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return Left(ApiFailure(message: "No internet connection"));
    }
  }
}
