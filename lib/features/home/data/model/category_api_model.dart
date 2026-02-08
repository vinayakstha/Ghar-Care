import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ghar_care/features/home/domain/entities/category_entity.dart';

part 'category_api_model.g.dart';

@JsonSerializable()
class CategoryApiModel {
  @JsonKey(name: "_id")
  final String? id;
  final String categoryName;
  final String categoryImage;

  CategoryApiModel({
    this.id,
    required this.categoryName,
    required this.categoryImage,
  });

  factory CategoryApiModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryApiModelToJson(this);

  //toEntity
  CategoryEntity toEntity() {
    return CategoryEntity(
      categoryId: id,
      categoryName: categoryName,
      categoryImage: categoryImage,
    );
  }

  //fromEntity
  factory CategoryApiModel.fromEntity(CategoryEntity entity) {
    return CategoryApiModel(
      categoryName: entity.categoryName,
      categoryImage: entity.categoryImage,
    );
  }

  //toEntityList
  static List<CategoryEntity> toEntityList(List<CategoryApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
