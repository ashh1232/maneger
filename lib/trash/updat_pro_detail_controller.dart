// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:newmanager/class/handlingdatacontroll.dart';
// import 'package:newmanager/class/statusrequest.dart';
// import 'package:newmanager/trash/testcontroller.dart';
// import 'package:newmanager/data/remote/update_remote.dart';

// class DetailController extends GetxController {
//   late StatusRequest statusRequest;
//   ProductRemote productRemote = ProductRemote(Get.find());
//   var h = false; // Non-reactive variable
//   late TextEditingController nameController;
//   late TextEditingController priceController;
//   late TextEditingController descriptionController;
//   late TextEditingController imageController;
//   final String id = '1';
//   late String data;
//   TestController testControsller = Get.find();
//   void resetH() {
//     h = false;
//   }

//   void toggleH() {
//     h = !h;
//     update(); // Notify GetBuilder to rebuild
//   }

//   updateData(String id, Map<String, dynamic> data) async {
//     if (nameController.text != '' ||
//         priceController.text != '' ||
//         imageController.text != ''
//     // priceController
//     // imageController
//     ) {
//       try {
//         var k = data["product_price"];
//         nameController.text == ''
//             ? nameController.text = data['product_name']
//             : Get.snackbar('name', 'name');
//         priceController.text == ''
//             ? priceController.text = '$k'
//             : Get.snackbar('price', 'price');
//         imageController.text == ''
//             ? imageController.text = data['product_image']
//             : Get.snackbar('image', 'image');
//         statusRequest = StatusRequest.loading;

//         var respo = await productRemote.updateDate(
//           id,
//           nameController.text,
//           priceController.text,
//           imageController.text,
//         );
//         statusRequest = handlingData(respo);
//         testControsller.getData();
//         Get.snackbar('done', 'update');
//         nameController.text = '';
//         priceController.text = '';
//         imageController.text = '';

//         // print(respo['status']);
//         Get.offAndToNamed('/');
//       } catch (e) {
//         Get.snackbar('image', '$e');
//       }
//     } else {
//       Get.snackbar('error', 'no data');
//     }
//     update();
//   }

//   @override
//   void onInit() {
//     nameController = TextEditingController();
//     priceController = TextEditingController();
//     imageController = TextEditingController();
//     super.onInit();
//   }

//   @override
//   void dispose() {
//     nameController.dispose();
//     priceController.dispose();
//     imageController.dispose();
//     super.dispose();
//   }
// }
