import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String userId;
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String phoneNumber;
  final String role;
  final String? profilePicture;

  const UserEntity({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.role,
    this.profilePicture,
  });

  @override
  List<Object?> get props => [
    userId,
    firstName,
    lastName,
    username,
    email,
    phoneNumber,
    role,
    profilePicture,
  ];
}
