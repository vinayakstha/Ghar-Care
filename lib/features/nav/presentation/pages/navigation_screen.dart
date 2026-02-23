import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:ghar_care/features/favourite/presentation/pages/favourite_screen.dart';
import 'package:ghar_care/features/home/presentation/pages/home_screen.dart';
import 'package:ghar_care/features/auth/presentation/pages/profile_screen.dart';
import 'package:ghar_care/features/my_booking/presentation/pages/my_booking_screen.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _selectedIndex = 0;
  late StreamSubscription<GyroscopeEvent> _gyroscopeSubscription;

  final List<Widget> lstBottomScreen = [
    const HomeScreen(),
    const MyBookingScreen(),
    const FavouriteScreen(),
    const ProfileScreen(),
  ];

  // Threshold to detect significant tilt
  final double tiltThreshold = 7.0;

  @override
  void initState() {
    super.initState();

    _gyroscopeSubscription = gyroscopeEvents.listen((GyroscopeEvent event) {
      if (event.z > tiltThreshold) {
        _nextPage();
      }
    });
  }

  void _nextPage() {
    if (mounted) {
      setState(() {
        _selectedIndex = (_selectedIndex + 1) % lstBottomScreen.length;
      });
    }
  }

  @override
  void dispose() {
    _gyroscopeSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: lstBottomScreen[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: const Color(0xff006baa),
        iconSize: 30,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
        ],
      ),
    );
  }
}
