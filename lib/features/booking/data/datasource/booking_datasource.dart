import 'package:ghar_care/features/booking/data/model/booking_api_model.dart';

abstract interface class IBookingRemoteDataSource {
  Future<BookingApiModel?> createBooking(BookingApiModel booking);
  Future<List<BookingApiModel?>> getAllBookingsByUser();
  Future<bool> deleteBooking(String bookingId);
}
