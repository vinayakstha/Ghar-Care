import 'package:equatable/equatable.dart';

class PaymentEntity extends Equatable {
  final bool? success;
  final String? pidx;
  final String? paymentUrl;
  final String? message;

  const PaymentEntity({this.success, this.pidx, this.paymentUrl, this.message});

  @override
  List<Object?> get props => [success, pidx, paymentUrl, message];
}
