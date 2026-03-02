import 'package:ghar_care/features/favourite/data/model/favourite_api_model.dart';
import 'package:ghar_care/features/favourite/data/model/favourite_hive_model.dart';

abstract class IFavouriteRemoteDataSource {
  Future<bool> createFavourite(String serviceId);

  Future<bool> deleteFavourite(String favouriteId);

  Future<List<FavouriteApiModel?>> getFavouritesByUser();
}

abstract class IFavouriteLocalDataSource {
  Future<List<FavouriteHiveModel?>> getFavouritesByUser();
  Future<void> cacheAllBookings(List<FavouriteHiveModel> models);
}
