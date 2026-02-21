// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceApiModel _$ServiceApiModelFromJson(Map<String, dynamic> json) =>
    ServiceApiModel(
      id: json['_id'] as String?,
      serviceName: json['serviceName'] as String,
      serviceImage: json['serviceImage'] as String,
      serviceDescription: json['serviceDescription'] as String,
      categoryId: json['categoryId']['_id'] as String,
      price: json['price'] as String,
    );

Map<String, dynamic> _$ServiceApiModelToJson(ServiceApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'serviceName': instance.serviceName,
      'serviceImage': instance.serviceImage,
      'serviceDescription': instance.serviceDescription,
      'categoryId': instance.categoryId,
      'price': instance.price,
    };
