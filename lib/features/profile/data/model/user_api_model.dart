import 'package:ghar_care/features/profile/domain/entities/user_entity.dart';

class UserApiModel {
  final String userId;
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String phoneNumber;
  final String role;
  final String? profilePicture;

  UserApiModel({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.role,
    this.profilePicture,
  });

  // fromJson
  factory UserApiModel.fromJson(Map<String, dynamic> json) {
    return UserApiModel(
      userId: json['_id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      role: json['role'] as String,
      profilePicture: json['profilePicture'] as String?,
    );
  }

  // toJson
  Map<String, dynamic> toJson() {
    return {
      '_id': userId,
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'email': email,
      'phoneNumber': phoneNumber,
      'role': role,
      'profilePicture': profilePicture,
    };
  }

  // toEntity
  UserEntity toEntity() {
    return UserEntity(
      userId: userId,
      firstName: firstName,
      lastName: lastName,
      username: username,
      email: email,
      phoneNumber: phoneNumber,
      role: role,
      profilePicture: profilePicture,
    );
  }

  // fromEntity
  factory UserApiModel.fromEntity(UserEntity entity) {
    return UserApiModel(
      userId: entity.userId,
      firstName: entity.firstName,
      lastName: entity.lastName,
      username: entity.username,
      email: entity.email,
      phoneNumber: entity.phoneNumber,
      role: entity.role,
      profilePicture: entity.profilePicture,
    );
  }

  // toEntityList
  static List<UserEntity> toEntityList(List<UserApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
