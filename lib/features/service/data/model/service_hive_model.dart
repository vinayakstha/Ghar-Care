import 'package:ghar_care/core/constants/hive_table_constant.dart';
import 'package:ghar_care/features/service/data/model/service_api_model.dart';
import 'package:ghar_care/features/service/domain/entities/service_entity.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'service_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.serviceTypeId)
class ServiceHiveModel extends HiveObject {
  @HiveField(0)
  final String serviceId;

  @HiveField(1)
  final String serviceName;

  @HiveField(2)
  final String serviceImage;

  @HiveField(3)
  final String serviceDescription;

  @HiveField(4)
  final String categoryId;

  @HiveField(5)
  final String price;

  ServiceHiveModel({
    String? serviceId,
    required this.serviceName,
    required this.serviceImage,
    required this.serviceDescription,
    required this.categoryId,
    required this.price,
  }) : serviceId = serviceId ?? const Uuid().v4();

  ServiceEntity toEntity() {
    return ServiceEntity(
      serviceName: serviceName,
      serviceImage: serviceImage,
      serviceDescription: serviceDescription,
      categoryId: categoryId,
      price: price,
    );
  }

  factory ServiceHiveModel.fromEntity(ServiceEntity entity) {
    return ServiceHiveModel(
      serviceId: entity.serviceId,
      serviceName: entity.serviceName,
      serviceImage: entity.serviceImage,
      serviceDescription: entity.serviceDescription,
      categoryId: entity.categoryId,
      price: entity.price,
    );
  }

  static List<ServiceEntity> toEntityList(List<ServiceHiveModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }

  factory ServiceHiveModel.fromApiModel(ServiceApiModel apiModel) {
    return ServiceHiveModel(
      serviceId: apiModel.id,
      serviceName: apiModel.serviceName,
      serviceImage: apiModel.serviceImage,
      serviceDescription: apiModel.serviceDescription,
      categoryId: apiModel.categoryId,
      price: apiModel.price,
    );
  }

  static List<ServiceHiveModel> fromApiModelList(
    List<ServiceApiModel> apiModels,
  ) {
    return apiModels
        .map((model) => ServiceHiveModel.fromApiModel(model))
        .toList();
  }
}
