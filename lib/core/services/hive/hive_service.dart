import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ghar_care/core/constants/hive_table_constant.dart';
import 'package:ghar_care/features/auth/data/models/auth_hive_model.dart';
import 'package:ghar_care/features/category/data/model/category_hive_model.dart';
import 'package:ghar_care/features/favourite/data/model/favourite_hive_model.dart';
import 'package:ghar_care/features/my_booking/data/model/my_booking_hive_model.dart';
import 'package:ghar_care/features/service/data/model/service_hive_model.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

final hiveServiceProvider = Provider<HiveService>((ref) {
  return HiveService();
});

class HiveService {
  //init
  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/${HiveTableConstant.dbName}';
    Hive.init(path);
    _registerAdapter();
    await openBoxes();
  }

  //register adapter
  void _registerAdapter() {
    if (!Hive.isAdapterRegistered(HiveTableConstant.authTypeId)) {
      Hive.registerAdapter(AuthHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(HiveTableConstant.categoryTypeId)) {
      Hive.registerAdapter(CategoryHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(HiveTableConstant.serviceTypeId)) {
      Hive.registerAdapter(ServiceHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(HiveTableConstant.myBookingTypeId)) {
      Hive.registerAdapter(MyBookingHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(HiveTableConstant.favouriteTypeId)) {
      Hive.registerAdapter(FavouriteHiveModelAdapter());
    }
  }

  //open boxes
  Future<void> openBoxes() async {
    await Hive.openBox<AuthHiveModel>(HiveTableConstant.authTable);
    await Hive.openBox<CategoryHiveModel>(HiveTableConstant.categoryTable);
    await Hive.openBox<ServiceHiveModel>(HiveTableConstant.serviceTable);
    await Hive.openBox<MyBookingHiveModel>(HiveTableConstant.myBookingTable);
    await Hive.openBox<FavouriteHiveModel>(HiveTableConstant.favouriteTable);
  }

  //close boxes
  Future<void> closeBoxes() async {
    await Hive.close();
  }

  //queries
  //============== AUTH QUERIES ================
  Box<AuthHiveModel> get _authBox =>
      Hive.box<AuthHiveModel>(HiveTableConstant.authTable);

  Future<AuthHiveModel> registerUser(AuthHiveModel model) async {
    await _authBox.put(model.authId, model);
    return model;
  }

  Future<AuthHiveModel?> login(String email, String password) async {
    final users = _authBox.values.where(
      (user) => user.email == email && user.password == password,
    );
    if (users.isNotEmpty) {
      return users.first;
    }
    return null;
  }

  Future<void> logoutUser() async {}

  AuthHiveModel? getCurrentUser(String authId) {
    return _authBox.get(authId);
  }

  bool isEmailExists(String email) {
    final users = _authBox.values.where((user) => user.email == email);
    return users.isNotEmpty;
  }

  //================ CATEGORY QUERIES =================
  Box<CategoryHiveModel> get _categoryBox =>
      Hive.box<CategoryHiveModel>(HiveTableConstant.categoryTable);

  Future<void> addCategory(CategoryHiveModel model) async {
    await _categoryBox.put(model.categoryId, model);
  }

  Future<void> updateCategory(CategoryHiveModel model) async {
    await _categoryBox.put(model.categoryId, model);
  }

  Future<void> deleteCategory(String id) async {
    await _categoryBox.delete(id);
  }

  Future<CategoryHiveModel?> getCategoryById(String id) async {
    return _categoryBox.get(id);
  }

  Future<List<CategoryHiveModel>> getAllCategories() async {
    return _categoryBox.values.toList();
  }

  Future<void> cacheAllCategories(List<CategoryHiveModel> categories) async {
    await _categoryBox.clear();
    await _categoryBox.putAll({
      for (var category in categories) category.categoryId: category,
    });
  }

  //================ SERVICE QUERIES =================
  Box<ServiceHiveModel> get _serviceBox =>
      Hive.box<ServiceHiveModel>(HiveTableConstant.serviceTable);

  Future<void> addService(ServiceHiveModel model) async {
    await _serviceBox.put(model.serviceId, model);
  }

  Future<void> updateService(ServiceHiveModel model) async {
    await _serviceBox.put(model.serviceId, model);
  }

  Future<void> deleteService(String id) async {
    await _serviceBox.delete(id);
  }

  Future<ServiceHiveModel?> getServiceById(String id) async {
    return _serviceBox.get(id);
  }

  Future<List<ServiceHiveModel>> getAllServices() async {
    return _serviceBox.values.toList();
  }

  Future<List<ServiceHiveModel>> getServicesByCategoryId(
    String categoryId,
  ) async {
    final result = _serviceBox.values
        .where((service) => service.categoryId == categoryId)
        .toList();
    return result;
  }

  // Future<void> cacheAllServices(List<ServiceHiveModel> services) async {
  //   await _serviceBox.putAll({
  //     for (var service in services) service.serviceId: service,
  //   });
  // }

  Future<void> cacheAllServices(List<ServiceHiveModel> services) async {
    if (services.isEmpty) return;

    final categoryId = services.first.categoryId;

    final keysToDelete = _serviceBox.values
        .where((service) => service.categoryId == categoryId)
        .map((service) => service.serviceId)
        .toList();

    await _serviceBox.deleteAll(keysToDelete);

    await _serviceBox.putAll({
      for (var service in services) service.serviceId: service,
    });
  }

  //===================My Booking queries =============================
  Box<MyBookingHiveModel> get _myBookingBox =>
      Hive.box<MyBookingHiveModel>(HiveTableConstant.myBookingTable);

  Future<void> cacheAllBookings(
    List<MyBookingHiveModel> bookings,
    String userId,
  ) async {
    if (bookings.isEmpty) return;

    final keysToDelete = _myBookingBox.values
        .where((booking) => booking.userId == userId)
        .map((booking) => booking.bookingId)
        .toList();

    await _myBookingBox.deleteAll(keysToDelete);

    await _myBookingBox.putAll({
      for (var booking in bookings) booking.bookingId: booking,
    });
  }

  Future<MyBookingHiveModel?> getBookingById(String bookingId) async {
    return _myBookingBox.get(bookingId);
  }

  Future<List<MyBookingHiveModel>> getAllBookings() async {
    return _myBookingBox.values.toList();
  }

  Future<List<MyBookingHiveModel>> getBookingsByUserId(String userId) async {
    return _myBookingBox.values
        .where((booking) => booking.userId == userId)
        .toList();
  }

  //================ FAVOURITE QUERIES =================
  Box<FavouriteHiveModel> get _favouriteBox =>
      Hive.box<FavouriteHiveModel>(HiveTableConstant.favouriteTable);

  Future<void> cacheAllFavourites(
    List<FavouriteHiveModel> favourites,
    String userId,
  ) async {
    if (favourites.isEmpty) return;

    final keysToDelete = _favouriteBox.values
        .where((favourite) => favourite.userId == userId)
        .map((favourite) => favourite.favouriteId)
        .toList();

    await _favouriteBox.deleteAll(keysToDelete);

    await _favouriteBox.putAll({
      for (var favourite in favourites) favourite.favouriteId: favourite,
    });
  }

  Future<List<FavouriteHiveModel>> getAllFavouritesByUserId(
    String userId,
  ) async {
    return _favouriteBox.values
        .where((favourite) => favourite.userId == userId)
        .toList();
  }

  Future<List<FavouriteHiveModel>> getAllFavourites() async {
    return _favouriteBox.values.toList();
  }
}
