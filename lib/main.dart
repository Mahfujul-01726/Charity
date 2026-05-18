import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app/core/theme/app_theme.dart';

import 'app/controllers/theme_controller.dart';
import 'app/controllers/user_controller.dart';
import 'app/controllers/auth_controller.dart';
import 'app/screens/splash_screen.dart';
import 'app/screens/auth/login_screen.dart';
import 'app/screens/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) => Get.put(AuthController()));

  // Set system UI overlays
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const HelpConnectApp());
}

class HelpConnectApp extends StatelessWidget {
  const HelpConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.put(ThemeController());
    Get.put(UserController()); // Initialize UserController

    return Obx(() {
      // Update system navigation bar color based on theme
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
      );

      return GetMaterialApp(
        title: 'HelpConnect',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeController.isDarkMode
            ? ThemeMode.dark
            : ThemeMode.light,
        initialRoute: '/',
        getPages: [
          GetPage(name: '/', page: () => const SplashScreen()),
          GetPage(
            name: '/login',
            page: () => const LoginScreen(),
            transition: Transition.fade,
          ),
          GetPage(
            name: '/home',
            page: () => const HomeScreen(),
            transition: Transition.fade,
          ),
        ],
        defaultTransition: Transition.fade,
        transitionDuration: const Duration(milliseconds: 300),
      );
    });
  }
}
