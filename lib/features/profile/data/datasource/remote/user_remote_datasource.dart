import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ghar_care/core/api/api_client.dart';
import 'package:ghar_care/core/api/api_endpoints.dart';
import 'package:ghar_care/core/services/storage/token_service.dart';
import 'package:ghar_care/features/profile/data/datasource/user_datasource.dart';
import 'package:ghar_care/features/profile/data/model/user_api_model.dart';
import 'package:ghar_care/features/profile/domain/entities/user_entity.dart';

final userRemoteDataSourceProvider = Provider<IUserRemoteDatasource>((ref) {
  return UserRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
    tokenService: ref.read(tokenServiceProvider),
  );
});

class UserRemoteDatasource implements IUserRemoteDatasource {
  final ApiClient _apiClient;
  final TokenService _tokenService;

  UserRemoteDatasource({
    required ApiClient apiClient,
    required TokenService tokenService,
  }) : _apiClient = apiClient,
       _tokenService = tokenService;

  @override
  Future<UserEntity> getCurrentUser() async {
    final response = await _apiClient.get(ApiEndpoints.getCurrentUser);
    if (response.data == null) {
      throw Exception("No user data found");
    }
    final user = UserApiModel.fromJson(response.data).toEntity();
    return user;
  }

  @override
  Future<String> uploadImage(String filePath) async {
    final file = File(filePath);
    final fileName = file.path.split('/').last;

    final formData = FormData.fromMap({
      "profilePicture": await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      ),
    });

    final token = _tokenService.getToken();
    final response = await _apiClient.updateFile(
      ApiEndpoints.updateProfile,
      formData: formData,
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );

    return response.data['data'] as String;
  }

  @override
  Future<UserEntity> updateProfile(
    UserEntity updatedUser, {
    File? image,
  }) async {
    final token = _tokenService.getToken();

    // Build FormData
    final formDataMap = {
      "firstName": updatedUser.firstName,
      "lastName": updatedUser.lastName,
      "username": updatedUser.username,
      "email": updatedUser.email,
      "phoneNumber": updatedUser.phoneNumber,
    };

    // If user wants to update profile image
    if (image != null) {
      final fileName = image.path.split('/').last;
      formDataMap["profilePicture"] =
          (await MultipartFile.fromFile(image.path, filename: fileName))
              as String;
    }

    final formData = FormData.fromMap(formDataMap);

    final response = await _apiClient.updateFile(
      ApiEndpoints.updateProfile,
      formData: formData,
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );

    final user = UserApiModel.fromJson(response.data['data']).toEntity();
    return user;
  }
}
