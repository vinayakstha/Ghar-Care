import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ghar_care/features/favourite/domain/entities/favourite_entity.dart';
import 'package:ghar_care/features/favourite/domain/usecases/create_favourite_usecase.dart';
import 'package:ghar_care/features/favourite/domain/usecases/delete_favourite_usecase.dart';
import 'package:ghar_care/features/favourite/domain/usecases/get_favourites_by_user_usecase.dart';
import 'package:ghar_care/features/favourite/presentation/state/favourite_state.dart';

final favouriteViewModelProvider =
    NotifierProvider<FavouriteViewModel, FavouriteState>(
      () => FavouriteViewModel(),
    );

class FavouriteViewModel extends Notifier<FavouriteState> {
  late final CreateFavouriteUsecase _createFavouriteUsecase;
  late final DeleteFavouriteUsecase _deleteFavouriteUsecase;
  late final GetFavouritesByUserUsecase _getFavouritesByUserUsecase;

  @override
  FavouriteState build() {
    _createFavouriteUsecase = ref.read(createFavouriteUsecaseProvider);
    _deleteFavouriteUsecase = ref.read(deleteFavouriteUsecaseProvider);
    _getFavouritesByUserUsecase = ref.read(getFavouritesByUserUsecaseProvider);

    return const FavouriteState();
  }

  /// Create favourite
  Future<void> createFavourite({required String serviceId}) async {
    state = state.copyWith(status: FavouriteStatus.loading);

    final result = await _createFavouriteUsecase(
      CreateFavouriteUsecaseParams(serviceId: serviceId),
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          status: FavouriteStatus.error,
          errorMessage: failure.message,
        );
      },
      (success) async {
        if (success) {
          // Refresh favourites after successful creation
          await getFavouritesByUser();
        }
      },
    );
  }

  /// Delete favourite
  Future<void> deleteFavourite({required String favouriteId}) async {
    state = state.copyWith(status: FavouriteStatus.loading);

    final result = await _deleteFavouriteUsecase(
      DeleteFavouriteUsecaseParams(favouriteId: favouriteId),
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          status: FavouriteStatus.error,
          errorMessage: failure.message,
        );
      },
      (success) async {
        if (success) {
          // Refresh favourites after deletion
          await getFavouritesByUser();
        }
      },
    );
  }

  /// Get favourites by user
  Future<void> getFavouritesByUser() async {
    state = state.copyWith(status: FavouriteStatus.loading);

    final result = await _getFavouritesByUserUsecase();

    result.fold(
      (failure) {
        state = state.copyWith(
          status: FavouriteStatus.error,
          errorMessage: failure.message,
        );
      },
      (favourites) {
        state = state.copyWith(
          status: FavouriteStatus.loaded,
          favourites: favourites,
        );
      },
    );
  }

  /// Optionally select a favourite
  void selectFavourite(FavouriteEntity favourite) {
    state = state.copyWith(selectedFavourite: favourite);
  }
}
