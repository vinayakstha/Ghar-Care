import 'package:flutter/material.dart';

class BookingScreen extends StatelessWidget {
  final String serviceId;
  final String serviceName;
  final String price;
  final String imageUrl;

  const BookingScreen({
    super.key,
    required this.serviceId,
    required this.serviceName,
    required this.price,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(serviceName)),
      body: Center(
        child: Text(
          "Booking for $serviceName\nPrice: $price",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
