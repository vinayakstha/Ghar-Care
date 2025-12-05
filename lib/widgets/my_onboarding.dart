import 'package:flutter/material.dart';

class MyOnboarding extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  const MyOnboarding({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(imagePath, height: 400),
        SizedBox(height: 30),
        Text(
          title,
          style: TextStyle(fontSize: 33, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
