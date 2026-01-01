import 'package:ghar_care/core/constants/hive_table_constant.dart';
import 'package:ghar_care/features/auth/domain/entities/auth_entity.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'auth_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.authTypeId)
class AuthHiveModel extends HiveObject {
  @HiveField(0)
  final String? authId;

  @HiveField(1)
  final String firstName;

  @HiveField(2)
  final String lastName;

  @HiveField(3)
  final String username;

  @HiveField(4)
  final String email;

  @HiveField(5)
  final String phoneNumber;

  @HiveField(6)
  final String password;

  @HiveField(7)
  final String? profilePicture;

  AuthHiveModel({
    String? authId,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.password,
    this.profilePicture,
  }) : authId = authId ?? Uuid().v4();

  //from entity
  factory AuthHiveModel.fromEntity(AuthEntity entity) {
    return AuthHiveModel(
      authId: entity.authId,
      firstName: entity.firstName,
      lastName: entity.lastName,
      username: entity.username,
      email: entity.email,
      phoneNumber: entity.phoneNumber,
      password: entity.password,
      profilePicture: entity.profilePicture,
    );
  }

  //to entity
  AuthEntity toEntity() {
    return AuthEntity(
      firstName: firstName,
      lastName: lastName,
      username: username,
      email: email,
      phoneNumber: phoneNumber,
      password: password,
    );
  }

  static List<AuthEntity> toEntityList(List<AuthHiveModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
