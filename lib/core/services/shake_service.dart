import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final shakeServiceProvider = Provider<ShakeService>((ref) {
  return ShakeService();
});

class ShakeService {
  StreamSubscription<AccelerometerEvent>? _subscription;
  bool _isListening = false;

  DateTime? _lastShakeTime;
  static const double _shakeThreshold = 80.0;
  static const int _shakeCooldownMs = 1000;
  void startListening(void Function() onShakeDetected) {
    if (_isListening) return;
    _subscription = accelerometerEventStream().listen((
      AccelerometerEvent event,
    ) {
      final double acceleration = sqrt(
        event.x * event.x + event.y * event.y + event.z * event.z,
      );

      // Subtract gravity (approx 9.8) to get actual device acceleration
      final double netAcceleration = (acceleration - 9.8).abs();
      if (netAcceleration > _shakeThreshold) {
        final now = DateTime.now();

        // Add cooldown to prevent multiple triggers
        if (_lastShakeTime == null ||
            now.difference(_lastShakeTime!).inMilliseconds > _shakeCooldownMs) {
          _lastShakeTime = now;
          debugPrint('Shake detected! Acceleration: $netAcceleration');
          onShakeDetected();
        }
      }
    });

    _isListening = true;
  }

  void stopListening() {
    _subscription?.cancel();
    _subscription = null;
    _isListening = false;
    _lastShakeTime = null;
  }

  void dispose() {
    stopListening();
  }
}
