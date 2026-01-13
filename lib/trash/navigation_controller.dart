import 'package:get/get.dart';

class NavigationController extends GetxController {
  final RxInt currentIndex = 0.obs;

  void changePage(int index) {
    currentIndex.value = index;

    // Navigate to different pages based on index
    switch (index) {
      case 0:
        Get.offAllNamed('/');
        break;
      case 1:
        Get.offAllNamed('/shein');
        break;
      case 2:
        Get.toNamed('/cartPage');
        break;
      case 3:
        Get.toNamed('/favorites');
        break;
      case 4:
        Get.toNamed('/profile');
        break;
    }
  }

  void setIndex(int index) {
    currentIndex.value = index;
  }
}
