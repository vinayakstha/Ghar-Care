import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ghar_care/core/error/failures.dart';
import 'package:ghar_care/core/usecase/app_usecase.dart';
import 'package:ghar_care/features/favourite/data/repository/favourite_repository.dart';
import 'package:ghar_care/features/favourite/domain/repository/favourite_repository.dart';

/// Params for creating a favourite
class CreateFavouriteUsecaseParams extends Equatable {
  final String serviceId;

  const CreateFavouriteUsecaseParams({required this.serviceId});

  @override
  List<Object?> get props => [serviceId];
}

/// Provider for the usecase
final createFavouriteUsecaseProvider = Provider<CreateFavouriteUsecase>((ref) {
  final favouriteRepository = ref.read(favouriteRepositoryProvider);
  return CreateFavouriteUsecase(favouriteRepository: favouriteRepository);
});

/// Usecase class
class CreateFavouriteUsecase
    implements UsecaseWithParams<bool, CreateFavouriteUsecaseParams> {
  final IFavouriteRepository _favouriteRepository;

  CreateFavouriteUsecase({required IFavouriteRepository favouriteRepository})
    : _favouriteRepository = favouriteRepository;

  @override
  Future<Either<Failure, bool>> call(CreateFavouriteUsecaseParams params) {
    return _favouriteRepository.createFavourite(params.serviceId);
  }
}
