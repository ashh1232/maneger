// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:newmanager/class/crud.dart';
// import 'package:newmanager/class/statusrequest.dart';
// import 'package:newmanager/data/remote/test.dart';
// import 'package:newmanager/trash/product.dart';
// import 'dart:async';

// import '../class/handlingdatacontroll.dart';

// class AniAppbarController extends GetxController {
//   TestData testdata = TestData(Get.find());

//   final Crud crud = Crud();
//   List<Product> productList = [];
//   late StatusRequest statusRequest;
//   var currentBannerIndex = 0.obs;
//   final PageController pageController = PageController();
//   Timer? _bannerTimer;

//   // final RxInt currentBannerIndex = 0.obs;
//   final RxBool isScrolled = false.obs;

//   final List<String> banners = [
//     'https://www.shutterstock.com/shutterstock/photos/1841495716/display_1500/stock-vector-great-discount-sale-banner-design-in-d-illustration-on-blue-background-sale-word-balloon-on-1841495716.jpg',
//     'https://marketplace.canva.com/EAE6GJRFBO8/2/0/1600w/canva-red-and-white-modern-online-sale-and-discount-banner-EQntJWpYr4w.jpg',
//     'https://marketplace.canva.com/EAFooJN9KIw/2/0/400w/canva-yellow-red-modern-fried-chicken-promotion-banner-zaHTluSB__o.jpg',
//     'https://marketplace.canva.com/EAFooCj7wG0/3/0/1600w/canva-yellow-creative-noodle-food-promotion-banner-3SN7GKnyHMw.jpg',
//     'https://static.vecteezy.com/system/resources/previews/002/453/533/non_2x/big-sale-discount-banner-template-promotion-illustration-free-vector.jpg',
//   ];
//   getdata() async {
//     statusRequest = StatusRequest.loading;
//     var respo = await testdata.getdata();
//     statusRequest = handlingData(respo);

//     if (statusRequest == StatusRequest.success) {
//       if (respo['status'] == 'success') {
//         productList.clear();

//         // productList.addAll(respo['data']);
//         final List<dynamic> decodedList = respo['data'];
//         // 2. Map the dynamic list to a List of actual Product objects
//         final List<Product> fetchedProducts =
//             decodedList.map((item) {
//               return Product.fromJson(item as Map<String, dynamic>);
//             }).toList();

//         productList.addAll(fetchedProducts);
//       }
//     }
//   }

//   @override
//   void onInit() {
//     super.onInit();
//     // pageController = PageController();
//     _startBannerAutoPlay();
//     getdata();
//   }

//   void _startBannerAutoPlay() {
//     _bannerTimer = Timer.periodic(Duration(seconds: 4), (_) {
//       // Check clients *before* calculation
//       if (!pageController.hasClients || banners.isEmpty) return;

//       final next = (currentBannerIndex.value + 1) % banners.length;

//       // Use jumpToPage if you don't need the animation,
//       // which is slightly safer during rapid changes
//       // pageController.jumpToPage(next);

//       // Or keep animateToPage with careful usage:
//       pageController.animateToPage(
//         next,
//         duration: Duration(milliseconds: 500),
//         curve: Curves.easeInOut,
//       );
//       setBannerIndex(next);
//     });
//   }

//   void setBannerIndex(int index) {
//     currentBannerIndex.value = index;
//   }

//   void toggleScroll(bool value) {
//     isScrolled.value = value;
//   }

//   @override
//   void onClose() {
//     _bannerTimer?.cancel();
//     pageController.dispose();
//     super.onClose();
//   }
// }
