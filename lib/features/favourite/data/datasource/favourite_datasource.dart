import 'package:ghar_care/features/favourite/data/model/favourite_api_model.dart';

abstract class IFavouriteRemoteDataSource {
  Future<bool> createFavourite(String serviceId);

  Future<bool> deleteFavourite(String favouriteId);

  Future<List<FavouriteApiModel?>> getFavouritesByUser();
}
