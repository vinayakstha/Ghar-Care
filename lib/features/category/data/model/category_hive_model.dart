import 'package:ghar_care/core/constants/hive_table_constant.dart';
import 'package:ghar_care/features/category/data/model/category_api_model.dart';
import 'package:ghar_care/features/category/domain/entities/category_entity.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'category_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.categoryTypeId)
class CategoryHiveModel extends HiveObject {
  @HiveField(0)
  final String categoryId;

  @HiveField(1)
  final String categoryName;

  @HiveField(2)
  final String categoryImage;

  CategoryHiveModel({
    String? categoryId,
    required this.categoryName,
    required this.categoryImage,
  }) : categoryId = categoryId ?? const Uuid().v4();

  CategoryEntity toEntity() {
    return CategoryEntity(
      categoryName: categoryName,
      categoryImage: categoryImage,
    );
  }

  factory CategoryHiveModel.fromEntity(CategoryEntity entity) {
    return CategoryHiveModel(
      categoryId: entity.categoryId,
      categoryName: entity.categoryName,
      categoryImage: entity.categoryImage,
    );
  }

  static List<CategoryEntity> toEntityList(List<CategoryHiveModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }

  factory CategoryHiveModel.fromApiModel(CategoryApiModel apiModel) {
    return CategoryHiveModel(
      categoryId: apiModel.id,
      categoryName: apiModel.categoryName,
      categoryImage: apiModel.categoryImage,
    );
  }

  static List<CategoryHiveModel> fromApiModelList(
    List<CategoryApiModel> apiModels,
  ) {
    return apiModels
        .map((model) => CategoryHiveModel.fromApiModel(model))
        .toList();
  }
}
