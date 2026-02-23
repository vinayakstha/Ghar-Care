import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ghar_care/core/constants/hive_table_constant.dart';
import 'package:ghar_care/features/auth/data/models/auth_hive_model.dart';
import 'package:ghar_care/features/home/data/model/category_hive_model.dart';
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
  }

  //open boxes
  Future<void> openBoxes() async {
    await Hive.openBox<AuthHiveModel>(HiveTableConstant.authTable);
    await Hive.openBox<CategoryHiveModel>(HiveTableConstant.categoryTable);
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
}
