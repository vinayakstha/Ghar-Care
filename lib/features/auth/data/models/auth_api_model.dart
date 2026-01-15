import 'package:ghar_care/features/auth/domain/entities/auth_entity.dart';

class AuthApiModel {
  final String? id;
  final String firstName;
  final String lastName;
  final String email;
  final String username;
  final String phoneNumber;
  final String password;
  final String? confirmPassword;
  final String? profilePicture;

  AuthApiModel({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.username,
    required this.phoneNumber,
    required this.password,
    this.confirmPassword,
    this.profilePicture,
  });

  //toJson
  Map<String, dynamic> toJson() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "username": username,
      "email": email,
      "phoneNumber": phoneNumber,
      "password": password,
      "confirmPassword": confirmPassword,
      "profilePicture": profilePicture,
    };
  }

  //fromJson
  factory AuthApiModel.fromJson(Map<String, dynamic> json) {
    return AuthApiModel(
      id: json['_id'] as String?,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      phoneNumber: json['phoneNumber'] as String,
      password: json['password'] as String,
      profilePicture: json['profilePicture'] as String?,
    );
  }

  //toEntity
  AuthEntity toEntity() {
    return AuthEntity(
      authId: id,
      firstName: firstName,
      lastName: lastName,
      username: username,
      email: email,
      phoneNumber: phoneNumber,
      password: password,
      profilePicture: profilePicture,
    );
  }

  //fromEntity
  factory AuthApiModel.fromEntity(AuthEntity entity) {
    return AuthApiModel(
      firstName: entity.firstName,
      lastName: entity.lastName,
      email: entity.email,
      username: entity.username,
      phoneNumber: entity.phoneNumber,
      password: entity.password,
      confirmPassword: entity.confirmPassword,
      profilePicture: entity.profilePicture,
    );
  }

  //toEntityList
  static List<AuthEntity> toEntityList(List<AuthApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
