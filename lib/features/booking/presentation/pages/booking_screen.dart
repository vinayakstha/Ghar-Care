// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:ghar_care/core/api/api_endpoints.dart';
// import 'package:ghar_care/core/widgets/my_button.dart';
// import 'package:ghar_care/core/utils/snackbar_utils.dart';
// import 'package:ghar_care/features/booking/presentation/state/booking_state.dart';
// import 'package:ghar_care/features/booking/presentation/view_model/booking_view_model.dart';
// import 'package:ghar_care/features/service/presentation/view_model/service_view_model.dart';
// import 'package:ghar_care/features/booking/presentation/widgets/location_picker_widget.dart';

// class BookingScreen extends ConsumerStatefulWidget {
//   final String serviceId;

//   const BookingScreen({super.key, required this.serviceId});

//   @override
//   ConsumerState<BookingScreen> createState() => _BookingScreenState();
// }

// class _BookingScreenState extends ConsumerState<BookingScreen> {
//   String? selectedDate;
//   String? selectedTime;
//   bool showFullDescription = false;

//   final List<String> timeSlots = [
//     "9:00AM - 10:00AM",
//     "10:00AM - 11:00AM",
//     "11:00AM - 12:00PM",
//     "12:00PM - 1:00PM",
//     "1:00PM - 2:00PM",
//     "2:00PM - 3:00PM",
//     "3:00PM - 4:00PM",
//     "4:00PM - 5:00PM",
//     "5:00PM - 6:00PM",
//   ];

//   String? _locationString;

//   Future<void> _pickDate() async {
//     final picked = await showDatePicker(
//       context: context,
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2030),
//       initialDate: DateTime.now(),
//     );

//     if (picked != null) {
//       setState(() {
//         selectedDate = "${picked.year}-${picked.month}-${picked.day}";
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final serviceState = ref.watch(serviceViewModelProvider);
//     final bookingState = ref.watch(bookingViewModelProvider);

//     final service = serviceState.selectedService;

//     if (service == null) {
//       return const Scaffold(body: Center(child: Text("Service not selected")));
//     }

//     final descriptionText =
//         showFullDescription || service.serviceDescription.length <= 150
//         ? service.serviceDescription
//         : "${service.serviceDescription.substring(0, 150)}...";

//     return Scaffold(
//       appBar: AppBar(title: Text(service.serviceName)),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Service Image
//             ClipRRect(
//               borderRadius: BorderRadius.circular(16),
//               child: Image.network(
//                 "${ApiEndpoints.imageBaseUrl}${service.serviceImage}",
//                 height: 170,
//                 width: double.infinity,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             const SizedBox(height: 20),

//             // Service Name
//             Text(
//               service.serviceName,
//               style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),

//             // Price
//             Text("Rs. ${service.price}", style: const TextStyle(fontSize: 18)),
//             const SizedBox(height: 16),

//             // Description
//             Text(
//               descriptionText,
//               textAlign: TextAlign.justify,
//               style: const TextStyle(fontSize: 15),
//             ),
//             if (service.serviceDescription.length > 150)
//               GestureDetector(
//                 onTap: () {
//                   setState(() {
//                     showFullDescription = !showFullDescription;
//                   });
//                 },
//                 child: Text(
//                   showFullDescription ? "See Less" : "See More",
//                   style: const TextStyle(
//                     color: Color(0xFF006BAA),
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),

//             const SizedBox(height: 30),
//             const Divider(),
//             const SizedBox(height: 20),

//             const Text(
//               "Book This Service",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 20),

//             // Location Picker
//             // _buildLocationPicker(),
//             LocationPickerWidget(
//               onLocationPicked: (location) {
//                 setState(() {
//                   _locationString = location;
//                 });
//               },
//             ),
//             const SizedBox(height: 16),

//             // Date Picker
//             GestureDetector(
//               onTap: _pickDate,
//               child: Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 12,
//                   vertical: 16,
//                 ),
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.grey),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: [
//                         const Icon(Icons.calendar_today),
//                         const SizedBox(width: 8),
//                         Text(selectedDate ?? "Select Date"),
//                       ],
//                     ),
//                     const Icon(Icons.arrow_drop_down),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),

//             // Time Dropdown
//             DropdownButtonFormField<String>(
//               value: selectedTime,
//               decoration: InputDecoration(
//                 labelText: "Select Time",
//                 prefixIcon: const Icon(Icons.access_time),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               items: timeSlots
//                   .map(
//                     (time) => DropdownMenuItem(value: time, child: Text(time)),
//                   )
//                   .toList(),
//               onChanged: (value) {
//                 setState(() {
//                   selectedTime = value;
//                 });
//               },
//             ),
//             const SizedBox(height: 30),

//             // Book Now Button
//             bookingState.status == BookingStatus.loading
//                 ? const Center(child: CircularProgressIndicator())
//                 : MyButton(
//                     text: "Book Now",
//                     onPressed: () async {
//                       // final messenger = ScaffoldMessenger.of(context);
//                       final navigator = Navigator.of(context);

//                       if (selectedDate == null || selectedTime == null) {
//                         SnackbarUtils.showWarning(
//                           context,
//                           "Please select date and time",
//                         );
//                         return;
//                       }

//                       if (_locationString == null || _locationString!.isEmpty) {
//                         SnackbarUtils.showWarning(
//                           context,
//                           "Please select location",
//                         );
//                         return;
//                       }

//                       await ref
//                           .read(bookingViewModelProvider.notifier)
//                           .createBooking(
//                             serviceId: service.serviceId ?? "",
//                             bookingDate: selectedDate!,
//                             bookingTime: selectedTime!,
//                             price: service.price,
//                             location: _locationString!,
//                           );

//                       if (!mounted) return;

//                       final currentState = ref.read(bookingViewModelProvider);

//                       if (currentState.status == BookingStatus.loaded) {
//                         SnackbarUtils.showSuccess(
//                           context,
//                           "Booking successful!",
//                         );
//                         navigator.pop();
//                       } else if (currentState.status == BookingStatus.error) {
//                         SnackbarUtils.showError(
//                           context,
//                           currentState.errorMessage ?? "Booking failed",
//                         );
//                       }
//                     },
//                   ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ghar_care/core/api/api_endpoints.dart';
import 'package:ghar_care/core/widgets/my_button.dart';
import 'package:ghar_care/core/utils/snackbar_utils.dart';
import 'package:ghar_care/features/booking/presentation/state/booking_state.dart';
import 'package:ghar_care/features/booking/presentation/view_model/booking_view_model.dart';
import 'package:ghar_care/features/payment/presentation/pages/payment_webview_screen.dart';
import 'package:ghar_care/features/service/presentation/view_model/service_view_model.dart';
import 'package:ghar_care/features/booking/presentation/widgets/location_picker_widget.dart';
import 'package:ghar_care/features/payment/presentation/state/payment_state.dart';
import 'package:ghar_care/features/payment/presentation/view_model/payment_view_model.dart';

class BookingScreen extends ConsumerStatefulWidget {
  final String serviceId;

  const BookingScreen({super.key, required this.serviceId});

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  String? selectedDate;
  String? selectedTime;
  bool showFullDescription = false;

  final List<String> timeSlots = [
    "9:00AM - 10:00AM",
    "10:00AM - 11:00AM",
    "11:00AM - 12:00PM",
    "12:00PM - 1:00PM",
    "1:00PM - 2:00PM",
    "2:00PM - 3:00PM",
    "3:00PM - 4:00PM",
    "4:00PM - 5:00PM",
    "5:00PM - 6:00PM",
  ];

  String? _locationString;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      initialDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        selectedDate = "${picked.year}-${picked.month}-${picked.day}";
      });
    }
  }

  Future<void> _handleBookingAndPayment(dynamic service) async {
    if (selectedDate == null || selectedTime == null) {
      SnackbarUtils.showWarning(context, "Please select date and time");
      return;
    }

    if (_locationString == null || _locationString!.isEmpty) {
      SnackbarUtils.showWarning(context, "Please select location");
      return;
    }

    // Step 1: Create booking
    await ref
        .read(bookingViewModelProvider.notifier)
        .createBooking(
          serviceId: service.serviceId ?? "",
          bookingDate: selectedDate!,
          bookingTime: selectedTime!,
          price: service.price,
          location: _locationString!,
        );

    if (!mounted) return;

    final bookingState = ref.read(bookingViewModelProvider);

    if (bookingState.status == BookingStatus.error) {
      SnackbarUtils.showError(
        context,
        bookingState.errorMessage ?? "Booking failed",
      );
      return;
    }

    // Step 2: Get the created booking id
    final bookingId = bookingState.bookings.last.bookingId ?? "";

    // Step 3: Initiate payment
    final paymentUrl = await ref
        .read(paymentViewModelProvider.notifier)
        .initiatePayment(bookingId);

    if (!mounted) return;

    if (paymentUrl == null) {
      final paymentState = ref.read(paymentViewModelProvider);
      SnackbarUtils.showError(
        context,
        paymentState.errorMessage ?? "Payment initiation failed",
      );
      return;
    }

    // Step 4: Navigate to Khalti webview
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            PaymentWebviewScreen(paymentUrl: paymentUrl, bookingId: bookingId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final serviceState = ref.watch(serviceViewModelProvider);
    final bookingState = ref.watch(bookingViewModelProvider);
    final paymentState = ref.watch(paymentViewModelProvider);

    final service = serviceState.selectedService;

    if (service == null) {
      return const Scaffold(body: Center(child: Text("Service not selected")));
    }

    final descriptionText =
        showFullDescription || service.serviceDescription.length <= 150
        ? service.serviceDescription
        : "${service.serviceDescription.substring(0, 150)}...";

    // Show loading if either booking or payment is in progress
    final isLoading =
        bookingState.status == BookingStatus.loading ||
        paymentState.status == PaymentStatus.loading;

    return Scaffold(
      appBar: AppBar(title: Text(service.serviceName)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service Image
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                "${ApiEndpoints.imageBaseUrl}${service.serviceImage}",
                height: 170,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),

            // Service Name
            Text(
              service.serviceName,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Price
            Text("Rs. ${service.price}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),

            // Description
            Text(
              descriptionText,
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 15),
            ),
            if (service.serviceDescription.length > 150)
              GestureDetector(
                onTap: () {
                  setState(() {
                    showFullDescription = !showFullDescription;
                  });
                },
                child: Text(
                  showFullDescription ? "See Less" : "See More",
                  style: const TextStyle(
                    color: Color(0xFF006BAA),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            const SizedBox(height: 30),
            const Divider(),
            const SizedBox(height: 20),

            const Text(
              "Book This Service",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Location Picker
            LocationPickerWidget(
              onLocationPicked: (location) {
                setState(() {
                  _locationString = location;
                });
              },
            ),
            const SizedBox(height: 16),

            // Date Picker
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.calendar_today),
                        const SizedBox(width: 8),
                        Text(selectedDate ?? "Select Date"),
                      ],
                    ),
                    const Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Time Dropdown
            DropdownButtonFormField<String>(
              value: selectedTime,
              decoration: InputDecoration(
                labelText: "Select Time",
                prefixIcon: const Icon(Icons.access_time),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: timeSlots
                  .map(
                    (time) => DropdownMenuItem(value: time, child: Text(time)),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedTime = value;
                });
              },
            ),
            const SizedBox(height: 30),

            // Book & Pay Button
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : MyButton(
                    text: "Confirm & Pay",
                    onPressed: () => _handleBookingAndPayment(service),
                  ),
          ],
        ),
      ),
    );
  }
}
