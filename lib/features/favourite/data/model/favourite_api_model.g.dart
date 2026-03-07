// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favourite_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FavouriteApiModel _$FavouriteApiModelFromJson(Map<String, dynamic> json) =>
    FavouriteApiModel(
      favouriteId: json['_id'] as String?,
      userId: json['userId'] as String,
      serviceId:
          ServiceApiModel.fromJson(json['serviceId'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FavouriteApiModelToJson(FavouriteApiModel instance) =>
    <String, dynamic>{
      '_id': instance.favouriteId,
      'userId': instance.userId,
      'serviceId': FavouriteApiModel._serviceToJson(instance.serviceId),
    };
