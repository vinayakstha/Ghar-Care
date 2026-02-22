import 'package:equatable/equatable.dart';
import 'package:ghar_care/features/profile/domain/entities/user_entity.dart';

enum UserStatus { initial, loading, loaded, error, updated }

class UserState extends Equatable {
  final UserStatus status;
  final UserEntity? user;
  final String? errorMessage;
  final String? uploadPhotoName;

  const UserState({
    this.status = UserStatus.initial,
    this.user,
    this.errorMessage,
    this.uploadPhotoName,
  });

  // copyWith for immutability
  UserState copyWith({
    UserStatus? status,
    UserEntity? user,
    String? errorMessage,
    String? uploadPhotoName,
  }) {
    return UserState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
      uploadPhotoName: uploadPhotoName ?? this.uploadPhotoName,
    );
  }

  @override
  List<Object?> get props => [status, user, errorMessage, uploadPhotoName];
}
