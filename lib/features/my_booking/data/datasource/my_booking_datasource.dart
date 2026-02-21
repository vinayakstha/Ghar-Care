import 'package:ghar_care/features/my_booking/data/model/my_booking_api_model.dart';

abstract interface class IMyBookingRemoteDataSource {
  Future<List<MyBookingApiModel?>> getAllBookingsByUser();
}
