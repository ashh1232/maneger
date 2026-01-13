import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maneger/class/handlingdatacontroll.dart';
import 'package:maneger/class/statusrequest.dart';
import 'package:maneger/data/remote/update_remote.dart';
import 'package:maneger/routes.dart';

class AddController extends GetxController {
  // TestController testControsller = Get.put(TestController());
  ProductRemote productRemote = ProductRemote(Get.find());
  late StatusRequest statusRequest;

  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController descriptionController;
  late TextEditingController imageController;
  late TextEditingController proCat;
  int curent = 0;
  @override
  void onInit() {
    nameController = TextEditingController();
    priceController = TextEditingController();
    imageController = TextEditingController();
    proCat = TextEditingController();
    super.onInit();
  }

  String selCattt(int inn, String id) {
    curent = inn;
    proCat.text = id;
    update();
    return proCat.text;
  }

  Future<void> addNewData() async {
    try {
      statusRequest = StatusRequest.loading;
      var respo = await productRemote.addData(
        nameController.text,
        priceController.text,
        imageController.text,
        proCat.text,
      );
      statusRequest = handlingData(respo);
      if ((respo as Map)['status'] == 'success') {
        if (respo['status'] == 'success') {
          Get.snackbar('add data ', 'Success');
          // testControsller.getData();
        } else {}
      }
    } catch (s) {
      Get.snackbar('title', 'message  $s');
    }

    update();
    Get.offAndToNamed(AppRoutes.home);
  }
}
