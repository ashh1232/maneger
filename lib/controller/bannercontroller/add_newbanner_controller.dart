import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maneger/class/image_crud.dart';
import 'package:maneger/class/statusrequest.dart';
import 'package:maneger/linkapi.dart';
// import 'package:talabat_admin/class/image_crud.dart';
// import 'package:talabat_admin/class/statusrequest.dart';
// import 'package:talabat_admin/linkapi.dart';

class AddNewBannerController extends GetxController {
  ImageCrud crud = ImageCrud();
  var statusRequest = StatusRequest.offline.obs;

  var selectedImage = Rxn<File>();
  var isLoading = false.obs;

  // حقول إدخال البيانات
  late TextEditingController nameController;

  @override
  void onInit() {
    nameController = TextEditingController();
    super.onInit();
  }

  // فنكشن اختيار الصورة
  Future<void> pickImage() async {
    final XFile? image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (image != null) selectedImage.value = File(image.path);
  }

  // فنكشن إضافة المنتج والسيرفر
  // تأكد أن النوع هو Future<bool> وليس void
  Future<bool> addProduct() async {
    try {
      if (selectedImage.value == null || nameController.text.isEmpty) {
        Get.snackbar("تنبيه", "يرجى ملء جميع الحقول واختيار صورة");
        return false; // إرجاع false في حال عدم اكتمال البيانات
      }

      isLoading.value = true;

      var response = await crud.postRequestWithFile(AppLink.addnewbanner, {
        "name": nameController.text,
      }, selectedImage.value!);

      isLoading.value = false;

      // يجب استخدام return أمام fold ليعيد النتيجة النهائية
      // print(response['message']);
      return response.fold(
        (l) {
          Get.snackbar("خطأ", "فشل في الاتصال");
          return false;
        },
        (r) {
          if (r['status'] == "success") {
            return true; // نجاح العملية
          } else {
            Get.snackbar("تنبيه", "$r فشل إضافة المنتج");
            return false;
          }
        },
      );
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("خطأ", "حدث خطأ غير متوقع");
      return false;
    }
  }
}
