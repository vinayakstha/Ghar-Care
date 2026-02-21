import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ghar_care/features/my_booking/presentation/state/my_booking_state.dart';
import 'package:ghar_care/features/my_booking/presentation/view_model/my_booking_view_model.dart';
import 'package:ghar_care/features/my_booking/presentation/widgets/MyBookingCard.dart';

class MyBookingScreen extends ConsumerStatefulWidget {
  const MyBookingScreen({super.key});

  @override
  ConsumerState<MyBookingScreen> createState() => _MyBookingScreenState();
}

class _MyBookingScreenState extends ConsumerState<MyBookingScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch bookings when screen loads
    Future.microtask(
      () => ref.read(myBookingViewModelProvider.notifier).getBookingsByUser(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(myBookingViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Bookings'), centerTitle: true),
      body: state.status == MyBookingStatus.loading
          ? const Center(child: CircularProgressIndicator())
          : state.status == MyBookingStatus.error
          ? Center(
              child: Text(
                state.errorMessage ?? 'Something went wrong',
                style: const TextStyle(fontSize: 16),
              ),
            )
          : state.bookings.isEmpty
          ? const Center(
              child: Text('No bookings found', style: TextStyle(fontSize: 16)),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: state.bookings.length,
              itemBuilder: (context, index) {
                final booking = state.bookings[index];
                return MyBookingCard(
                  booking: booking,
                  onTap: () {
                    // Optional: select booking in ViewModel
                    ref
                        .read(myBookingViewModelProvider.notifier)
                        .selectBooking(booking);

                    // Navigate to detail screen if you have one
                    // Navigator.push(context, MaterialPageRoute(
                    //   builder: (_) => BookingDetailScreen(booking: booking)
                    // ));
                  },
                );
              },
            ),
    );
  }
}
