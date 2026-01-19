import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:maneger/binding/home_binding.dart';
import 'package:maneger/core/di/injection.dart'; // NEW: DI
import 'package:maneger/service/my_theme.dart';
import 'package:maneger/service/theme_service.dart';
import 'routes.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize storage
  await GetStorage.init();

  // NEW: Initialize Clean Architecture dependencies
  // This sets up encryption, secure storage, API client, and all use cases
  await DependencyInjection.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // final initialTheme = ThemeService().theme;

    return GetMaterialApp(
      title: 'manager app',
      // Theme Configuration
      theme: MyThemes.light,
      darkTheme: MyThemes.dark,
      themeMode: ThemeService().theme, // Loads saved theme from GetStorage
      // Routing
      initialBinding: HomeBinding(),
      initialRoute: AppRoutes.home,
      getPages: AppRoutes.routes,

      // Localization
      locale: const Locale('ar', 'SA'),
      fallbackLocale: const Locale('en', 'US'),

      debugShowCheckedModeBanner: false,

      // home: const ProductListScreen(),
    );
  }

  // String _getInitialRoute() {
  //   final authController = Get.find<AuthController>();
  //   return authController.isLoggedIn.value ? AppRoutes.home : AppRoutes.login;
  // }
}
