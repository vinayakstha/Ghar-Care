// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_booking_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyBookingApiModel _$MyBookingApiModelFromJson(Map<String, dynamic> json) =>
    MyBookingApiModel(
      bookingId: json['_id'] as String?,
      userId: json['userId'] as String,
      serviceId:
          ServiceApiModel.fromJson(json['serviceId'] as Map<String, dynamic>),
      bookingDate: json['bookingDate'] as String,
      bookingTime: json['bookingTime'] as String,
      price: json['price'] as String,
      location: json['location'] as String,
      status: json['status'] as String?,
    );

Map<String, dynamic> _$MyBookingApiModelToJson(MyBookingApiModel instance) =>
    <String, dynamic>{
      '_id': instance.bookingId,
      'userId': instance.userId,
      'serviceId': MyBookingApiModel._serviceToJson(instance.serviceId),
      'bookingDate': instance.bookingDate,
      'bookingTime': instance.bookingTime,
      'price': instance.price,
      'location': instance.location,
      'status': instance.status,
    };
