import 'package:ghar_care/features/payment/data/model/payment_api_model.dart';

abstract interface class IPaymentRemoteDataSource {
  Future<PaymentApiModel?> initiatePayment(String bookingId);
  Future<Map<String, dynamic>> verifyPayment(String pidx);
}
