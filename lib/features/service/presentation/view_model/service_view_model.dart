import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ghar_care/features/service/domain/usercases/get_service_by_id_usecase.dart';
import 'package:ghar_care/features/service/domain/usercases/get_services_by_category_usecase.dart';
import 'package:ghar_care/features/service/presentation/state/service_state.dart';

final serviceViewModelProvider =
    NotifierProvider<ServiceViewModel, ServiceState>(() => ServiceViewModel());

class ServiceViewModel extends Notifier<ServiceState> {
  late final GetServicesByCategoryUsecase _getServicesByCategoryUsecase;
  late final GetServiceByIdUsecase _getServiceByIdUsecase;

  @override
  ServiceState build() {
    _getServicesByCategoryUsecase = ref.read(
      getServicesByCategoryUsecaseProvider,
    );
    _getServiceByIdUsecase = ref.read(getServiceByIdUsecaseProvider);
    return const ServiceState();
  }

  //Get Services by Category
  Future<void> getServicesByCategory(String categoryId) async {
    state = state.copyWith(status: ServiceStatus.loading);

    final result = await _getServicesByCategoryUsecase(
      GetServicesByCategoryUsecaseParams(id: categoryId),
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          status: ServiceStatus.error,
          errorMessage: failure.message,
        );
      },
      (services) {
        state = state.copyWith(
          status: ServiceStatus.loaded,
          services: services,
        );
      },
    );
  }

  Future<void> getServiceById(String serviceId) async {
    state = state.copyWith(status: ServiceStatus.loading);

    final result = await _getServiceByIdUsecase(
      GetServiceByIdUsecaseParams(id: serviceId),
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          status: ServiceStatus.error,
          errorMessage: failure.message,
        );
      },
      (service) {
        state = state.copyWith(
          status: ServiceStatus.loaded,
          selectedService: service,
        );
      },
    );
  }

  //Optionally, select a single service
  void selectService(service) {
    state = state.copyWith(selectedService: service);
  }
}
