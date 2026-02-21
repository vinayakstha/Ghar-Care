import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ghar_care/core/api/api_client.dart';
import 'package:ghar_care/core/api/api_endpoints.dart';
import 'package:ghar_care/features/my_booking/data/datasource/my_booking_datasource.dart';
import 'package:ghar_care/features/my_booking/data/model/my_booking_api_model.dart';

final myBookingRemoteDataSourceProvider = Provider<IMyBookingRemoteDataSource>((
  ref,
) {
  return MyBookingRemoteDatasource(apiClient: ref.read(apiClientProvider));
});

class MyBookingRemoteDatasource implements IMyBookingRemoteDataSource {
  final ApiClient _apiClient;

  MyBookingRemoteDatasource({required ApiClient apiClient})
    : _apiClient = apiClient;

  /// Fetch all bookings for the current user
  @override
  Future<List<MyBookingApiModel?>> getAllBookingsByUser() async {
    final response = await _apiClient.get(ApiEndpoints.getBookingsByUser);

    if (response.data == null) return [];

    final Map<String, dynamic> resMap = response.data as Map<String, dynamic>;
    final List<dynamic> data = resMap['data'] as List<dynamic>? ?? [];

    return data
        .map((json) => MyBookingApiModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
