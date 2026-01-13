// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../class/api_service.dart';

// class HomeController extends GetxController {
//   final ApiService apiService = Get.find();
//   final PageController pageController = PageController();
//   var data = ''.obs;
//   var isNavCatVisible = false;
//   RxInt currentPage = 0.obs;

//   void updatePage(int index) {
//     currentPage.value = index;
//   }

//   void loadData() async {
//     data.value = await apiService.fetchData();
//   }

//   @override
//   void onInit() {
//     super.onInit();
//     loadData();
//   }

//   void toggleNavCat() {
//     (() {
//       isNavCatVisible = !isNavCatVisible;
//     });
//     update();
//   }

//   @override
//   void onClose() {
//     pageController.dispose();
//     super.onClose();
//   }
// }
