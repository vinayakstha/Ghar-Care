import 'package:dartz/dartz.dart';
import 'package:ghar_care/core/error/failures.dart';
import 'package:ghar_care/features/favourite/domain/entities/favourite_entity.dart';

abstract interface class IFavouriteRepository {
  Future<Either<Failure, bool>> createFavourite(String serviceId);

  Future<Either<Failure, bool>> deleteFavourite(String favouriteId);

  Future<Either<Failure, List<FavouriteEntity>>> getFavouritesByUser();
}
