import 'package:equatable/equatable.dart';
import 'package:ghar_care/features/favourite/domain/entities/favourite_entity.dart';

enum FavouriteStatus { initial, loading, loaded, error }

class FavouriteState extends Equatable {
  final FavouriteStatus status;
  final List<FavouriteEntity> favourites;
  final FavouriteEntity? selectedFavourite;
  final String? errorMessage;

  const FavouriteState({
    this.status = FavouriteStatus.initial,
    this.favourites = const [],
    this.selectedFavourite,
    this.errorMessage,
  });

  FavouriteState copyWith({
    FavouriteStatus? status,
    List<FavouriteEntity>? favourites,
    FavouriteEntity? selectedFavourite,
    String? errorMessage,
  }) {
    return FavouriteState(
      status: status ?? this.status,
      favourites: favourites ?? this.favourites,
      selectedFavourite: selectedFavourite ?? this.selectedFavourite,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    favourites,
    selectedFavourite,
    errorMessage,
  ];
}
