import 'package:ghar_care/features/favourite/domain/entities/favourite_entity.dart';
import 'package:ghar_care/features/service/data/model/service_api_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'favourite_api_model.g.dart';

@JsonSerializable()
class FavouriteApiModel {
  @JsonKey(name: "_id")
  final String? favouriteId;

  final String userId;

  @JsonKey(fromJson: ServiceApiModel.fromJson, toJson: _serviceToJson)
  final ServiceApiModel serviceId;

  FavouriteApiModel({
    this.favouriteId,
    required this.userId,
    required this.serviceId,
  });

  /// JSON -> API Model
  factory FavouriteApiModel.fromJson(Map<String, dynamic> json) =>
      _$FavouriteApiModelFromJson(json);

  /// API Model -> JSON
  Map<String, dynamic> toJson() => _$FavouriteApiModelToJson(this);

  /// API Model -> Entity
  FavouriteEntity toEntity() {
    return FavouriteEntity(
      favouriteId: favouriteId,
      userId: userId,
      service: serviceId.toEntity(),
    );
  }

  /// List converter
  static List<FavouriteEntity> toEntityList(List<FavouriteApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }

  /// Convert ServiceApiModel back to JSON
  static Map<String, dynamic> _serviceToJson(ServiceApiModel service) =>
      service.toJson();
}
