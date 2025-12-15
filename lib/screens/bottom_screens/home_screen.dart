import 'package:flutter/material.dart';
import 'package:ghar_care/widgets/home_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Column(
        children: [
          HomeHeader(),

          Expanded(child: SingleChildScrollView(child: SizedBox(height: 1000))),
        ],
      ),
    );
  }
}
