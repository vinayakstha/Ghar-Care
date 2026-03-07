import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ghar_care/core/api/api_client.dart';
import 'package:ghar_care/core/api/api_endpoints.dart';
import 'package:ghar_care/features/booking/data/datasource/booking_datasource.dart';
import 'package:ghar_care/features/booking/data/model/booking_api_model.dart';

final bookingRemoteDataSourceProvider = Provider<IBookingRemoteDataSource>((
  ref,
) {
  return BookingRemoteDatasource(apiClient: ref.read(apiClientProvider));
});

class BookingRemoteDatasource implements IBookingRemoteDataSource {
  final ApiClient _apiClient;

  BookingRemoteDatasource({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  Future<BookingApiModel?> createBooking(BookingApiModel booking) async {
    final response = await _apiClient.post(
      ApiEndpoints.createBooking,
      data: booking.toJson(),
    );

    if (response.data == null) return null;

    final Map<String, dynamic> resMap = response.data as Map<String, dynamic>;

    // Adjust the key to match your actual API response structure
    final Map<String, dynamic> data = resMap['data'] as Map<String, dynamic>;

    return BookingApiModel.fromJson(data);
  }

  @override
  Future<List<BookingApiModel?>> getAllBookingsByUser() async {
    final response = await _apiClient.get(ApiEndpoints.getBookingsByUser);

    if (response.data == null) return [];

    final Map<String, dynamic> resMap = response.data as Map<String, dynamic>;
    final List<dynamic> data = resMap['data'] as List<dynamic>? ?? [];

    return data
        .map((json) => BookingApiModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<bool> deleteBooking(String bookingId) async {
    final response = await _apiClient.delete(
      ApiEndpoints.deleteBooking(bookingId),
    );

    if (response.data == null) return false;

    final Map<String, dynamic> resMap = response.data as Map<String, dynamic>;
    return resMap['success'] == true;
  }
}
