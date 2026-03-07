import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ghar_care/features/payment/domain/entities/payment_entity.dart';

part 'payment_api_model.g.dart';

@JsonSerializable()
class PaymentApiModel {
  final bool? success;
  final String? pidx;
  @JsonKey(name: 'payment_url')
  final String? paymentUrl;
  final String? message;

  PaymentApiModel({this.success, this.pidx, this.paymentUrl, this.message});

  factory PaymentApiModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentApiModelToJson(this);

  // Convert to Entity
  PaymentEntity toEntity() {
    return PaymentEntity(
      success: success,
      pidx: pidx,
      paymentUrl: paymentUrl,
      message: message,
    );
  }

  // Create from Entity
  factory PaymentApiModel.fromEntity(PaymentEntity entity) {
    return PaymentApiModel(
      success: entity.success,
      pidx: entity.pidx,
      paymentUrl: entity.paymentUrl,
      message: entity.message,
    );
  }
}
