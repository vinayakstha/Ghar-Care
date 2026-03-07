import 'package:ghar_care/features/my_booking/data/model/my_booking_api_model.dart';
import 'package:ghar_care/features/my_booking/data/model/my_booking_hive_model.dart';

abstract interface class IMyBookingRemoteDataSource {
  Future<List<MyBookingApiModel?>> getAllBookingsByUser();
}

abstract interface class IMyBookingLocalDataSource {
  Future<List<MyBookingHiveModel?>> getAllBookingsByUser();
  Future<void> cacheAllBookings(List<MyBookingHiveModel> models);
}
