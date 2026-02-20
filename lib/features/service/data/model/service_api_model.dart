import 'package:ghar_care/features/service/domain/entities/service_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'service_api_model.g.dart';

@JsonSerializable()
class ServiceApiModel {
  @JsonKey(name: "_id")
  final String? id;
  final String serviceName;
  final String serviceDescription;
  final String categoryId;
  final String price;

  ServiceApiModel({
    this.id,
    required this.serviceName,
    required this.serviceDescription,
    required this.categoryId,
    required this.price,
  });

  factory ServiceApiModel.fromJson(Map<String, dynamic> json) =>
      _$ServiceApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceApiModelToJson(this);

  ServiceEntity toEntity() {
    return ServiceEntity(
      serviceId: id,
      serviceName: serviceName,
      serviceDescription: serviceDescription,
      categoryId: categoryId,
      price: price,
    );
  }

  factory ServiceApiModel.fromEntity(ServiceEntity entity) {
    return ServiceApiModel(
      serviceName: entity.serviceName,
      serviceDescription: entity.serviceDescription,
      categoryId: entity.categoryId,
      price: entity.price,
    );
  }

  static List<ServiceEntity?> toEntityList(List<ServiceApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
