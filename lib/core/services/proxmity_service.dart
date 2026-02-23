// lib/core/services/proximity_service.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:proximity_sensor/proximity_sensor.dart';

class ProximityService {
  StreamSubscription<int>? _subscription;

  void startListening(VoidCallback onNear, VoidCallback onFar) {
    _subscription = ProximitySensor.events.listen((int event) {
      final isNear = event == 1; // 1 = near, 0 = far
      if (isNear) {
        onNear();
      } else {
        onFar();
      }
    });
  }

  void dispose() {
    _subscription?.cancel();
    _subscription = null;
  }
}
