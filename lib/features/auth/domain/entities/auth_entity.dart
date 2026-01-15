import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String? authId;
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String phoneNumber;
  final String password;
  final String? confirmPassword;
  final String? profilePicture;

  const AuthEntity({
    this.authId,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.password,
    this.confirmPassword,
    this.profilePicture,
  });

  @override
  List<Object?> get props => [
    authId,
    firstName,
    lastName,
    username,
    email,
    phoneNumber,
    password,
    confirmPassword,
    profilePicture,
  ];
}
