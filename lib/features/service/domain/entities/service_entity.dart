import 'package:equatable/equatable.dart';

class ServiceEntity extends Equatable {
  final String? serviceId;
  final String serviceName;
  final String serviceDescription;
  final String categoryId;
  final String price;

  const ServiceEntity({
    this.serviceId,
    required this.serviceName,
    required this.serviceDescription,
    required this.categoryId,
    required this.price,
  });
  @override
  List<Object?> get props => [
    serviceId,
    serviceName,
    serviceDescription,
    categoryId,
    price,
  ];
}
