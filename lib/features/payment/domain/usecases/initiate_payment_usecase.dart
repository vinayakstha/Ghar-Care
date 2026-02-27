import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ghar_care/core/error/failures.dart';
import 'package:ghar_care/core/usecase/app_usecase.dart';
import 'package:ghar_care/features/payment/data/repository/payment.repository.dart';
import 'package:ghar_care/features/payment/domain/entities/payment_entity.dart';
import 'package:ghar_care/features/payment/domain/repository/payment_repository.dart';

class InitiatePaymentParams extends Equatable {
  final String bookingId;

  const InitiatePaymentParams({required this.bookingId});

  @override
  List<Object?> get props => [bookingId];
}

final initiatePaymentUsecaseProvider = Provider<InitiatePaymentUsecase>((ref) {
  return InitiatePaymentUsecase(
    paymentRepository: ref.read(paymentRepositoryProvider),
  );
});

class InitiatePaymentUsecase
    implements UsecaseWithParams<PaymentEntity, InitiatePaymentParams> {
  final IPaymentRepository _paymentRepository;

  InitiatePaymentUsecase({required IPaymentRepository paymentRepository})
    : _paymentRepository = paymentRepository;

  @override
  Future<Either<Failure, PaymentEntity>> call(InitiatePaymentParams params) {
    return _paymentRepository.initiatePayment(params.bookingId);
  }
}
