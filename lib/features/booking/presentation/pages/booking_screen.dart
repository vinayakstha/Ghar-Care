import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ghar_care/core/widgets/my_button.dart';
import 'package:ghar_care/features/service/presentation/view_model/service_view_model.dart';

class BookingScreen extends ConsumerStatefulWidget {
  final String serviceId;

  const BookingScreen({super.key, required this.serviceId});

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  final _locationController = TextEditingController();
  String? selectedDate;
  String? selectedTime;

  bool showFullDescription = false; // Track description toggle

  final List<String> timeSlots = [
    "09:00 AM",
    "11:00 AM",
    "01:00 PM",
    "03:00 PM",
    "05:00 PM",
  ];

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

  @override
  Widget build(BuildContext context) {
    final serviceState = ref.watch(serviceViewModelProvider);
    final service = serviceState.selectedService;

    if (service == null) {
      return const Scaffold(body: Center(child: Text("Service not selected")));
    }

    // Determine description text to display
    final descriptionText =
        showFullDescription || service.serviceDescription.length <= 150
        ? service.serviceDescription
        : "${service.serviceDescription.substring(0, 150)}...";

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
                "http://192.168.18.3:5050${service.serviceImage}",
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
            Text(
              "Rs. ${service.price}",
              style: const TextStyle(fontSize: 18, color: Colors.black54),
            ),
            const SizedBox(height: 16),

            // Service Description with "See More"
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

            // Location Field
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: "Enter Location",
                prefixIcon: const Icon(Icons.location_on),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
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
                        Text(
                          selectedDate ?? "Select Date",
                          style: TextStyle(
                            color: selectedDate == null
                                ? Colors.grey
                                : Colors.black,
                          ),
                        ),
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

            // Book Now Button
            MyButton(
              text: "Book Now",
              onPressed: () {
                print("Book Now Clicked");
                print(
                  "Date: $selectedDate, Time: $selectedTime, Location: ${_locationController.text}",
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
