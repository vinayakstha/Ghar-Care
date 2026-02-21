import 'package:equatable/equatable.dart';
import 'package:ghar_care/features/service/domain/entities/service_entity.dart';

enum ServiceStatus { initial, loading, loaded, error }

class ServiceState extends Equatable {
  final ServiceStatus status;
  final List<ServiceEntity> services;
  final ServiceEntity? selectedService;
  final String? errorMessage;

  const ServiceState({
    this.status = ServiceStatus.initial,
    this.services = const [],
    this.selectedService,
    this.errorMessage,
  });

  ServiceState copyWith({
    ServiceStatus? status,
    List<ServiceEntity>? services,
    ServiceEntity? selectedService,
    String? errorMessage,
  }) {
    return ServiceState(
      status: status ?? this.status,
      services: services ?? this.services,
      selectedService: selectedService ?? this.selectedService,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, services, selectedService, errorMessage];
}
