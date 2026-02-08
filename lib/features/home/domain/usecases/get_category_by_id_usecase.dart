import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ghar_care/core/error/failures.dart';
import 'package:ghar_care/core/usecase/app_usecase.dart';
import 'package:ghar_care/features/home/domain/repository/category_repository.dart';

class GetCategoryByIdUsecaseParams extends Equatable {
  final String id;
  const GetCategoryByIdUsecaseParams({required this.id});

  @override
  List<Object?> get props => [id];
}

class GetCategoryByIdUsecase implements UsecaseWithParams {
  final ICategoryRepository _categoryRepository;
  GetCategoryByIdUsecase({required ICategoryRepository categoryRepository})
    : _categoryRepository = categoryRepository;
  @override
  Future<Either<Failure, dynamic>> call(params) {
    final typedParams = params as GetCategoryByIdUsecaseParams;
    return _categoryRepository.getCategoryById(typedParams.id);
  }
}
