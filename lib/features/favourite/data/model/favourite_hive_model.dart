import 'package:ghar_care/core/constants/hive_table_constant.dart';
import 'package:ghar_care/features/favourite/data/model/favourite_api_model.dart';
import 'package:ghar_care/features/favourite/domain/entities/favourite_entity.dart';
import 'package:ghar_care/features/service/domain/entities/service_entity.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'favourite_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.favouriteTypeId)
class FavouriteHiveModel extends HiveObject {
  @HiveField(0)
  final String favouriteId;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final String serviceId;

  @HiveField(3)
  final String serviceName;

  @HiveField(4)
  final String serviceImage;

  @HiveField(5)
  final String serviceDescription;

  @HiveField(6)
  final String serviceCategoryId;

  @HiveField(7)
  final String servicePrice;

  FavouriteHiveModel({
    String? favouriteId,
    required this.userId,
    required this.serviceId,
    required this.serviceName,
    required this.serviceImage,
    required this.serviceDescription,
    required this.serviceCategoryId,
    required this.servicePrice,
  }) : favouriteId = favouriteId ?? const Uuid().v4();

  /// Hive model -> Entity
  FavouriteEntity toEntity() {
    return FavouriteEntity(
      favouriteId: favouriteId,
      userId: userId,
      service: ServiceEntity(
        serviceId: serviceId,
        serviceName: serviceName,
        serviceImage: serviceImage,
        serviceDescription: serviceDescription,
        categoryId: serviceCategoryId,
        price: servicePrice,
      ),
    );
  }

  /// Entity -> Hive model
  factory FavouriteHiveModel.fromEntity(FavouriteEntity entity) {
    return FavouriteHiveModel(
      favouriteId: entity.favouriteId,
      userId: entity.userId,
      serviceId: entity.service.serviceId ?? '',
      serviceName: entity.service.serviceName,
      serviceImage: entity.service.serviceImage,
      serviceDescription: entity.service.serviceDescription,
      serviceCategoryId: entity.service.categoryId,
      servicePrice: entity.service.price,
    );
  }

  static List<FavouriteEntity> toEntityList(List<FavouriteHiveModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }

  /// API model -> Hive model
  factory FavouriteHiveModel.fromApiModel(FavouriteApiModel apiModel) {
    return FavouriteHiveModel(
      favouriteId: apiModel.favouriteId,
      userId: apiModel.userId,
      serviceId: apiModel.serviceId.id ?? '',
      serviceName: apiModel.serviceId.serviceName,
      serviceImage: apiModel.serviceId.serviceImage,
      serviceDescription: apiModel.serviceId.serviceDescription,
      serviceCategoryId: apiModel.serviceId.categoryId,
      servicePrice: apiModel.serviceId.price,
    );
  }

  static List<FavouriteHiveModel> fromApiModelList(
    List<FavouriteApiModel> apiModels,
  ) {
    return apiModels
        .map((model) => FavouriteHiveModel.fromApiModel(model))
        .toList();
  }
}
