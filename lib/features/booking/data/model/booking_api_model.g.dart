// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingApiModel _$BookingApiModelFromJson(Map<String, dynamic> json) =>
    BookingApiModel(
      bookingId: json['_id'] as String?,
      userId: BookingApiModel._idFromJson(json['userId']),
      serviceId: BookingApiModel._idFromJson(json['serviceId']),
      bookingDate: json['bookingDate'] as String,
      bookingTime: json['bookingTime'] as String,
      price: json['price'] as String,
      location: json['location'] as String,
      status: json['status'] as String?,
    );

Map<String, dynamic> _$BookingApiModelToJson(BookingApiModel instance) =>
    <String, dynamic>{
      '_id': instance.bookingId,
      'userId': instance.userId,
      'serviceId': instance.serviceId,
      'bookingDate': instance.bookingDate,
      'bookingTime': instance.bookingTime,
      'price': instance.price,
      'location': instance.location,
      'status': instance.status,
    };
