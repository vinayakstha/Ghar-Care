import 'dart:io';

import 'package:flutter/foundation.dart';

class ApiEndpoints {
  ApiEndpoints._();

  // Base URL - change this for production
  // static const String baseUrl = 'http://10.0.2.2:5050/api/';
  //static const String baseUrl = 'http://localhost:3000/api/v1';
  // For Android Emulator use: 'http://10.0.2.2:3000/api/v1'
  // For iOS Simulator use: 'http://localhost:5000/api/v1'
  // For Physical Device use your computer's IP: 'http://192.168.x.x:5000/api/v1'

  static const bool isPhysicalDevice = false;

  static const String compIpAddress = "1111.333";

  static String get baseUrl {
    if (isPhysicalDevice) {
      return "http://$compIpAddress:3000/api";
    }
    if (kIsWeb) {
      return "http://localhost:3000/api";
    } else if (Platform.isAndroid) {
      return "http://10.0.2.2:5050/api";
    } else if (Platform.isIOS) {
      return "http://localhost:3000/api";
    } else {
      return "http://10.0.2.2:5050/api";
    }
  }

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // ============ Auth Endpoints ============
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String updateProfile = '/user/update-profile';
  static const String getUserById = '/user/';
}
