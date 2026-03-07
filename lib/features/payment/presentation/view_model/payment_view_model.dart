import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ghar_care/features/payment/domain/usecases/initiate_payment_usecase.dart';
import 'package:ghar_care/features/payment/domain/usecases/verify_payment_usecase.dart';
import 'package:ghar_care/features/payment/presentation/state/payment_state.dart';

final paymentViewModelProvider =
    NotifierProvider<PaymentViewModel, PaymentState>(() => PaymentViewModel());

class PaymentViewModel extends Notifier<PaymentState> {
  late final InitiatePaymentUsecase _initiatePaymentUsecase;
  late final VerifyPaymentUsecase _verifyPaymentUsecase;

  @override
  PaymentState build() {
    _initiatePaymentUsecase = ref.read(initiatePaymentUsecaseProvider);
    _verifyPaymentUsecase = ref.read(verifyPaymentUsecaseProvider);
    return const PaymentState();
  }

  Future<String?> initiatePayment(String bookingId) async {
    state = state.copyWith(status: PaymentStatus.loading);

    final result = await _initiatePaymentUsecase(
      InitiatePaymentParams(bookingId: bookingId),
    );

    return result.fold(
      (failure) {
        state = state.copyWith(
          status: PaymentStatus.failed,
          errorMessage: failure.message,
        );
        return null;
      },
      (paymentEntity) {
        state = state.copyWith(
          status: PaymentStatus.success,
          paymentUrl: paymentEntity.paymentUrl,
        );
        return paymentEntity.paymentUrl;
      },
    );
  }

  Future<bool> verifyPayment(String pidx) async {
    state = state.copyWith(status: PaymentStatus.loading);

    final result = await _verifyPaymentUsecase(
      VerifyPaymentParams(pidx: pidx), // ← params class
    );

    return result.fold(
      (failure) {
        state = state.copyWith(
          status: PaymentStatus.failed,
          errorMessage: failure.message,
        );
        return false;
      },
      (success) {
        state = state.copyWith(status: PaymentStatus.success);
        return success;
      },
    );
  }
}
