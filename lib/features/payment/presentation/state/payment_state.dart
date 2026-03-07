import 'package:equatable/equatable.dart';

enum PaymentStatus { initial, loading, success, failed }

class PaymentState extends Equatable {
  final PaymentStatus status;
  final String? paymentUrl;
  final String? errorMessage;

  const PaymentState({
    this.status = PaymentStatus.initial,
    this.paymentUrl,
    this.errorMessage,
  });

  PaymentState copyWith({
    PaymentStatus? status,
    String? paymentUrl,
    String? errorMessage,
  }) {
    return PaymentState(
      status: status ?? this.status,
      paymentUrl: paymentUrl ?? this.paymentUrl,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, paymentUrl, errorMessage];
}
