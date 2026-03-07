// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryApiModel _$CategoryApiModelFromJson(Map<String, dynamic> json) =>
    CategoryApiModel(
      id: json['_id'] as String?,
      categoryName: json['categoryName'] as String,
      categoryImage: json['categoryImage'] as String,
    );

Map<String, dynamic> _$CategoryApiModelToJson(CategoryApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'categoryName': instance.categoryName,
      'categoryImage': instance.categoryImage,
    };
