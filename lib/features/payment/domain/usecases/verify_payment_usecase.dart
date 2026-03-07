import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ghar_care/core/error/failures.dart';
import 'package:ghar_care/core/usecase/app_usecase.dart';
import 'package:ghar_care/features/payment/data/repository/payment.repository.dart';
import 'package:ghar_care/features/payment/domain/repository/payment_repository.dart';

class VerifyPaymentParams extends Equatable {
  final String pidx;

  const VerifyPaymentParams({required this.pidx});

  @override
  List<Object?> get props => [pidx];
}

final verifyPaymentUsecaseProvider = Provider<VerifyPaymentUsecase>((ref) {
  return VerifyPaymentUsecase(
    paymentRepository: ref.read(paymentRepositoryProvider),
  );
});

class VerifyPaymentUsecase
    implements UsecaseWithParams<bool, VerifyPaymentParams> {
  final IPaymentRepository _paymentRepository;

  VerifyPaymentUsecase({required IPaymentRepository paymentRepository})
    : _paymentRepository = paymentRepository;

  @override
  Future<Either<Failure, bool>> call(VerifyPaymentParams params) {
    return _paymentRepository.verifyPayment(params.pidx);
  }
}
