import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ghar_care/core/error/failures.dart';
import 'package:ghar_care/core/usecase/app_usecase.dart';
import 'package:ghar_care/features/favourite/data/repository/favourite_repository.dart';
import 'package:ghar_care/features/favourite/domain/repository/favourite_repository.dart';

/// Params for deleting a favourite
class DeleteFavouriteUsecaseParams extends Equatable {
  final String favouriteId;

  const DeleteFavouriteUsecaseParams({required this.favouriteId});

  @override
  List<Object?> get props => [favouriteId];
}

/// Provider for the usecase
final deleteFavouriteUsecaseProvider = Provider<DeleteFavouriteUsecase>((ref) {
  final favouriteRepository = ref.read(favouriteRepositoryProvider);
  return DeleteFavouriteUsecase(favouriteRepository: favouriteRepository);
});

/// Usecase class
class DeleteFavouriteUsecase
    implements UsecaseWithParams<bool, DeleteFavouriteUsecaseParams> {
  final IFavouriteRepository _favouriteRepository;

  DeleteFavouriteUsecase({required IFavouriteRepository favouriteRepository})
    : _favouriteRepository = favouriteRepository;

  @override
  Future<Either<Failure, bool>> call(DeleteFavouriteUsecaseParams params) {
    return _favouriteRepository.deleteFavourite(params.favouriteId);
  }
}
