import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ghar_care/core/services/hive/hive_service.dart';
import 'package:ghar_care/features/my_booking/data/datasource/my_booking_datasource.dart';
import 'package:ghar_care/features/my_booking/data/model/my_booking_hive_model.dart';

final myBookingLocalDatasourceProvider = Provider<MyBookingLocalDatasource>((
  ref,
) {
  final hiveService = ref.read(hiveServiceProvider);
  return MyBookingLocalDatasource(hiveService: hiveService);
});

class MyBookingLocalDatasource implements IMyBookingLocalDataSource {
  final HiveService _hiveService;

  MyBookingLocalDatasource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<List<MyBookingHiveModel?>> getAllBookingsByUser() async {
    try {
      final bookings = await _hiveService.getAllBookings();
      return bookings;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> cacheAllBookings(List<MyBookingHiveModel> models) async {
    try {
      if (models.isEmpty) return;
      await _hiveService.cacheAllBookings(models, models.first.userId);
    } catch (e) {
      return;
    }
  }
}
