import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ghar_care/core/error/failures.dart';
import 'package:ghar_care/core/services/connectivity/network_info.dart';
import 'package:ghar_care/features/profile/data/datasource/remote/user_remote_datasource.dart';
import 'package:ghar_care/features/profile/data/datasource/user_datasource.dart';
import 'package:ghar_care/features/profile/domain/entities/user_entity.dart';
import 'package:ghar_care/features/profile/domain/repository/user_repository.dart';

/// Provider for UserRepository
final userRepositoryProvider = Provider<IUserRepository>((ref) {
  final userRemoteDatasource = ref.read(userRemoteDataSourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return UserRepository(
    userRemoteDatasource: userRemoteDatasource,
    networkInfo: networkInfo,
  );
});

class UserRepository implements IUserRepository {
  final IUserRemoteDatasource _userRemoteDatasource;
  final NetworkInfo _networkInfo;

  UserRepository({
    required IUserRemoteDatasource userRemoteDatasource,
    required NetworkInfo networkInfo,
  }) : _userRemoteDatasource = userRemoteDatasource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    if (await _networkInfo.isConnected) {
      try {
        final user = await _userRemoteDatasource.getCurrentUser();
        return Right(user);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return Left(ApiFailure(message: "No internet connection"));
    }
  }

  @override
  Future<Either<Failure, String>> uploadImage(File image) async {
    if (await _networkInfo.isConnected) {
      try {
        final fileName = await _userRemoteDatasource.uploadImage(image.path);
        return Right(fileName);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return Left(ApiFailure(message: "No internet connection"));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateProfile(
    UserEntity updatedUser, {
    File? image,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final user = await _userRemoteDatasource.updateProfile(
          updatedUser,
          image: image,
        );
        return Right(user);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return Left(ApiFailure(message: "No internet connection"));
    }
  }
}
