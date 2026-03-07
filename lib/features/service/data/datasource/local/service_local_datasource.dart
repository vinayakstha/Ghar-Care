import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ghar_care/core/services/hive/hive_service.dart';
import 'package:ghar_care/features/service/data/datasource/service_datasource.dart';
import 'package:ghar_care/features/service/data/model/service_hive_model.dart';

// Provider
final serviceLocalDatasourceProvider = Provider<ServiceLocalDatasource>((ref) {
  final hiveService = ref.read(hiveServiceProvider);
  return ServiceLocalDatasource(hiveService: hiveService);
});

class ServiceLocalDatasource implements IServiceLocalDataSource {
  final HiveService _hiveService;

  ServiceLocalDatasource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<bool> addService(ServiceHiveModel model) async {
    try {
      await _hiveService.addService(model);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<ServiceHiveModel?> getServiceById(String serviceId) async {
    try {
      final service = await _hiveService.getServiceById(serviceId);
      return service;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<ServiceHiveModel?>> getAllServices() async {
    try {
      final services = await _hiveService.getAllServices();
      return services;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<bool> updateService(ServiceHiveModel model) async {
    try {
      await _hiveService.updateService(model);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteService(String serviceId) async {
    try {
      await _hiveService.deleteService(serviceId);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> cacheAllServices(List<ServiceHiveModel> services) async {
    await _hiveService.cacheAllServices(services);
  }

  @override
  Future<List<ServiceHiveModel?>> getServicesByCategoryId(
    String categoryId,
  ) async {
    try {
      final services = await _hiveService.getServicesByCategoryId(categoryId);
      return services;
    } catch (e) {
      return [];
    }
  }
}
