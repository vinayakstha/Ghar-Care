import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ghar_care/core/error/failures.dart';
import 'package:ghar_care/core/usecase/app_usecase.dart';
import 'package:ghar_care/features/favourite/data/repository/favourite_repository.dart';
import 'package:ghar_care/features/favourite/domain/entities/favourite_entity.dart';
import 'package:ghar_care/features/favourite/domain/repository/favourite_repository.dart';

/// Provider for the usecase
final getFavouritesByUserUsecaseProvider = Provider<GetFavouritesByUserUsecase>(
  (ref) {
    final favouriteRepository = ref.read(favouriteRepositoryProvider);
    return GetFavouritesByUserUsecase(favouriteRepository: favouriteRepository);
  },
);

/// Usecase class
class GetFavouritesByUserUsecase
    implements UsecaseWithoutParams<List<FavouriteEntity>> {
  final IFavouriteRepository _favouriteRepository;

  GetFavouritesByUserUsecase({
    required IFavouriteRepository favouriteRepository,
  }) : _favouriteRepository = favouriteRepository;

  @override
  Future<Either<Failure, List<FavouriteEntity>>> call() {
    return _favouriteRepository.getFavouritesByUser();
  }
}
