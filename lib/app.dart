import 'package:flutter/material.dart';
import 'package:ghar_care/screens/navigation_screen.dart';
import 'package:ghar_care/screens/splash_screen.dart';
import 'package:ghar_care/theme/theme_data.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: getApplicationTheme(),
      home: SplashScreen(),
    );
  }
}
