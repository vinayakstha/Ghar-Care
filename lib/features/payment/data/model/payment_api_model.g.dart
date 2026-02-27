// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentApiModel _$PaymentApiModelFromJson(Map<String, dynamic> json) =>
    PaymentApiModel(
      success: json['success'] as bool?,
      pidx: json['pidx'] as String?,
      paymentUrl: json['payment_url'] as String?,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$PaymentApiModelToJson(PaymentApiModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'pidx': instance.pidx,
      'payment_url': instance.paymentUrl,
      'message': instance.message,
    };
