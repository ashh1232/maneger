import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maneger/controller/home_screen_controller.dart';
import 'package:maneger/screen/admin/admin_home.dart';
import 'package:maneger/screen/admin/edit_home_screen.dart';
import 'package:maneger/screen/delivery/deli_home.dart';
import 'package:maneger/screen/talabat/talabat_home_screen.dart'; // تأكد أن AniAppbarScreen مستوردة هنا

class HomeScreen extends GetView<HomeScreenController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // استدعاء الكنترولر
    // final controller = Get.find();

    return Scaffold(
      // استخدام IndexedStack يحافظ على حالة التمرير (Scroll Position) في AniAppbarScreen
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: [
            TalabatHomeScreen(), // التبويب الرئيسي
            DeliHome(),
            AdminHome(),
            const Center(child: Text("Settings/Profile")),
          ],
        ),
      ),

      bottomNavigationBar: Obx(
        () => SizedBox(
          height: controller.show.value ? 70 : 0,
          child: BottomNavigationBar(
            currentIndex: controller.currentIndex.value,
            onTap: (index) {
              controller.currentIndex.value = index;
            },
            // تحسينات بصرية لعام 2026
            selectedItemColor: Theme.of(context).primaryColor,
            unselectedItemColor: Colors.grey,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            elevation: 10,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'الرئيسية',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.delivery_dining_outlined),
                activeIcon: Icon(Icons.delivery_dining),
                label: 'التوصيل',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.admin_panel_settings_outlined),
                activeIcon: Icon(Icons.admin_panel_settings),
                label: 'الإدارة',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'حسابي',
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: null, // تعطيل الأنميشن التلقائي لحل المشكلة

        onPressed: () {
          controller.show.value = !controller.show.value;
        },
        mini: true,
        foregroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.show_chart),
      ),
    );
  }
}
