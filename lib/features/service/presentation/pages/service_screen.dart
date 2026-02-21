import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ghar_care/features/service/presentation/view_model/service_view_model.dart';
import 'package:ghar_care/features/service/presentation/state/service_state.dart';
import 'package:ghar_care/features/service/presentation/widgets/service_card.dart';
import 'package:ghar_care/features/booking/presentation/pages/booking_screen.dart';

class ServiceScreen extends ConsumerStatefulWidget {
  final String categoryId;
  final String categoryName;

  const ServiceScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  ConsumerState<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends ConsumerState<ServiceScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref
          .read(serviceViewModelProvider.notifier)
          .getServicesByCategory(widget.categoryId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final serviceState = ref.watch(serviceViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: Text(widget.categoryName)),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Builder(
          builder: (_) {
            if (serviceState.status == ServiceStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (serviceState.status == ServiceStatus.error) {
              return Center(
                child: Text(
                  serviceState.errorMessage ?? "Something went wrong",
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            if (serviceState.services.isEmpty) {
              return const Center(child: Text("No services available."));
            }

            return ListView.separated(
              itemCount: serviceState.services.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final service = serviceState.services[index];

                return ServiceCard(
                  imageUrl: "http://192.168.18.3:5050${service.serviceImage}",
                  serviceName: service.serviceName,
                  price: "Rs. ${service.price}",
                  onCardTap: () {
                    // Save selected service in state
                    ref
                        .read(serviceViewModelProvider.notifier)
                        .selectService(service);

                    // Navigate to BookingScreen - only pass serviceId
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BookingScreen(
                          serviceId: service.serviceId ?? "", // or service._id
                        ),
                      ),
                    );
                  },
                  onFavorite: () {
                    // Add favorite logic here
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
