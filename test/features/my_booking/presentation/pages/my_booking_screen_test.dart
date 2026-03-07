import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ghar_care/features/my_booking/domain/entities/my_booking_entity.dart';
import 'package:ghar_care/features/my_booking/presentation/state/my_booking_state.dart';
import 'package:ghar_care/features/my_booking/presentation/view_model/my_booking_view_model.dart';
import 'package:ghar_care/features/my_booking/presentation/pages/my_booking_screen.dart';
import 'package:ghar_care/features/my_booking/presentation/widgets/MyBookingCard.dart';
import 'package:ghar_care/features/service/domain/entities/service_entity.dart';

class MockMyBookingViewModel extends MyBookingViewModel {
  final MyBookingState mockState;
  MockMyBookingViewModel(this.mockState) : super();

  @override
  MyBookingState build() => mockState;

  @override
  Future<void> getBookingsByUser() async {}

  @override
  void selectBooking(MyBookingEntity booking) {}
}

const tService = ServiceEntity(
  serviceId: 's1',
  serviceName: 'Pipe Repair',
  serviceImage: 'pipe.png',
  serviceDescription: 'Fix broken pipes',
  categoryId: 'c1',
  price: '800',
);

const tBooking = MyBookingEntity(
  bookingId: 'b1',
  userId: 'u1',
  service: tService,
  bookingDate: '2024-01-15',
  bookingTime: '10:00 AM',
  price: '800',
  location: 'Kathmandu',
  status: 'pending',
);

Widget makeTestableWidget(MyBookingState state) {
  return ProviderScope(
    overrides: [
      myBookingViewModelProvider.overrideWith(
        () => MockMyBookingViewModel(state),
      ),
    ],
    child: const MaterialApp(home: MyBookingScreen()),
  );
}

void main() {
  testWidgets('shows loading indicator when status is loading', (tester) async {
    await tester.pumpWidget(
      makeTestableWidget(const MyBookingState(status: MyBookingStatus.loading)),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows error message when status is error', (tester) async {
    await tester.pumpWidget(
      makeTestableWidget(
        const MyBookingState(
          status: MyBookingStatus.error,
          errorMessage: 'Failed to load bookings',
        ),
      ),
    );

    expect(find.text('Failed to load bookings'), findsOneWidget);
  });

  testWidgets('shows empty message when bookings list is empty', (
    tester,
  ) async {
    await tester.pumpWidget(
      makeTestableWidget(
        const MyBookingState(status: MyBookingStatus.loaded, bookings: []),
      ),
    );

    expect(find.text('No bookings found'), findsOneWidget);
  });

  testWidgets('shows booking cards when bookings are loaded', (tester) async {
    await tester.pumpWidget(
      makeTestableWidget(
        const MyBookingState(
          status: MyBookingStatus.loaded,
          bookings: [tBooking],
        ),
      ),
    );

    expect(find.byType(MyBookingCard), findsOneWidget);
  });

  testWidgets('shows correct appBar title', (tester) async {
    await tester.pumpWidget(
      makeTestableWidget(const MyBookingState(status: MyBookingStatus.initial)),
    );

    expect(find.text('My Bookings'), findsOneWidget);
  });
}
