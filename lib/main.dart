import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:maneger/binding/home_binding.dart';
import 'package:maneger/service/my_theme.dart';
import 'package:maneger/service/theme_service.dart';

import 'routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init(); // Initialize storage
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
      locale: const Locale('ar', 'AE'),
      fallbackLocale: const Locale('en', 'US'),

      debugShowCheckedModeBanner: false,

      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl, // Ensuring RTL for Arabic
          child: child!,
        );
        // return Overlay(
        //   initialEntries: [OverlayEntry(builder: (context) => child!)],
        // );
      },
      // home: const ProductListScreen(),
    );
  }

  // String _getInitialRoute() {
  //   final authController = Get.find<AuthController>();
  //   return authController.isLoggedIn.value ? AppRoutes.home : AppRoutes.login;
  // }
}
