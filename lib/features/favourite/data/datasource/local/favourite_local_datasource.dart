import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ghar_care/core/services/hive/hive_service.dart';
import 'package:ghar_care/features/favourite/data/datasource/favourite_datasource.dart';
import 'package:ghar_care/features/favourite/data/model/favourite_hive_model.dart';

final favouriteLocalDatasourceProvider = Provider<FavouriteLocalDatasource>((
  ref,
) {
  final hiveService = ref.read(hiveServiceProvider);
  return FavouriteLocalDatasource(hiveService: hiveService);
});

class FavouriteLocalDatasource implements IFavouriteLocalDataSource {
  final HiveService _hiveService;

  FavouriteLocalDatasource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<List<FavouriteHiveModel?>> getFavouritesByUser() async {
    try {
      final favourites = await _hiveService.getAllFavourites();
      return favourites;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> cacheAllBookings(List<FavouriteHiveModel> models) async {
    try {
      if (models.isEmpty) return;

      await _hiveService.cacheAllFavourites(models, models.first.userId);
    } catch (e) {
      return;
    }
  }
}
