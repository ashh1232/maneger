import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maneger/controller/delivery_controller/delivery_home_controller.dart';
import 'package:maneger/screen/delivery/deli_order.dart';
import 'package:maneger/test/dahria_map.dart';
import 'package:maneger/screen/delivery/deli_profile.dart';

class DeliHome extends StatelessWidget {
  DeliHome({super.key});
  final DeliveryHomeController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text("قائمة الطلبات")), // إضافة عنوان
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: [
            DeliOrder(), // التبويب الرئيسي
            DahriaMap(),
            DeliProfile(),
          ],
        ),
      ),

      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: (index) {
            controller.currentIndex.value = index;
          },
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          elevation: 10,
          selectedFontSize: 12, // تصغير الخط قليلاً لتجنب الـ Overflow
          unselectedFontSize: 10,
          items: [
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
          ],
        ),
      ),
    );
  }
}
