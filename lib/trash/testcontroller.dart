// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:newmanager/class/handlingdatacontroll.dart';
// import 'package:newmanager/class/statusrequest.dart';
// import 'package:newmanager/data/remote/test.dart';
// import 'package:newmanager/routes.dart';

// class TestController extends GetxController {
//   TestData testdata = TestData(Get.find());
//   final PageController pageController = PageController();

//   List data = [];
//   List cat = [];
//   List proCat = [];
//   List mcat = [];
//   List scat = [];
//   int currentMainSel = 0;
//   int currentsCat = 0;
//   late StatusRequest statusRequest;

//   void mCatSel(int id, index) {
//     currentMainSel = index;
//     scat = [];
//     proCat = [];
//     if (index == 0) {
//       scat.addAll(cat);
//       proCat.addAll(data);
//     } else {
//       scat.addAll(cat.where((test) => test['m_cat_id'] == id));
//       scat.forEach(
//         (e) => proCat.addAll(
//           data.where((tes) => (tes['categories_id'] == e['categories_id'])),
//         ),
//       );
//     }
//     update();
//   }

//   void sCatSel(int id, int index) {
//     currentsCat = index;
//     proCat = [];
//     proCat.addAll(data.where((tes) => (tes['categories_id'] == id)));
//     update();
//   }

//   gotoAdd() {
//     Get.toNamed(AppRoutes.addscreen);
//   }

//   getData() async {
//     statusRequest = StatusRequest.loading;
//     var respo = await testdata.getdata();
//     statusRequest = handlingData(respo);
//     if (statusRequest == StatusRequest.success) {
//       if (respo['status'] == "success") {
//         data.clear();
//         data.addAll(respo['data']);
//         proCat.clear();

//         proCat.addAll(respo['data']);
//       } else {
//         statusRequest = StatusRequest.failure;
//       }
//     }
//     update();
//   }

//   getCat() async {
//     statusRequest = StatusRequest.loading;
//     var res = await testdata.getCatt();
//     statusRequest = handlingData(res);
//     if (statusRequest == StatusRequest.success) {
//       if (res['status'] == 'success') {
//         cat.clear();
//         scat.clear();
//         cat.addAll(res['data']);
//         scat.addAll(res['data']);

//         for (int h = 0; h < cat.length; h++) {
//           if (mcat.isEmpty) {
//             mcat.add(cat[h]);
//           } else {
//             bool dd = true;
//             for (int k = 0; k < mcat.length; k++) {
//               if (mcat[k]['m_cat_name'] == cat[h]['m_cat_name']) {
//                 dd = false;
//               }
//             }
//             if (dd == true) {
//               mcat.add(cat[h]);
//             }
//           }
//         }
//       } else {
//         statusRequest = StatusRequest.failure;
//       }
//     }
//     update();
//   }

//   @override
//   void onInit() {
//     getData();
//     getCat();
//     super.onInit();
//   }

//   bool isNavCatVisible = false;
//   RxInt currentPage = 0.obs;
//   void updatePage(int index) {
//     currentPage.value = index;
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
