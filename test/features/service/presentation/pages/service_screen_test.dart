import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ghar_care/features/favourite/presentation/state/favourite_state.dart';
import 'package:ghar_care/features/favourite/presentation/view_model/favourite_view_model.dart';
import 'package:ghar_care/features/service/domain/entities/service_entity.dart';
import 'package:ghar_care/features/service/presentation/pages/service_screen.dart';
import 'package:ghar_care/features/service/presentation/state/service_state.dart';
import 'package:ghar_care/features/service/presentation/view_model/service_view_model.dart';
import 'package:ghar_care/features/service/presentation/widgets/service_card.dart';

class MockServiceViewModel extends ServiceViewModel {
  final ServiceState mockState;
  MockServiceViewModel(this.mockState) : super();

  @override
  ServiceState build() => mockState;

  @override
  Future<void> getServicesByCategory(String categoryId) async {}

  @override
  void selectService(service) {}
}

class MockFavouriteViewModel extends FavouriteViewModel {
  final FavouriteState mockState;
  MockFavouriteViewModel(this.mockState) : super();

  @override
  FavouriteState build() => mockState;

  @override
  Future<void> getFavouritesByUser() async {}

  @override
  Future<void> createFavourite({required String serviceId}) async {}

  @override
  Future<void> deleteFavourite({required String favouriteId}) async {}
}

const tService = ServiceEntity(
  serviceId: 's1',
  serviceName: 'Pipe Repair',
  serviceImage: 'pipe.png',
  serviceDescription: 'Fix broken pipes',
  categoryId: 'c1',
  price: '800',
);

Widget makeTestableWidget({
  required ServiceState serviceState,
  FavouriteState? favouriteState,
}) {
  return ProviderScope(
    overrides: [
      serviceViewModelProvider.overrideWith(
        () => MockServiceViewModel(serviceState),
      ),
      favouriteViewModelProvider.overrideWith(
        () => MockFavouriteViewModel(favouriteState ?? const FavouriteState()),
      ),
    ],
    child: const MaterialApp(
      home: ServiceScreen(categoryId: 'c1', categoryName: 'Plumbing'),
    ),
  );
}

void main() {
  testWidgets('shows loading indicator when status is loading', (tester) async {
    await tester.pumpWidget(
      makeTestableWidget(
        serviceState: const ServiceState(status: ServiceStatus.loading),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows error message when status is error', (tester) async {
    await tester.pumpWidget(
      makeTestableWidget(
        serviceState: const ServiceState(
          status: ServiceStatus.error,
          errorMessage: 'Failed to load services',
        ),
      ),
    );

    expect(find.text('Failed to load services'), findsOneWidget);
  });

  testWidgets('shows empty message when services list is empty', (
    tester,
  ) async {
    await tester.pumpWidget(
      makeTestableWidget(
        serviceState: const ServiceState(
          status: ServiceStatus.loaded,
          services: [],
        ),
      ),
    );

    expect(find.text('No services available.'), findsOneWidget);
  });

  testWidgets('shows service cards when services are loaded', (tester) async {
    await tester.pumpWidget(
      makeTestableWidget(
        serviceState: const ServiceState(
          status: ServiceStatus.loaded,
          services: [tService],
        ),
      ),
    );

    expect(find.byType(ServiceCard), findsOneWidget);
    expect(find.text('Pipe Repair'), findsOneWidget);
  });

  testWidgets('shows correct appBar title', (tester) async {
    await tester.pumpWidget(
      makeTestableWidget(
        serviceState: const ServiceState(status: ServiceStatus.initial),
      ),
    );

    expect(find.text('Plumbing'), findsOneWidget);
  });
}
