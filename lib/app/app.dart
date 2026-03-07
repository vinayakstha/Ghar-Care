import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ghar_care/core/services/shake_service.dart';
import 'package:ghar_care/features/auth/presentation/pages/login_screen.dart';
import 'package:ghar_care/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:ghar_care/features/splash/presentation/pages/splash_screen.dart';
import 'package:ghar_care/app/theme/theme_data.dart';

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  static void setThemeMode(ThemeMode themeMode) {
    _AppState? state = _AppState._instance;
    if (state != null) {
      state.setState(() {
        _AppState._themeMode = themeMode;
      });
    }
  }

  static ThemeMode get currentThemeMode => _AppState._themeMode;

  @override
  ConsumerState<MyApp> createState() => _AppState();
}

class _AppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  static ThemeMode _themeMode = ThemeMode.system;
  static _AppState? _instance;
  late ShakeService _shakeService;
  bool _shakeTriggered = false;

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _instance = this;

    _shakeService = ShakeService();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startShakeListener();
    });
  }

  void _startShakeListener() {
    _shakeService.startListening(() {
      debugPrint('Shake detected - triggering logout');

      if (!_shakeTriggered) {
        _shakeTriggered = true;
        _handleShakeLogout();
      }
    });
  }

  Future<void> _handleShakeLogout() async {
    await ref.read(authViewModelProvider.notifier).logout();

    if (mounted && _navigatorKey.currentState != null) {
      _navigatorKey.currentState!.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _shakeService.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _shakeTriggered = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   navigatorKey: _navigatorKey,
    //   debugShowCheckedModeBanner: false,
    //   theme: getApplicationTheme(),
    //   home: const SplashScreen(),
    // );

    return GestureDetector(
      onDoubleTap: () {
        final currentMode = MyApp.currentThemeMode;
        final newMode = currentMode == ThemeMode.light
            ? ThemeMode.dark
            : ThemeMode.light;
        MyApp.setThemeMode(newMode);
      },
      child: MaterialApp(
        navigatorKey: _navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: getApplicationTheme(),
        darkTheme: getApplicationDarkTheme(),
        themeMode: _themeMode,
        home: Stack(children: [const SplashScreen()]),
      ),
    );
  }
}

// import 'dart:async'; // Needed for StreamSubscription
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:proximity_sensor/proximity_sensor.dart'; // Proximity sensor
// import 'package:ghar_care/core/services/shake_service.dart';
// import 'package:ghar_care/features/auth/presentation/pages/login_screen.dart';
// import 'package:ghar_care/features/auth/presentation/view_model/auth_view_model.dart';
// import 'package:ghar_care/features/splash/presentation/pages/splash_screen.dart';
// import 'package:ghar_care/app/theme/theme_data.dart';

// class MyApp extends ConsumerStatefulWidget {
//   const MyApp({super.key});

//   static void setThemeMode(ThemeMode themeMode) {
//     _AppState? state = _AppState._instance;
//     if (state != null) {
//       state.setState(() {
//         _AppState._themeMode = themeMode;
//       });
//     }
//   }

//   static ThemeMode get currentThemeMode => _AppState._themeMode;

//   @override
//   ConsumerState<MyApp> createState() => _AppState();
// }

// class _AppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
//   static ThemeMode _themeMode = ThemeMode.system;
//   static _AppState? _instance;

//   late ShakeService _shakeService;
//   bool _shakeTriggered = false;

//   final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

//   // Proximity sensor subscription
//   StreamSubscription<int>? _proximitySubscription;

//   @override
//   void initState() {
//     super.initState();
//     _instance = this;

//     _shakeService = ShakeService();
//     WidgetsBinding.instance.addObserver(this);

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _startShakeListener();
//       _startProximitySensor(); // Start listening to proximity sensor
//     });
//   }

//   void _startShakeListener() {
//     _shakeService.startListening(() {
//       debugPrint('Shake detected - triggering logout');

//       if (!_shakeTriggered) {
//         _shakeTriggered = true;
//         _handleShakeLogout();
//       }
//     });
//   }

//   Future<void> _handleShakeLogout() async {
//     await ref.read(authViewModelProvider.notifier).logout();

//     if (mounted && _navigatorKey.currentState != null) {
//       _navigatorKey.currentState!.pushAndRemoveUntil(
//         MaterialPageRoute(builder: (_) => const LoginScreen()),
//         (route) => false,
//       );
//     }
//   }

//   // Listen to the proximity sensor
//   void _startProximitySensor() {
//     _proximitySubscription = ProximitySensor.events.listen((int event) {
//       bool isNear = event > 0; // Convert int (0 or 1) to bool
//       debugPrint("Proximity sensor: ${isNear ? 'Near' : 'Far'}");

//       if (isNear) {
//         if (_themeMode != ThemeMode.dark) {
//           setState(() {
//             _themeMode = ThemeMode.dark;
//           });
//         }
//       } else {
//         if (_themeMode != ThemeMode.light) {
//           setState(() {
//             _themeMode = ThemeMode.light;
//           });
//         }
//       }
//     });
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     _shakeService.dispose();
//     _proximitySubscription?.cancel(); // Cancel sensor subscription
//     super.dispose();
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.resumed) {
//       _shakeTriggered = false;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onDoubleTap: () {
//         final currentMode = MyApp.currentThemeMode;
//         final newMode = currentMode == ThemeMode.light
//             ? ThemeMode.dark
//             : ThemeMode.light;
//         MyApp.setThemeMode(newMode);
//       },
//       child: MaterialApp(
//         navigatorKey: _navigatorKey,
//         debugShowCheckedModeBanner: false,
//         theme: getApplicationTheme(),
//         darkTheme: getApplicationDarkTheme(),
//         themeMode: _themeMode,
//         home: const SplashScreen(),
//       ),
//     );
//   }
// }
