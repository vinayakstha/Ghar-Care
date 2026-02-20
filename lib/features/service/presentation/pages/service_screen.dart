import 'package:flutter/material.dart';

class ServiceScreen extends StatelessWidget {
  final String categoryId;
  final String categoryName;

  const ServiceScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(categoryName)),
      body: Center(child: Text('Services for Category ID: $categoryId')),
    );
  }
}
