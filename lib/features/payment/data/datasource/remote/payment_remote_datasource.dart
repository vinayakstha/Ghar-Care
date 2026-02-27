import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ghar_care/core/api/api_client.dart';
import 'package:ghar_care/core/api/api_endpoints.dart';
import 'package:ghar_care/features/payment/data/datasource/payment_datasource.dart';
import 'package:ghar_care/features/payment/data/model/payment_api_model.dart';

final paymentRemoteDataSourceProvider = Provider<IPaymentRemoteDataSource>((
  ref,
) {
  return PaymentRemoteDataSource(apiClient: ref.read(apiClientProvider));
});

class PaymentRemoteDataSource implements IPaymentRemoteDataSource {
  final ApiClient _apiClient;

  PaymentRemoteDataSource({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  Future<PaymentApiModel?> initiatePayment(String bookingId) async {
    final response = await _apiClient.post(
      ApiEndpoints.initiatePayment,
      data: {'bookingId': bookingId},
    );

    if (response.data == null) return null;

    final Map<String, dynamic> resMap = response.data as Map<String, dynamic>;
    return PaymentApiModel.fromJson(resMap);
  }

  @override
  Future<Map<String, dynamic>> verifyPayment(String pidx) async {
    final response = await _apiClient.post(
      ApiEndpoints.verifyPayment,
      data: {'pidx': pidx},
    );

    if (response.data == null) return {};
    return response.data as Map<String, dynamic>;
  }
}
